import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import 'register_page.dart';

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
    // 1️⃣ ตรวจ input
    if (_idController.text.trim().isEmpty ||
        _passController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2️⃣ เรียก API
      final response = await http
          .post(Uri.parse('http://localhost:3000/login'),
          
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'student_id': _idController.text.trim(),
              'password': _passController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 5));
      debugPrint('RESPONSE BODY: ${response.body}');

      // 3️⃣ ถ้า server error
      if (response.statusCode >= 500) {
        throw Exception('Server error');
      }

      final data = jsonDecode(response.body);

      // 4️⃣ Login ไม่ผ่าน
      if (data['success'] != true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'เข้าสู่ระบบไม่สำเร็จ')),
        );
        return;
      }

      // 5️⃣ Login ผ่าน
      final String studentId =
          data['user']['student_id'].toString();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MainNavigation(studentId: studentId),
        ),
      );
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
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
    return Scaffold(
      backgroundColor: Colors.white,
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
                  color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              "มหาวิทยาลัยสีเขียว เริ่มต้นที่ตัวคุณ",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // รหัสนักศึกษา
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "รหัสนักศึกษา",
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // รหัสผ่าน
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "รหัสผ่าน",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ปุ่ม Login
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : loginProcess,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 22, 48, 141),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // ไปสมัครสมาชิก
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              child: const Text(
                "ยังไม่มีบัญชี? ลงทะเบียนที่นี่",
                style: TextStyle(
                    color: Color.fromARGB(255, 22, 48, 141),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
