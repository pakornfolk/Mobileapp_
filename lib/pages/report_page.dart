import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportPage extends StatefulWidget {
  final String studentId;

  const ReportPage({super.key, required this.studentId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _detailController = TextEditingController();
  String? _selectedServiceType;

  final List<String> _serviceTypes = [
    'ตู้กดน้ำดื่ม',
    'จุดแยกขยะ',
    'แจ้งของหาย',
    'อื่นๆ',
  ];

  Future<void> sendReport() async {
    // 1. ตรวจสอบค่าว่างใน App
    if (_selectedServiceType == null || _detailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณาเลือกประเภทและกรอกรายละเอียด")),
      );
      return;
    }

    try {
      // 2. ส่งข้อมูลไปยัง Backend
      final response = await http.post(
        Uri.parse('http://192.168.1.190:3000/report'), 
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "student_id": widget.studentId,
          "service_type": _selectedServiceType,
          "issue_detail": _detailController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "ส่งรายงานสำเร็จ")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data['message'] ?? 'เกิดข้อผิดพลาด'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("แจ้งปัญหา")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.report_problem, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedServiceType,
              items: _serviceTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) => setState(() => _selectedServiceType = value),
              decoration: const InputDecoration(labelText: "เลือกประเภท", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "รายละเอียด / ตำแหน่ง ที่ต้องการแจ้ง", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: sendReport,
                child: const Text(
                  "ยืนยันการส่งรายงาน",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
