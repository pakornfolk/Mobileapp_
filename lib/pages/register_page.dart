import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  String _selectedFaculty = 'ICT'; // ค่าเริ่มต้น

  Future<void> register() async {
    if (_idController.text.isEmpty || _nameController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/register'), // อย่าลืมเช็ค IP
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "student_id": _idController.text,
          "username": _nameController.text,
          "password": _passController.text,
          "faculty": _selectedFaculty,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ลงทะเบียนสำเร็จ! กรุณาเข้าสู่ระบบ")));
        Navigator.pop(context); // ลงทะเบียนเสร็จให้กลับไปหน้า Login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("เชื่อมต่อเซิร์ฟเวอร์ไม่ได้")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ลงทะเบียนนักศึกษาใหม่")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 80, color: Color.fromARGB(255, 22, 48, 141)),
            const SizedBox(height: 20),
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "รหัสนักศึกษา", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "ชื่อ-นามสกุล", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "รหัสผ่าน", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedFaculty,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "คณะ"),
              items: ['ICT', 'EG', 'SC', 'EN', 'SS', 'LA','PT','CRS','MS','IC','NS','MT','NR','VS','PH','SH' ,'TM'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (v) => setState(() => _selectedFaculty = v!),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(onPressed: register, style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 22, 48, 141)), child: const Text("ยืนยันการลงทะเบียน", style: TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}