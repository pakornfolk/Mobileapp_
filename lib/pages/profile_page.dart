import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:barcode_widget/barcode_widget.dart'; // ✅ เพิ่มตัวนี้

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
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _generateRedeemCode(String studentId) {
  // ใช้แค่ studentId มาทำ Hash รหัสจะออกมาเหมือนเดิมทุกครั้งสำหรับ ID นี้
  var seed = studentId.hashCode.abs().toString().padRight(10, '0').substring(0, 10);
  return seed;
}

  Future<void> _loadProfile() async {
    try {
      final res = await http.get(
        Uri.parse('http://localhost:3000/user-profile/${widget.studentId}'),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
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

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        color: Colors.green,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ส่วนหัว Profile
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
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Color.fromARGB(255, 245, 209, 104),
                      ),
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

              // คะแนนสะสม
              ListTile(
                leading: const Icon(Icons.token, color: Colors.amber, size: 25),
                title: const Text(
                  "คะแนนสะสมของคุณ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                trailing: Text(
                  "${user!['point']} pts",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),

              // กฎการสะสมคะแนน
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.grey),
                title: const Text(
                  "กฎการสะสมคะแนน",
                  style: 
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RulesPage()),
                  );
                },
              ),

              const Divider(),

              //Redeem Code 
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "รหัสสำหรับแลกคะแนน (Redeem Code)",
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // BarcodeWidget
                      BarcodeWidget(
                        barcode: Barcode.code128(), // มาตรฐานที่เครื่องสแกนอ่านได้
                        data: _generateRedeemCode(widget.studentId),
                        width: 200,
                        height: 70,
                        drawText: false, // ไม่วาดเลขใต้บาร์โค้ดเพราะเรามี Text แยกด้านล่าง
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      
                      const SizedBox(height: 15),
                      Text(
                        _generateRedeemCode(widget.studentId),
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 4,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const Text(
                        "แลกคะแนน",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(),

              // ประวัติ
              ListTile(
                leading: const Icon(Icons.history, color: Colors.blue),
                title: const Text("ประวัติการแจ้งปัญหา"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryPage(studentId: widget.studentId),
                    ),
                  );
                },
              ),

              // ออกจากระบบ
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDarkMode ? Colors.red.withOpacity(0.5) : const Color.fromARGB(255, 22, 48, 141),
                        width: 2,
                      ),
                      foregroundColor: Colors.red,
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

// อันนี้คือหน้ากฎการสะสมคะแนน
class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final TextStyle ruleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300, 
      color: isDarkMode ? Colors.white : const Color.fromARGB(255, 52, 51, 51),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("กฎการสะสมคะแนน", 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          ),

        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• แจ้งปัญหาต่างๆ รับ 10 คะแนน", style: ruleStyle),
            const SizedBox(height: 15),
            Text("• จำกัดสิทธิ์การรับคะแนนสูงสุด 3 ครั้งต่อวัน", style: ruleStyle),
            const SizedBox(height: 15),
            Text("• คะแนนจะอัปเดตเข้าสู่บัญชีของนักศึกษาโดยอัตโนมัติ", style: ruleStyle),
            const SizedBox(height: 15),
            Text("• สามารถแสดงรหัส Redeem เพื่อแลกรางวัล ณ สำนักงาน", style: ruleStyle),
            const SizedBox(height: 30),
            const Text(
              "* หมายเหตุ หากพบว่ามีการปั่นคะแนนเกิดขึ้น หรือ แจ้งข้อมูลอันเป็นเท็จ ทางเราขอทำการตัดแต้มครึ่งนึงจากจำนวนเเต้มทั้งหมด เงื่อนไขเป็นไปตามที่มหาวิทยาลัยกำหนด",
              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 149, 148, 148)),
            ),
          ],
        ),
      ),
    );
  }
}