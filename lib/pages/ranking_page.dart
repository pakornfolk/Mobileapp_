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
  late Future<List<dynamic>> rankingFuture;

  @override
  void initState() {
    super.initState();
    rankingFuture = fetchRanking();
  }

  Future<List<dynamic>> fetchRanking() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.190:3000/ranking'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("โหลดข้อมูลไม่สำเร็จ");
    }
  }

  void refreshRanking() {
    setState(() {
      rankingFuture = fetchRanking();
    });
  }

  bool isCurrentUser(dynamic user) {
    final apiId = user['student_id']?.toString() ?? '';
    final myId = widget.studentId.toString();
  return apiId == myId;
  }

  
  Widget buildRankItem(dynamic user, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isMe = isCurrentUser(user);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: isMe ? colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isMe
            ? BorderSide(color: colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index == 0 ? Colors.amber : Colors.green.shade100,
          child: Text(
            "${index + 1}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "${user['username']} (${user['faculty']})",
                style: TextStyle(
                  fontWeight:
                      isMe ? FontWeight.bold : FontWeight.normal,
                  color:
                      isMe ? colorScheme.onPrimaryContainer : null,
                ),
              ),
            ),
            if (isMe)
              Icon(
                Icons.person,
                size: 20,
                color: colorScheme.primary,
              ),
          ],
        ),
        trailing: Text(
          "${user['point']} pts",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                isMe ? colorScheme.onPrimaryContainer : colorScheme.primary,
          ),
        ),
      ),
    );
  }

  // ===============================
  // MAIN BUILD
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ranking Points")),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.report),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ReportPage(studentId: widget.studentId),
            ),
          );

          if (result == true) {
            refreshRanking();
          }
        },
      ),

      body: RefreshIndicator(
        onRefresh: () async => refreshRanking(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.emoji_events,
                size: 80, color: Colors.amber),
            const SizedBox(height: 10),
            const Text(
              "Leaderboard",
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: rankingFuture,
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("ไม่มีข้อมูลอันดับ"));
                  }

                  final rankingList = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: rankingList.length,
                    itemBuilder: (context, index) {
                      return buildRankItem(
                          rankingList[index], index);
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
