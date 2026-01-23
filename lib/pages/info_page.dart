import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SDG Knowledge Hub"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ==========================
          // 🌱 SDG ที่เกี่ยวข้องกับแอปพลิเคชัน
          // ==========================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "SDG ที่เกี่ยวข้องกับแอป MU Clean & Green",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "แอปพลิเคชันนี้มุ่งเน้นการส่งเสริมการเข้าถึงน้ำดื่มสะอาด "
                  "ลดการใช้พลาสติก และสนับสนุนพฤติกรรมที่เป็นมิตรต่อสิ่งแวดล้อมภายในมหาวิทยาลัย",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🔗 SDG ที่เกี่ยวข้องโดยตรง
          _buildInfoCard(
            "SDG 6: Clean Water and Sanitation",
            "สร้างหลักประกันเรื่องน้ำและการสุขาภิบาล ให้มีการจัดการอย่างยั่งยืนและมีสภาพพร้อมใช้ สำหรับทุกคน ",
            const Color.fromARGB(255, 69, 171, 255),
          ),
          _buildInfoCard(
            "SDG 11: Sustainable cities and Communities",
            "ทำให้เมืองและการตั้งถิ่นฐานของมนุษย์ มีความครอบคลุม ปลอดภัย ยืดหยุ่นต่อการเปลี่ยนแปลง และยั่งยืน",
            Colors.amber,
          ),
          _buildInfoCard(
            "SDG 12: Responsible Consumption",
            "สร้างหลักประกันให้มีแบบแผนการผลิตและการบริโภคที่ยั่งยืน",
            const Color.fromARGB(255, 187, 143, 76),
          ),

          // ===== ตัวคั่น =====
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "SDG อื่น ๆ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),

          _buildInfoCard(
            "SDG 1: No Poverty",
            "ยุติความยากจนทุกรูปแบบในทุกที่",
            Colors.red,
          ),
          _buildInfoCard(
            "SDG 2: Zero Hunger",
            "ยุติความหิวโหย บรรลุความมั่นคงทางอาหารและยกระดับโภชนาการ และส่งเสริมเกษตรกรรมที่ยั่งยืน",
            const Color.fromARGB(255, 179, 156, 5),
          ),
          _buildInfoCard(
            "SDG 3: Good Health and Well-being",
            " สร้างหลักประกันการมีสุขภาวะที่ดี และส่งเสริมความเป็นอยู่ที่ดีสำหรับทุกคนในทุกช่วงวัย",
            Colors.green,
          ),
          _buildInfoCard(
            "SDG 4: Quality Education",
            "สร้างหลักประกันว่าทุกคนมีการศึกษาที่มีคุณภาพอย่างครอบคลุมและเท่าเทียม และสนับสนุนโอกาสในการเรียนรู้ตลอดชีวิต",
            const Color.fromARGB(255, 188, 39, 5),
          ),
          _buildInfoCard(
            "SDG 5: Gender Equality",
            "บรรลุความเสมอภาคระหว่างเพศ และเพิ่มบทบาทของสตรีและเด็กหญิงทุกคน",
            const Color.fromARGB(255, 243, 69, 0),
          ),
          _buildInfoCard(
            "SDG 7: Affordable and Clean energy",
            "สร้างหลักประกันว่าทุกคนเข้าถึงพลังงานสมัยใหม่ในราคาที่สามารถซื้อหาได้ เชื่อถือได้ และยั่งยืน",
            const Color.fromARGB(255, 232, 193, 19),
          ),
          _buildInfoCard(
            "SDG 8: Decent work and Economic Growth",
            " ส่งเสริมการเจริญเติบโตทางเศรษฐกิจที่ต่อเนื่อง ครอบคลุม และยั่งยืน การจ้างงานเต็มที่และ มีผลิตภาพ และการมีงานที่มีคุณค่าสำหรับทุกคน",
            const Color.fromARGB(255, 99, 24, 10),
          ),
          _buildInfoCard(
            "SDG 9: Industry,Innovation and Infrastructure",
            "สร้างโครงสร้างพื้นฐานที่มีความยืดหยุ่นต่อการเปลี่ยนแปลง ส่งเสริมการพัฒนาอุตสาหกรรม ที่ครอบคลุมและยั่งยืน และส่งเสริมนวัตกรรม",
            Colors.orange,
          ),
          _buildInfoCard(
            "SDG 10: Reduced Inequalities",
            "ลดความไม่เสมอภาคภายในและระหว่างประเทศ",
            Colors.pinkAccent,
          ),
          _buildInfoCard(
            "SDG 13: Climate Action",
            "ปฏิบัติการอย่างเร่งด่วนเพื่อต่อสู้กับการเปลี่ยนแปลงสภาพภูมิอากาศและผลกระทบที่เกิดขึ้น",
            const Color.fromARGB(255, 7, 114, 57),
          ),
          _buildInfoCard(
            "SDG 14: Life Below water",
            "อนุรักษ์และใช้ประโยชน์จากมหาสมุทร ทะเลและทรัพยากรทางทะเลอย่างยั่งยืนเพื่อการพัฒนาที่ยั่งยืน",
            const Color.fromARGB(255, 12, 125, 195),
          ),
          _buildInfoCard(
            "SDG 15: Life On Land",
            "ปกป้อง ฟื้นฟู และสนับสนุนการใช้ระบบนิเวศบนบกอย่างยั่งยืน จัดการป่าไม้อย่างยั่งยืน ต่อสู้การกลายสภาพเป็นทะเลทราย หยุดการเสื่อมโทรมของที่ดินและฟื้นสภาพกลับมาใหม่ และหยุดการสูญเสียความหลากหลายทางชีวภาพ",
            const Color.fromARGB(255, 9, 192, 97),
          ),
          _buildInfoCard(
            "SDG 16: Peace,Justice and Strong Institutions",
            "ส่งเสริมสังคมที่สงบสุขและครอบคลุม เพื่อการพัฒนาที่ยั่งยืน ให้ทุกคนเข้าถึงความยุติธรรม และสร้างสถาบันที่มีประสิทธิผล รับผิดชอบ และครอบคลุมในทุกระดับ",
            const Color.fromARGB(255, 7, 88, 143),
          ),
          _buildInfoCard(
            "SDG 17: Partnership for the goals",
            "เสริมความเข้มแข็งให้แก่กลไกการดำเนินงานและฟื้นฟูสภาพหุ้นส่วนความร่วมมือระดับโลกสำหรับการพัฒนาที่ยั่งยืน",
            const Color.fromARGB(255, 2, 45, 88),
          ),
        ],
      ),
    );
  }

  // ==========================
  // 🧩 Card Component
  // ==========================
  Widget _buildInfoCard(String title, String description, Color color) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
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
