import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("SDG Knowledge Hub"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: dark ? const Color.fromARGB(255, 46, 153, 51) : Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SDG ที่เกี่ยวข้องกับแอป MU Clean & Green",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  "แอปพลิเคชันนี้มุ่งเน้นการส่งเสริมการเข้าถึงน้ำดื่มสะอาด "
                  "ลดการใช้พลาสติก และสนับสนุนพฤติกรรมที่เป็นมิตรต่อสิ่งแวดล้อมภายในมหาวิทยาลัย",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ===== SDG หลัก =====
          _buildInfoCard(
            context,
            "SDG 6: Clean Water and Sanitation",
            "สร้างหลักประกันเรื่องน้ำและการสุขาภิบาลอย่างยั่งยืน",
            Colors.blue,
          ),
          _buildInfoCard(
            context,
            "SDG 11: Sustainable Cities and Communities",
            "เมืองที่ปลอดภัย ยืดหยุ่น และยั่งยืน",
            Colors.amber,
          ),
          _buildInfoCard(
            context,
            "SDG 12: Responsible Consumption",
            "การผลิตและบริโภคอย่างยั่งยืน",
            Colors.brown,
          ),

          const SizedBox(height: 16),

          Row(
            children: const [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("SDG อื่น ๆ"),
              ),
              Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoCard(context, "SDG 1: No Poverty", "ยุติความยากจน", Colors.red),
          _buildInfoCard(context, "SDG 2: Zero Hunger", "ยุติความหิวโหย", Colors.orange),
          _buildInfoCard(context, "SDG 3: Good Health", "สุขภาพและความเป็นอยู่ที่ดี", Colors.green),
          _buildInfoCard(context, "SDG 4: Quality Education", "การศึกษาที่มีคุณภาพ", Colors.indigo),
          _buildInfoCard(context, "SDG 5: Gender Equality", "ความเท่าเทียมทางเพศ", Colors.pink),
          _buildInfoCard(context, "SDG 7: Clean Energy", "พลังงานสะอาด", Colors.yellow),
          _buildInfoCard(context, "SDG 8: Decent Work", "งานที่มีคุณค่า", Colors.brown),
          _buildInfoCard(context, "SDG 9: Innovation", "อุตสาหกรรมและนวัตกรรม", Colors.deepOrange),
          _buildInfoCard(context, "SDG 10: Reduced Inequalities", "ลดความเหลื่อมล้ำ", Colors.purple),
          _buildInfoCard(context, "SDG 13: Climate Action", "รับมือโลกร้อน", Colors.teal),
          _buildInfoCard(context, "SDG 14: Life Below Water", "ทรัพยากรทางทะเล", Colors.blueAccent),
          _buildInfoCard(context, "SDG 15: Life On Land", "ระบบนิเวศบนบก", Colors.greenAccent),
          _buildInfoCard(context, "SDG 16: Peace and Justice", "สังคมสงบสุข", Colors.blueGrey),
          _buildInfoCard(context, "SDG 17: Partnership", "ความร่วมมือ", Colors.black),
        ],
      ),
    );
  }

  // card
  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String description,
    Color color,
  ) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: dark ? const Color(0xFF1E1E1E) : Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
