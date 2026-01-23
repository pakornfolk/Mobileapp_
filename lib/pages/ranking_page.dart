import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'report_page.dart'; 

class RankingPage extends StatefulWidget {
  final String studentId; 

  const RankingPage({super.key, required this.studentId});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late Future<List<dynamic>> _rankingFuture;

  @override
  void initState() {
    super.initState();
    _rankingFuture = getRanking();
  }

  Future<List<dynamic>> getRanking() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/ranking'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load ranking');
    }
  }

  void _refreshRanking() {
    setState(() {
      _rankingFuture = getRanking(); //ดึงข้อมูลใหม่จริง ๆ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ranking Points")),

      //ปุ่มไปแจ้งปัญหา
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.report),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportPage(studentId: widget.studentId),
            ),
          );

          if (result == true) {
            _refreshRanking();
          }
        },
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          _refreshRanking();
        },
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            const SizedBox(height: 10),
            const Text(
              "Leaderboard",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _rankingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("ไม่มีข้อมูลอันดับ"));
                  }

                  final rankingList = snapshot.data!;

                  return ListView.builder(
                    itemCount: rankingList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final user = rankingList[index];
                      final isMe = user['student_id'] == widget.studentId;

                      return Card(
                        color: isMe ? const Color.fromARGB(255, 0, 0, 0) : null, // 👈 ไฮไลต์ตัวเอง
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: index == 0
                                ? Colors.amber
                                : Colors.green.shade100,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                color: Colors.black, // 🔒 ล็อคเลขให้ดำ
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            "${user['username']} (${user['faculty']})",
                            style: TextStyle(
                              fontWeight:
                                  isMe ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: Text(
                            "${user['point']} pts",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
