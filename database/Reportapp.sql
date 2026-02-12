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
('ตู้กดน้ำสะอาด', 'Water', 'อาคาร MLC', 'ใกล้จุดคืนภาชนะใส่อาหาร'),
('ตู้กดน้ำ ', 'Water', 'คณะศิลปะศาสตร์','จำนวน 2 ตู้ บริเวณชั้น1 ใกล้กับห้องน้ำ'),
('ตู้กดน้ำ ', 'Water', 'อุุทยานธรรมชาติวิทยาสิริรุกขชาติ','บริเวณทางเข้าด้านใน'),
('ตู้กดน้ำ ', 'Water', 'ลานดอกกันภัย','ติดกับผนังกำแพง'),

('จุดคัดแยกขยะ', 'Waste', 'หอสมุดและคลังความรู้ ','หน้าทางเข้าห้องสมุด'),
('จุดคัดแยกขยะ', 'Waste', 'สถาบันชีววิทยาศาสตร์โมเลกุล', ' บริเวณป้าย Bus stop'),
('จุดคัดแยกขยะ','Waste',' ป้าย Bus stop','บริเวณประตู 4'),
('จุดคัดแยกขยะ','Waste','คณะศิลปะศาสตร์','บริเวณหน้าห้องน้ำชั้น 2'),
('จุดคัดแยกขยะ','Waste','คณะวิทยาศาสตร์','บริเวณป้าย Bus stop'),
('จุดคัดแยกขยะ','Waste','อาคารจอดรถสิทธาคาร','บริเวณป้าย Bus stop'),
('จุดคัดแยกขยะ','Waste','ศูนย์อาหาร MLC','บริเวณจุดคือภาชนะใส่อาหาร'),
('จุดคัดแยกขยะ','Waste','อาคาร MLC','บริเวณหน้าห้องนิทรรศการ'),
('จุดคัดแยกขยะ','Waste','อาคาร MLC','หน้าห้องชมรมภาษาอังกฤษ'),
('จุดคัดแยกขยะ','Waste','อาคาร MLC','หน้าห้องน้ำชายชั้น 1'),
('จุดคัดแยกขยะ','Waste','อาคาร MLC','หน้าร้านสะดวกซื้อ 7-11'),
('จุดคัดแยกขยะ','Waste','อาคาร MLC','บริเวณ True Lab ชั้น2');

INSERT INTO service_locations
(service_name, service_type, building, note)
VALUES
('ด้านสุขภาพและฉุกเฉิน ', 'Health', 'Mu health','ชั้น1 อาคาร MLC'),
('ด้านสุขภาพและฉุกเฉิน ', 'Health', 'ศูนย์แพทย์กาญจาภิเษก','ตรงข้ามประตูฝั่งทางออก 1 ( เปิด 7.00-20.00 )'),
('ด้านสุขภาพและฉุกเฉิน ', 'Health', 'คลินิกวัยทีน (Adolescent Clinic)','อาคารปัญญาวัฒนา สถาบันแห่งชาติเพื่อการพัฒนาเด็กและครอบครัว'),
('ด้านสุขภาพและฉุกเฉิน ', 'Health', 'หน่วยปฏิบัติการฉุกเฉิน Mahidol ERT','หอพักลีลาวดี ( หอ 10 )');

insert into service_locations (service_name,service_type,building,note)
value
('สนามเทนนิส','Stadium','Tennis court','ใกล้กับคณะศิลปะศาสตร์');

insert into service_locations (service_name,service_type,building)
value
('สนามวอลเลย์บอล1', 'Stadium', 'ลานกีฬาเพื่อสุขภาพ'),
('สนามบาสเกตบอล1,2', 'Stadium', 'ลานกีฬาเพื่อสุขภาพ'),
('สนามบาสเกตบอล', 'Stadium', 'โรงช้าง'),
('สนามวอลเลย์บอล', 'Stadium', 'โรงช้าง');

INSERT INTO service_locations
(service_name, service_type, building)
VALUES
('การเดินทาง', 'Shuttle bus', 'บริการรับ-ส่งฟรี ศาลายา-พญาไท-บางกอกน้อย-สถานีรถไฟฟ้าบางหว้า');

select * from reports;
select * from service_locations;
select * from users;


CREATE USER 'user'@'localhost' IDENTIFIED BY 'pakorn2549';
GRANT ALL PRIVILEGES ON reportapp.* TO 'user'@'localhost';
FLUSH PRIVILEGES; -- 3 อย่างนี้คือการให้สิทธิ์รูท หากเกิดการผิดพลาด ถ้าเข้าถึง  root@localhost ไม่ได้  ก็เพิ่มใหม่แล้วให้สิทธิ์ใหม่เลยพร้อมรหัสด้วย ต้องใช้ชื่อให้ดาต้าเบสที่สร้างไว้ด้วย เอาให้ตรงทั้งหมด

SHOW DATABASES LIKE '%report%'; -- check databasename ต้องตรงกับใน server.js




