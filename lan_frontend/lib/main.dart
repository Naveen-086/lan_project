import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const LanMonitorApp());
}

class LanMonitorApp extends StatelessWidget {
  const LanMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAN Monitor',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
