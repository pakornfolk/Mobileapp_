import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  late Future<Map<String, List<dynamic>>> _groupedServices;

  @override
  void initState() {
    super.initState();
    _servicesRequest();
  }

  void _servicesRequest() {
    setState(() {
      _groupedServices = _fetchAndGroupServices();
    });
  }

  Future<Map<String, List<dynamic>>> _fetchAndGroupServices() async {
    final res = await http.get(
      Uri.parse('http://192.168.1.190:3000/service-locations'),
    );

    if (res.statusCode == 200) {
      List<dynamic> data = json.decode(res.body);
      
      Map<String, List<dynamic>> grouped = {};
      for (var item in data) {
        String type = item['service_type'] ?? 'ไม่ระบุ';
        if (grouped[type] == null) {
          grouped[type] = [];
        }
        grouped[type]!.add(item);
      }
      return grouped;
    } else {
      throw Exception('โหลดข้อมูลไม่สำเร็จ');
    }
  }

  Widget _buildCategoryHeader(String type, ThemeData theme) {
    String title = "การเดินทาง";
    if (type == 'Water') title = "ตู้กดน้ำ";
    if (type == 'Waste') title = "จุดแยกขยะ";
    if (type == 'Health') title = "ด้านสุขภาพ";
    if (type == 'Stadium') title = "สนามกีฬา";

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(child: Divider(indent: 15, endIndent: 10, thickness: 1, color: theme.dividerColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          Expanded(child: Divider(indent: 10, endIndent: 15, thickness: 1, color: theme.dividerColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "จุดบริการในมหาวิทยาลัย",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, List<dynamic>>>(
        future: _groupedServices,
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

          final groupedData = snapshot.data!;
          
          final customOrder = ['Water', 'Waste', 'Health','Stadium','Shuttle bus'];
          final sortedCategories = groupedData.keys.toList()
            ..sort((a, b) => customOrder.indexOf(a).compareTo(customOrder.indexOf(b))); 

          return ListView.builder(
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              String categoryType = sortedCategories[index];
              List<dynamic> items = groupedData[categoryType]!;

              return Column(
                children: [
                  _buildCategoryHeader(categoryType, theme),
                  
                  ...items.map((item) {
                    final note = item['note'];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        onTap: null,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (item['service_type'] == 'Water' 
                                    // ignore: deprecated_member_use
                                    ? Colors.blue.withOpacity(0.2) 
                                    : item['service_type'] == 'Waste' 
                                      // ignore: deprecated_member_use
                                      ? Colors.green.withOpacity(0.2) 
                                        : item['service_type'] == 'Health' 
                                      // ignore: deprecated_member_use
                                        ? const Color.fromARGB(255, 221, 8, 8).withOpacity(0.2)
                                          : item['service_type'] == 'Stadium' 
                                      // ignore: deprecated_member_use
                                          ? Colors.amber.withOpacity(0.2) 
                                      // ignore: deprecated_member_use
                                            : const Color.fromARGB(255, 7, 27, 204).withOpacity(0.2)),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item['service_type'] == 'Water' ? Icons.local_drink : item['service_type'] == 'Waste' ? Icons.recycling : item['service_type'] == 'Health' ? Icons.heart_broken : item['service_type'] == 'Stadium' ? Icons.stadium : Icons.car_crash,
                            color: item['service_type'] == 'Water' ? Colors.blue : item['service_type'] == 'Waste' ? Colors.green : item['service_type'] == 'Health' ? Colors.red : item['service_type'] == 'Stadium' ? Color.fromARGB(255, 5, 194, 175) :Color.fromARGB(255, 255, 255, 255),
                            size: 24,
                          ),
                        ),
                        title: Text(
                          item['service_name'] ?? 'ไม่มีชื่อรายการ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['building'] ?? 'ไม่ระบุอาคาร'),
                            if (note != null && note.toString().trim().isNotEmpty)
                              Text(
                                note.toString(),
                                style: TextStyle(
                                  fontSize: 12, 
                                  height: 1.4,
                                  color: theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600]
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              );
            },
          );
        },
      ),
    );
  }
}