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
  String? _selectedFaculty;

  Future<void> register() async {
    if (_idController.text.isEmpty || _nameController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.190:3000/register'),
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
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("เชื่อมต่อเซิร์ฟเวอร์ไม่ได้")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode 
        ? Colors.white54 
        : const Color.fromARGB(255, 22, 48, 141);

    return Scaffold(
      appBar: AppBar(title: const Text("ลงทะเบียนนักศึกษาใหม่")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            
            _buildTextField(_idController, "รหัสนักศึกษา", Icons.badge, isDarkMode, borderColor),
            const SizedBox(height: 15),
            _buildTextField(_nameController, "ชื่อ-นามสกุล", Icons.person, isDarkMode, borderColor),
            const SizedBox(height: 15),
            _buildTextField(_passController, "รหัสผ่าน", Icons.lock, isDarkMode, borderColor, isObscure: true),
            const SizedBox(height: 15),
            
            // Dropdown 
            DropdownButtonFormField<String>(
              value: _selectedFaculty,
              decoration: InputDecoration(
                labelText: "คณะ",
                labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : borderColor),
                prefixIcon: Icon(Icons.school, color: borderColor),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: borderColor, width: 2.5),
                ),
              ),
              items: ['ICT', 'EG', 'SC', 'EN', 'SS', 'LA','PT','CRS','MS','IC','NS','MT','NR','VS','PH','SH' ,'TM']
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedFaculty = v!),
            ),
            
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity, 
              height: 55,
              child: ElevatedButton(
                onPressed: register, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 22, 48, 141),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ), 
                child: const Text("ยืนยันการลงทะเบียน", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isDark, Color borderColor, {bool isObscure = false}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: borderColor),
        labelStyle: TextStyle(color: isDark ? Colors.white70 : borderColor),
        filled: true,
        fillColor: isDark ? Colors.grey[900] : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor, width: 2.5),
        ),
      ),
    );
  }
}
