import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/app_drawer.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const DistribuPlusApp());
}

class DistribuPlusApp extends StatelessWidget {
  const DistribuPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DistribuPlus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
