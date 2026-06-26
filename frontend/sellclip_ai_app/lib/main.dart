import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SellClipApp());
}

class SellClipApp extends StatelessWidget {
  const SellClipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SellClip AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
