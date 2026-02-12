import 'package:flutter/material.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
        'การตั้งค่า',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
        ),
      ),
      centerTitle: true, 
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('โหมดสว่าง'),
            onTap: () {
              MyApp.of(context).changeTheme(ThemeMode.light);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('โหมดมืด'),
            onTap: () {
              MyApp.of(context).changeTheme(ThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }
}
