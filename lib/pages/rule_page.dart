import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final TextStyle ruleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: isDarkMode ? Colors.white : const Color.fromARGB(255, 52, 51, 51),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "กฎการสะสมคะแนน",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• แจ้งปัญหาต่างๆ รับ 10 คะแนน", style: ruleStyle),
            const SizedBox(height: 15),
            Text("• จำกัดสิทธิ์การรับคะแนนสูงสุด 3 ครั้งต่อวัน แต่นักศึกษาสามารถแจ้งปัญหาได้โดยไม่จำกัดจำนวนครั้ง", style: ruleStyle),
            const SizedBox(height: 15),
            Text("• คะแนนจะอัปเดตเข้าสู่บัญชีของนักศึกษาโดยอัตโนมัติ", style: ruleStyle),
            const SizedBox(height: 15),
            Text("• สามารถแสดงรหัส Redeem เพื่อแลกรางวัล ณ สำนักงาน", style: ruleStyle),
            const SizedBox(height: 30),
            const Text(
              "* หมายเหตุ หากพบว่ามีการปั่นคะแนนเกิดขึ้น หรือ แจ้งข้อมูลอันเป็นเท็จ ทางเราขอทำการตัดแต้มครึ่งนึงจากจำนวนเเต้มทั้งหมด เงื่อนไขเป็นไปตามที่มหาวิทยาลัยกำหนด",
              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 149, 148, 148)),
            ),
          ],
        ),
      ),
    );
  }
}