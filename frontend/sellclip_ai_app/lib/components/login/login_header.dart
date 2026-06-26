import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/brand/sellclip_logo.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    required this.logoWidth,
    required this.subtitleSize,
    super.key,
  });

  final double logoWidth;
  final double subtitleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SellClipLogo(width: logoWidth),
        SizedBox(height: logoWidth * 0.10),
        _HeaderLine(
          text: 'Đăng nhập để tiếp tục tạo',
          fontSize: subtitleSize,
        ),
        SizedBox(height: subtitleSize * 0.34),
        _HeaderLine(
          text: 'những clip bán hàng ấn tượng',
          fontSize: subtitleSize,
        ),
      ],
    );
  }
}

class _HeaderLine extends StatelessWidget {
  const _HeaderLine({required this.text, required this.fontSize});

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
          color: Colors.white.withValues(alpha: 0.62),
          fontSize: fontSize,
          height: 1.08,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
