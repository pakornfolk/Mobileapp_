import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'history_page.dart';
import 'login_page.dart';
import 'rule_page.dart';
import 'package:mb_app/apiconfig/api_config.dart';

class ProfilePage extends StatefulWidget {
  final String studentId;
  const ProfilePage({super.key, required this.studentId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  Timer? _timer;

  File? _image;
  final ImagePicker _picker = ImagePicker();

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

  // ----------------- Redeem Code -----------------
  String _generateRedeemCode(String studentId) {
    var seed =
        studentId.hashCode.abs().toString().padRight(10, '0').substring(0, 10);
    return seed;
  }

  // ----------------- Load Profile -----------------
  Future<void> _loadProfile() async {
    try {
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user-profile/${widget.studentId}'),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (mounted) {
          setState(() {
            user = data;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
  }

  // ----------------- Pick Image -----------------
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      File image = File(picked.path);

      setState(() {
        _image = image;
      });

      await _uploadImage(image);
    }
  }

  // ----------------- Upload Image -----------------
  Future<void> _uploadImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${ApiConfig.baseUrl}/upload-profile/${widget.studentId}',
      ),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    var res = await request.send();

    if (res.statusCode == 200) {
      _loadProfile();
    }
  }

  // ----------------- UI -----------------
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
              // ----------------- HEADER -----------------
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

                    // รูปโปร
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color.fromARGB(255, 42, 81, 224),
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : (user!['profile_image'] != null
                                    ? NetworkImage(
                                        '${ApiConfig.baseUrl}/${user!['profile_image']}',
                                      )
                                    : null) as ImageProvider?,
                            child: (_image == null && user!['profile_image'] == null)
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Color.fromARGB(255, 245, 209, 104),
                                  )
                                : null,
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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

              // ----------------- POINT -----------------
              ListTile(
                leading:
                    const Icon(Icons.token, color: Colors.amber, size: 25),
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

              // ----------------- RULES -----------------
              ListTile(
                leading:
                    const Icon(Icons.info_outline, color: Colors.grey),
                title: const Text(
                  "กฎการสะสมคะแนน",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RulesPage()),
                  );
                },
              ),

              const Divider(),

              // ----------------- REDEEM CODE -----------------
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[900]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.green.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "รหัสสำหรับแลกคะแนน",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 15),

                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: _generateRedeemCode(widget.studentId),
                        width: 200,
                        height: 70,
                        drawText: false,
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        _generateRedeemCode(widget.studentId),
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 4,
                          color:
                              isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),

                      const Text(
                        "แลกคะแนน",
                        style:
                            TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(),

              // ----------------- HISTORY -----------------
              ListTile(
                leading:
                    const Icon(Icons.history, color: Colors.blue),
                title: const Text("ประวัติการแจ้งปัญหา"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryPage(
                          studentId: widget.studentId),
                    ),
                  );
                },
              ),

              // ----------------- LOGOUT -----------------
              Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 30, right: 30, bottom: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDarkMode
                            ? Colors.red.withOpacity(0.5)
                            : const Color.fromARGB(255, 22, 48, 141),
                        width: 2,
                      ),
                      foregroundColor: Colors.red,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                const Text("ยืนยันการออกจากระบบ"),
                            content: const Text(
                                "คุณต้องการออกจากระบบใช่หรือไม่?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text("ยกเลิก"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const LoginPage()),
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  "ออกจากระบบ",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("ออกจากระบบ"),
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