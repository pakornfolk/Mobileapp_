import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _idController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _loading = false;

  Future<void> resetPassword() async {
    if (_idController.text.trim().isEmpty ||
        _newPassController.text.trim().isEmpty ||
        _confirmPassController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')),
      );
      return;
    }

    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await http.post(
        Uri.parse('http://192.168.1.190:3000/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_id': _idController.text.trim(),
          'new_password': _newPassController.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);

      if (data['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'เกิดข้อผิดพลาด')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('เปลี่ยนรหัสผ่านเรียบร้อย'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เชื่อมต่อเซิร์ฟเวอร์ไม่ได้')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode 
        ? Colors.white54 
        : const Color.fromARGB(255, 22, 48, 141);

    return Scaffold(
      appBar: AppBar(title: const Text('ลืมรหัสผ่าน')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Icon(Icons.lock_reset, size: 80, color: Colors.green),
            const SizedBox(height: 30),
            
            _buildTextField(_idController, 'รหัสนักศึกษา', Icons.badge, isDarkMode, borderColor, TextInputType.number),
            const SizedBox(height: 15),
            _buildTextField(_newPassController, 'รหัสผ่านใหม่', Icons.lock_outline, isDarkMode, borderColor, TextInputType.text, isObscure: true),
            const SizedBox(height: 15),
            _buildTextField(_confirmPassController, 'ยืนยันรหัสผ่านใหม่', Icons.lock_clock, isDarkMode, borderColor, TextInputType.text, isObscure: true),
            
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _loading ? null : resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 22, 48, 141),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('ยืนยันเปลี่ยนรหัสผ่าน', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isDark, Color borderColor, TextInputType type, {bool isObscure = false}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: type,
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