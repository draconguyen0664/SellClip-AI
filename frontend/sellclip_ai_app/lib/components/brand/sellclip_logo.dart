import 'package:flutter/material.dart';

class SellClipLogo extends StatelessWidget {
  const SellClipLogo({
    required this.width,
    this.showTagline = true,
    super.key,
  });

  final double width;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final iconWidth = width * 0.46;
    final titleSize = width * 0.15;
    final aiSize = width * 0.15;
    final taglineSize = width * 0.032;

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo_icon.png',
            width: iconWidth,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
          SizedBox(height: width * 0.035),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              maxLines: 1,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  letterSpacing: 0,
                  fontFamily: 'Inter',
                ),
                children: [
                  const TextSpan(text: 'SellClip '),
                  TextSpan(
                    text: 'AI',
                    style: TextStyle(
                      fontSize: aiSize,
                      fontWeight: FontWeight.w700,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFFB33CFF), Color(0xFF168DFF)],
                        ).createShader(const Rect.fromLTWH(0, 0, 90, 36)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showTagline) ...[
            SizedBox(height: width * 0.025),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'AI POWERED. CLIPS THAT SELL.',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.52),
                  fontSize: taglineSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: width * 0.004,
                  height: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
