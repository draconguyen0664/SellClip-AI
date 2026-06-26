import 'package:flutter/material.dart';

class WelcomeHeroImage extends StatelessWidget {
  const WelcomeHeroImage({
    required this.height,
    required this.width,
    super.key,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Image.asset(
          'assets/images/background onboard.png',
          width: width,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
