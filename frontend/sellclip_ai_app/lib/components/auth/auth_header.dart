import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/brand/sellclip_logo.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    required this.subtitle,
    this.logoWidth = 146,
    this.subtitleSize = 16,
    super.key,
  });

  final String subtitle;
  final double logoWidth;
  final double subtitleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SellClipLogo(width: logoWidth),
        SizedBox(height: logoWidth * 0.08),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.62),
            fontSize: subtitleSize,
            height: 1.2,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
