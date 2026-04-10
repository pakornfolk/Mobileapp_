import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mb_app/apiconfig/api_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController(); // ✅ เพิ่ม
  String? _selectedFaculty;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true; // ✅ เพิ่ม

  Future<void> register() async {
    if (_idController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _passController.text.isEmpty ||
        _confirmPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")),
      );
      return;
    }

    // ✅ เช็ครหัสตรงกัน
    if (_passController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ลงทะเบียนสำเร็จ! กรุณาเข้าสู่ระบบ")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เชื่อมต่อเซิร์ฟเวอร์ไม่ได้")),
      );
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

            // password
            _buildPasswordField(
              controller: _passController,
              label: "รหัสผ่าน",
              icon: Icons.lock,
              isDark: isDarkMode,
              borderColor: borderColor,
              obscure: _obscurePassword,
              onToggle: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),

            const SizedBox(height: 15),

            // confirm password
            _buildPasswordField(
              controller: _confirmPassController,
              label: "ยืนยันรหัสผ่าน",
              icon: Icons.lock_outline,
              isDark: isDarkMode,
              borderColor: borderColor,
              obscure: _obscureConfirmPassword,
              onToggle: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),

            const SizedBox(height: 15),

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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "ยืนยันการลงทะเบียน",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isDark,
    Color borderColor,
  ) {
    return TextField(
      controller: controller,
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

  // password + confirm ใช้ตัวเดียวกัน
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    required Color borderColor,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: borderColor),
        labelStyle: TextStyle(color: isDark ? Colors.white70 : borderColor),

        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility : Icons.visibility_off,
            color: borderColor,
          ),
          onPressed: onToggle,
        ),

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
