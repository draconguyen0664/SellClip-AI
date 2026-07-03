import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/motion/sellclip_motion.dart';
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
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 0.9,
              maxScaleFactor: 1.0,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        fontFamily: 'Inter',
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SellClipPageTransitionsBuilder(),
            TargetPlatform.iOS: SellClipPageTransitionsBuilder(),
            TargetPlatform.macOS: SellClipPageTransitionsBuilder(),
            TargetPlatform.windows: SellClipPageTransitionsBuilder(),
            TargetPlatform.linux: SellClipPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
