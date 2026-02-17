import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportDetailPage extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportDetailPage({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final rawDate = report['report_date'];
    String formattedDate = '-';

    if (rawDate != null) {
      try {
        final date = DateTime.parse(rawDate).toLocal();
        formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
      } catch (e) {
        formattedDate = '-';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดการแจ้งปัญหา"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item("เลขที่รายการ", report['report_id']?.toString()),
            _item("ประเภทปัญหา", report['service_type'] as String?),
            _item("รายละเอียด", report['issue_detail'] as String?),
            _item("วันที่แจ้ง", formattedDate),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? '-',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
