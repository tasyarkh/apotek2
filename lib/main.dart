import 'package:flutter/material.dart';
import 'pages/splashscreen.dart';
// import 'pages/home_pages.dart';

void main() {
  runApp(const ApotekApp());
}

class ApotekApp extends StatelessWidget {
  const ApotekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apotek Rakyat Mandiri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5F8D4E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5F8D4E),
          primary: const Color(0xFF5F8D4E),
          secondary: const Color(0xFFE84C3D),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
