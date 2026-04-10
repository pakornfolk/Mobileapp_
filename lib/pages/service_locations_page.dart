import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mb_app/apiconfig/api_config.dart';

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
    _groupedServices = _fetchAndGroupServices();
  }

  String normalize(String? type) {
    return type?.toString().trim().toLowerCase() ?? 'unknown';
  }

  String getTitle(String type) {
    switch (type) {
      case 'water':
        return "ตู้กดน้ำ";
      case 'waste':
        return "จุดแยกขยะ";
      case 'health':
        return "ด้านสุขภาพ";
      case 'shuttle bus':
        return "การเดินทาง";
      default:
        return 'สนามกีฬา';
    }
  }


  IconData getIcon(String type) {
    switch (type) {
      case 'water':
        return Icons.local_drink;
      case 'waste':
        return Icons.recycling;
      case 'health':
        return Icons.heart_broken;
      case 'shuttle bus':
        return Icons.directions_bus;
      default:
        return Icons.stadium;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case 'water':
        return Colors.blue;
      case 'waste':
        return Colors.green;
      case 'health':
        return Colors.red;
      case 'shuttle bus':
        return Colors.indigo;
      default:
        return Colors.amber;
    }
  }

  Future<Map<String, List<dynamic>>> _fetchAndGroupServices() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/service-locations'),
    );

    if (res.statusCode == 200) {
      List<dynamic> data = json.decode(res.body);

      Map<String, List<dynamic>> grouped = {};

      for (var item in data) {
        final type = normalize(item['service_type']);

        grouped.putIfAbsent(type, () => []);
        grouped[type]!.add(item);
      }

      return grouped;
    } else {
      throw Exception('โหลดข้อมูลไม่สำเร็จ');
    }
  }

  Widget buildHeader(String type, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              getTitle(type),
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("จุดบริการในมหาวิทยาลัย"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, List<dynamic>>>(
        future: _groupedServices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data ?? {};

          if (data.isEmpty) {
            return const Center(child: Text("ไม่มีข้อมูล"));
          }

          final order = [
            'water',
            'waste',
            'health',
            'stadium',
            'shuttle bus'
          ];

          final categories = data.keys.toList()
            ..sort((a, b) {
              final ai = order.indexOf(a);
              final bi = order.indexOf(b);
              return (ai == -1 ? 999 : ai)
                  .compareTo(bi == -1 ? 999 : bi);
            });

          return ListView(
            children: categories.map((type) {
              final items = data[type]!;

              return Column(
                children: [
                  buildHeader(type, theme),

                  ...items.map((item) {
                    final color = getColor(type);
                    final note = item['note'];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.2),
                          child: Icon(getIcon(type), color: color),
                        ),
                        title: Text(
                          item['service_name'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['building'] ?? '-'),
                            if (note != null && note.toString().trim().isNotEmpty)
                              Text(
                                note.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}