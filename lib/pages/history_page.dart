import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'reportdetail_page.dart';

class HistoryPage extends StatefulWidget {
  final String studentId;
  const HistoryPage({super.key, required this.studentId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _getHistory();
  }

  Future<List<dynamic>> _getHistory() async {
    final res = await http.get(
      Uri.parse('http://192.168.1.190:3000/report-history/${widget.studentId}'),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('โหลดประวัติไม่สำเร็จ');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _historyFuture = _getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ประวัติการแจ้งปัญหา")),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<dynamic>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("ยังไม่มีประวัติการแจ้งปัญหา"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                final item = snapshot.data![i];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportDetailPage(report: item),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Row(
                        children: const [
                          Icon(
                            Icons.report_problem_outlined,
                            color: Colors.orange,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "รายงานปัญหา",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        item['issue_detail'] ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "+10 pts",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
