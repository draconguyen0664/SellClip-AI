import 'package:flutter/material.dart';

class WelcomeTextSection extends StatelessWidget {
  const WelcomeTextSection({
    required this.titleSize,
    required this.subtitleSize,
    super.key,
  });

  final double titleSize;
  final double subtitleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WelcomeTitle(fontSize: titleSize),
        SizedBox(height: titleSize * 0.26),
        _WelcomeDescriptionLine(
          text: 'Tạo video ngắn chuyên nghiệp chỉ trong',
          fontSize: subtitleSize,
        ),
        SizedBox(height: subtitleSize * 0.42),
        _WelcomeDescriptionLine(text: 'vài phút.', fontSize: subtitleSize),
        SizedBox(height: subtitleSize * 0.42),
        _WelcomeDescriptionLine(
          text: 'Nhanh hơn, thông minh hơn, hiệu quả hơn.',
          fontSize: subtitleSize,
        ),
      ],
    );
  }
}

class _WelcomeDescriptionLine extends StatelessWidget {
  const _WelcomeDescriptionLine({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.72),
          fontSize: fontSize,
          height: 1.18,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class WelcomeTitle extends StatelessWidget {
  const WelcomeTitle({required this.fontSize, super.key});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      height: 1.12,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
    );

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Tạo clip bán hàng',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Color(0xFFC13BFF), Color(0xFF246BFF)],
            ).createShader(bounds);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'bằng AI',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
