import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'report_page.dart';
import 'history_page.dart';
import 'info_page.dart';
import 'ranking_page.dart';

class HomePage extends StatefulWidget {
  final String studentId;
  const HomePage({super.key, required this.studentId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); 
  }

  Future<void> _fetchUserProfile() async {
    try {
      final res = await http.get(
        Uri.parse('http://192.168.1.190:3000/user-profile/${widget.studentId}'),
      );

      if (res.statusCode == 200) {
        setState(() {
          userData = json.decode(res.body);
        });
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/appbar_banner.jpg',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Row(
                    children: [
                      const Text(
                        "เมนูสำหรับคุณ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(), // ดัน token ไปขวาสุด

                      Row(
                        children: [
                          const Icon(
                            Icons.token,
                            color: Colors.amber,
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${userData?['point'] ?? 0} pts",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: [
                      _buildMenuCard(
                        context,
                        Icons.report_gmailerrorred_rounded,
                        "แจ้งปัญหา",
                        Colors.orange,
                        ReportPage(studentId: widget.studentId),
                        true,
                      ),
                      _buildMenuCard(
                        context,
                        Icons.history_rounded,
                        "ประวัติการแจ้ง",
                        Colors.blue,
                        HistoryPage(studentId: widget.studentId),
                        false,
                      ),
                      _buildMenuCard(
                        context,
                        Icons.info_outline,
                        "ความรู้ SDG",
                        Colors.green,
                        const InfoPage(),
                        false,
                      ),
                      _buildMenuCard(
                        context,
                        Icons.leaderboard_rounded,
                        "อันดับคะแนน",
                        Colors.purple,
                        RankingPage(studentId: widget.studentId),
                        false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Widget targetPage,
    bool isReport,
  ) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );

        if (result == true) {
          _fetchUserProfile();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
