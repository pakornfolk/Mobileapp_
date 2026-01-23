CREATE DATABASE reportapp;
USE reportapp;

--  ตารางแจ้งปัญหา (Report)
CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(10) NOT NULL,
    issue_detail TEXT,
    service_type VARCHAR(50) NOT NULL,
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางผู้ใช้ (Profile/Point)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(10),
    username VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    point INT DEFAULT 0,
    faculty VARCHAR(100)
);
SELECT *
FROM users
ORDER BY point DESC; -- เรียงลำดับรายชื่อตาม point ตากมากไปน้อย ถ้าน้อยไปมากจะใช้ ASC

DELETE FROM users
WHERE id = 5; -- ลบข้อมูลในตาราง

-- เพิ่มข้อมูลนักศึกษาตัวอย่างสำหรับทดสอบ Login
INSERT INTO users (student_id, username, password, point, faculty) VALUES 
('6787052', 'Pakornkiat Vonma', '123456', 80,'ICT'),
('6787119', 'Supakit Pitisan', '123456', 10,'ICT');

CREATE TABLE service_locations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  service_name VARCHAR(255) NOT NULL,
  service_type VARCHAR(50) NOT NULL,   -- Water / other
  building VARCHAR(100) NOT NULL,       -- อาคาร MLC, ICT, หอสมุด
  note VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO service_locations 
(service_name, service_type, building, note)
VALUES
('ตู้กดน้ำ ', 'Water', 'อาคาร ICT','ชั้น1'),
('ตู้กดน้ำสะอาด', 'Water', 'อาคาร MLC', 'หน้าทางเข้าห้องน้ำ ชั้น1'),
('จุดคัดแยกขยะ', 'Waste', 'หอสมุดและคลังความรู้ ','หน้าทางเข้าห้องสมุด');

UPDATE service_locations
SET service_type = 'Waste',
	service_name = 'จุดคัดแยกขยะ'
WHERE id = 2;


select * from reports;
select * from service_locations;
select * from users;

DESCRIBE users;


CREATE USER 'user'@'localhost' IDENTIFIED BY 'pakorn2549';
GRANT ALL PRIVILEGES ON reportapp.* TO 'user'@'localhost';
FLUSH PRIVILEGES; -- 3 อย่างนี้คือการให้สิทธิ์รูท หากเกิดการผิดพลาด ถ้าเข้าถึง  root@localhost ไม่ได้  ก็เพิ่มใหม่แล้วให้สิทธิ์ใหม่เลยพร้อมรหัสด้วย ต้องใช้ชื่อให้ดาต้าเบสที่สร้างไว้ด้วย เอาให้ตรงทั้งหมด

SHOW DATABASES LIKE '%report%'; -- check databasename ต้องตรงกับใน server.js




