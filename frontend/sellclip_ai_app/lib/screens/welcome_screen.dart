import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/welcome/welcome_background.dart';
import 'package:sellclip_ai_app/components/welcome/welcome_hero_image.dart';
import 'package:sellclip_ai_app/components/welcome/welcome_start_button.dart';
import 'package:sellclip_ai_app/components/welcome/welcome_text_section.dart';
import 'package:sellclip_ai_app/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020514),
      body: Stack(
        children: [
          const Positioned.fill(child: WelcomeBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final metrics = _WelcomeLayoutMetrics(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                );

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: metrics.sidePadding,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: metrics.topGap,
                        left: 0,
                        right: 0,
                        child: WelcomeHeroImage(
                          height: metrics.heroHeight,
                          width: metrics.heroWidth,
                        ),
                      ),
                      Positioned(
                        top: metrics.textTop,
                        left: 0,
                        right: 0,
                        child: WelcomeTextSection(
                          titleSize: metrics.titleSize,
                          subtitleSize: metrics.subtitleSize,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: metrics.bottomGap,
                        child: WelcomeStartButton(
                          height: metrics.buttonHeight,
                          onPressed: () => _openLogin(context),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeLayoutMetrics {
  _WelcomeLayoutMetrics({required this.width, required this.height});

  final double width;
  final double height;

  late final bool tiny = height < 620;
  late final bool compact = height < 720;
  late final double sidePadding = (width * 0.085).clamp(26.0, 44.0);
  late final double titleSize = (width *
          (tiny
              ? 0.092
              : compact
                  ? 0.101
                  : 0.112))
      .clamp(
    tiny ? 28.0 : 32.0,
    56.0,
  );
  late final double subtitleSize = (width * (tiny ? 0.039 : 0.043)).clamp(
    13.0,
    22.0,
  );
  late final double buttonHeight = (height * (tiny ? 0.07 : 0.077)).clamp(
    50.0,
    72.0,
  );
  late final double topGap = tiny
      ? 4.0
      : compact
          ? 10.0
          : 24.0;
  late final double heroTextGap = tiny
      ? 4.0
      : compact
          ? 8.0
          : 18.0;
  late final double textLift = (height * (tiny ? 0.032 : 0.064)).clamp(
    tiny ? 14.0 : 28.0,
    compact ? 38.0 : 62.0,
  );
  late final double buttonGap = tiny ? 14.0 : 24.0;
  late final double bottomGap = (height * (tiny ? 0.045 : 0.075)).clamp(
    20.0,
    72.0,
  );
  late final double reservedHeight = topGap +
      heroTextGap +
      titleSize * 2.26 +
      titleSize * 0.28 +
      subtitleSize * 3.25 +
      buttonGap +
      buttonHeight +
      bottomGap;
  late final double heroHeight = (height - reservedHeight).clamp(
    tiny ? 178.0 : 220.0,
    compact ? 330.0 : 470.0,
  );
  late final double heroWidth = math.max(width * 1.12, 420.0);
  late final double textTop = math.max(
    topGap + heroHeight + heroTextGap - textLift,
    topGap + heroHeight * 0.78,
  );
}
