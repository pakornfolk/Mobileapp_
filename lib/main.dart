import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/service_locations_page.dart';
import 'pages/announcement_page.dart';
import 'pages/profile_page.dart';

import 'pages/settings_page.dart';
import 'theme/app_theme.dart';
import 'pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MU Clean & Green',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: const SplashPage(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final String studentId;
  const MainNavigation({super.key, required this.studentId});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(studentId: widget.studentId),
      const ServiceListPage(),
      const AnnouncementPage(),
      const SettingsPage(),
      ProfilePage(studentId: widget.studentId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'จุดบริการ'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'ประกาศ'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'การตั้งค่า'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
      ),
    );
  }
}
