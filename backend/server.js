const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

const db = mysql.createPool({
    host: 'localhost',
    user: 'user',
    password: 'pakorn2549',
    database: 'reportapp',
    port: 3306
});

app.get('/', (req, res) => {
  res.send('Server is running');
}); // อันนี้เอาไว้เช็คตอนเปิดโครมผ่านมือถือ (*แต่เปิดตัวแอพไม่ได้นะจ้ะ)

// 1. Login API
app.post('/login', (req, res) => {
  const { student_id, password } = req.body;

  if (!student_id || !password) {
    return res.status(400).json({
      success: false,
      message: 'กรุณากรอกข้อมูลให้ครบ',
    });
  }

  const sql = 'SELECT student_id, username, faculty, point FROM users WHERE student_id = ? AND password = ?';

  db.query(sql, [student_id, password], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({
        success: false,
        message: 'Database error',
      });
    }

    if (results.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'รหัสนักศึกษาหรือรหัสผ่านไม่ถูกต้อง',
      });
    }

    // ✅ ส่ง response ให้ตรงกับ Flutter 100%
    return res.status(200).json({
      success: true,
      user: {
        student_id: results[0].student_id,
        username: results[0].username,
        faculty: results[0].faculty,
        point: results[0].point,
      },
    });
  });
});

// 2. Register API
app.post('/register', (req, res) => {
    const { student_id, username, password, faculty } = req.body;
    db.query('INSERT INTO users (student_id, username, password, faculty, point) VALUES (?, ?, ?, ?, 0)', 
    [student_id, username, password, faculty], (err) => {
        if (err) return res.status(500).json({ success: false, message: 'มีบัญชีผู้ใช้แล้ว' });
        res.json({ success: true });
    });
});

// 3. Real-time User Profile API
app.get('/user-profile/:student_id', (req, res) => {
    db.query('SELECT * FROM users WHERE student_id = ?', [req.params.student_id], (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results[0]);
    });
});

// 4. Report API (ฉบับแก้ไขให้ตรงกัน)
app.post('/report', (req, res) => {
    const { student_id, issue_detail, service_type } = req.body;

    // 1. เช็คข้อมูลให้ครบ (3 อย่าง)
    if (!student_id || !issue_detail || !service_type) {
        return res.status(400).json({ message: 'ข้อมูลไม่ครบ' });
    }

    // 2. ปรับ INSERT ให้มี 3 คอลัมน์ ให้ตรงกับ 3 เครื่องหมาย ? และ 3 ตัวแปรใน [ ]
    const sqlInsert = 'INSERT INTO reports (student_id, issue_detail, service_type) VALUES (?, ?, ?)';
    
    db.query(sqlInsert, [student_id, issue_detail, service_type], (err) => {
        if (err) {
            console.error("Database Error:", err);
            return res.status(500).json({ message: 'Error', detail: err });
        }

        // 3. ส่วนเช็คโควตา 3 ครั้งต่อวัน
        const checkLimitSql = `
            SELECT COUNT(*) as report_count 
            FROM reports 
            WHERE student_id = ? AND DATE(report_date) = CURDATE()
        `;
        
        db.query(checkLimitSql, [student_id], (errLimit, results) => {
            if (errLimit) return res.status(500).json(errLimit);
            const count = results[0].report_count;

            if (count <= 3) {
                db.query(
                    'UPDATE users SET point = point + 10 WHERE student_id = ?',
                    [student_id],
                    (errUpdate) => {
                        if (errUpdate) return res.status(500).json(errUpdate);
                        res.json({ success: true, message: `ส่งสำเร็จ +10 PTS (${count}/3 ครั้ง)` });
                    }
                );
            } else {
                res.json({ success: true, message: 'ส่งสำเร็จ! (ไม่ได้รับเเต้ม เนื่องจากครบกำหนด 3 ครั้งต่อวัน)' });
            }
        });
    });
});


// 5. Personal History API (ดึงเฉพาะของตัวเอง)
app.get('/report-history/:student_id', (req, res) => {
  const sql = `
    SELECT 
      report_id,
      issue_detail,
      service_type,
      report_date
    FROM reports
    WHERE student_id = ?
    ORDER BY report_id DESC
  `;

  db.query(sql, [req.params.student_id], (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});


// 6. Ranking & Locations
app.get('/ranking', (req, res) => {
    db.query('SELECT username, faculty, point FROM users ORDER BY point DESC', (err, results) => res.json(results));
});



app.get('/service-locations', (req, res) => {
  const sql = 'SELECT * FROM service_locations ORDER BY id DESC';
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

app.listen(3000, '0.0.0.0', () => console.log('Server is running on port 3000'));
