import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'history_page.dart';
import 'login_page.dart'; 

class ProfilePage extends StatefulWidget {
  final String studentId;
  const ProfilePage({super.key, required this.studentId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadProfile();

    // 🔥 โหลดอัตโนมัติทุก 3 วินาที
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // กัน memory leak
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final res = await http.get(
        Uri.parse('http://localhost:3000/user-profile/${widget.studentId}')
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        // อัปเดตเฉพาะตอนข้อมูลเปลี่ยน (ลื่น + ไม่ rebuild มั่ว)
        if (mounted && (user == null || user!['point'] != data['point'])) {
          setState(() => user = data);
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        color: Colors.green,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00A651), Color(0xFF007BFF)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color.fromARGB(255, 42, 81, 224),
                      child: Icon(Icons.person, size: 60, color: Color.fromARGB(255, 245, 209, 104)),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "${user!['username']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "ID: ${user!['student_id']} | คณะ: ${user!['faculty']}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.token, color: Colors.amber, size: 25),
                title: const Text("คะแนนสะสมของคุณ",
                    style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 14)),
                trailing: Text(
                  "${user!['point']} pts",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.history, color: Colors.blue),
                title: const Text("ประวัติการแจ้งปัญหา"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HistoryPage(studentId: widget.studentId),
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 22, 48, 141), // สีกรอบ
                        width: 2,
                      ),
                      foregroundColor: Colors.red, // สี icon + text
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      "ออกจากระบบ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
