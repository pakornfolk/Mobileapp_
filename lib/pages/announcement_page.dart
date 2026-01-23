import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  final List<Map<String, dynamic>> announcements = const [
    {
      'title': 'กิจกรรมปลูกต้นไม้',
      'detail': 'ร่วมกันเพิ่มพื้นที่สีเขียวในมหาวิทยาลัย',
      'date': '25 ม.ค. 2569',
      'type': 'SDG',
      'icon': Icons.park,
      'color': Colors.green,
    },
    {
      'title': 'ปิดปรับปรุงสนามฟุตซอล',
      'detail': 'ซ่อมแซมสนามฟุตบอลบริเวณลานกีฬาสุขภาพ',
      'date': '4-30 ม.ค. 2569',
      'type': 'ประกาศ',
      'icon': Icons.block,
      'color': Colors.red,
    },
    {
      'title': 'ซ่อมแซมตู้กดน้ำ',
      'detail': 'ปิดปรับปรุงตู้กดน้ำ อาคาร MLC',
      'date': '22 ม.ค. 2569',
      'type': 'ประกาศ',
      'icon': Icons.local_drink,
      'color': Colors.blue,
    },
    {
      'title': 'แยกขยะให้ถูกต้อง',
      'detail': 'ช่วยกันแยกขยะ ลดขยะฝังกลบ',
      'date': 'ตลอดเดือน ม.ค.',
      'type': 'รณรงค์',
      'icon': Icons.recycling,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,


      appBar: AppBar(
        title: const Text(
          "ประกาศ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final item = announcements[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['icon'],
                      color: item['color'],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['detail'],
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: item['color'],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item['type'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              item['date'],
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
