import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  late Future<List<dynamic>> _services;

  @override
  void initState() {
    super.initState();
    _services = _fetchServices();
  }

  Future<List<dynamic>> _fetchServices() async {
    
    final res = await http.get(
      Uri.parse('http://localhost:3000/service-locations'),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('โหลดข้อมูลไม่สำเร็จ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "จุดบริการในมหาวิทยาลัย",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _services,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("ยังไม่มีจุดบริการ"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final item = data[i];
              final note = item['note'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  // --- แก้ไขส่วน Leading เริ่มตรงนี้ ---
                  leading: Icon(
                    item['service_type'] == 'Water'
                        ? Icons.local_drink
                        : item['service_type'] == 'Waste'
                            ? Icons.recycling
                            : Icons.eco,
                    color: item['service_type'] == 'Water'
                        ? Colors.blue
                        : item['service_type'] == 'Waste'
                            ? Colors.orange // ใช้สีส้มเพื่อให้เห็นชัดกว่าเหลือง
                            : Colors.green,
                    size: 28,
                  ),
                  // --- จบส่วนที่แก้ไข ---
                  title: Text(
                    item['service_name'] ?? 'ไม่มีชื่อรายการ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['building'] ?? 'ไม่ระบุอาคาร'),
                      if (note != null && note.toString().trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            note.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}