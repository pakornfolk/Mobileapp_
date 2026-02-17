// login_page.dart (ฉบับเต็ม - ปรับปรุง UI และแก้เส้นขอบ)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> loginProcess() async {
  if (_idController.text.trim().isEmpty ||
      _passController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.190:3000/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'student_id': _idController.text.trim(),
        'password': _passController.text.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'เข้าสู่ระบบไม่สำเร็จ')),
      );
      return;
    }

    final String studentId = data['user']['student_id'].toString();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(studentId: studentId),
      ),
    );
  } catch (e) {

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้")),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final borderColor = isDarkMode
        ? Colors.white54
        : const Color.fromARGB(255, 22, 48, 141);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        child: Column(
          children: [
            const Icon(Icons.eco, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "MU Green & Clean",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "มหาวิทยาลัยสีเขียว เริ่มต้นที่ตัวคุณ",
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),

            //รหัสนักศึกษา 
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "รหัสนักศึกษา",
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : borderColor,
                ),
                prefixIcon: Icon(Icons.badge, color: borderColor),
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
            ),

            const SizedBox(height: 20),

            //รหัสผ่าน
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "รหัสผ่าน",
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : borderColor,
                ),
                prefixIcon: Icon(Icons.lock, color: borderColor),
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
            ),

            // ลืมรหัสผ่าน
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: Text(
                  "ลืมรหัสผ่าน?",
                  style: TextStyle(
                    color: isDarkMode
                        ? Colors.amber.withOpacity(0.8)
                        : const Color.fromARGB(255, 22, 48, 141),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Login 
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : loginProcess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 22, 48, 141),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            //register
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: Text(
                "ยังไม่มีบัญชี? ลงทะเบียนที่นี่",
                style: TextStyle(
                  color: isDarkMode
                      ? Colors.amber
                      : const Color.fromARGB(255, 22, 48, 141),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
