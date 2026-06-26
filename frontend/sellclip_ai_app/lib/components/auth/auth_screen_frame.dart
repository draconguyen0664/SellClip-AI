import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/auth/auth_header.dart';
import 'package:sellclip_ai_app/components/login/login_background.dart';

class AuthScreenFrame extends StatelessWidget {
  const AuthScreenFrame({
    required this.subtitle,
    required this.child,
    this.logoScale = 0.36,
    super.key,
  });

  final String subtitle;
  final Widget child;
  final double logoScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020514),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(child: LoginBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 720;
                final sidePadding = (constraints.maxWidth * 0.075).clamp(
                  18.0,
                  38.0,
                );
                final topPadding =
                    (constraints.maxHeight * (compact ? 0.018 : 0.032))
                        .clamp(10.0, 34.0);
                final logoWidth =
                    (constraints.maxWidth * logoScale).clamp(168.0, 250.0);
                final subtitleSize = (constraints.maxWidth * 0.038).clamp(
                  12.5,
                  17.0,
                );

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    sidePadding,
                    topPadding,
                    sidePadding,
                    24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - topPadding - 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AuthHeader(
                          subtitle: subtitle,
                          logoWidth: logoWidth,
                          subtitleSize: subtitleSize,
                        ),
                        SizedBox(height: compact ? 16 : 28),
                        child,
                      ],
                    ),
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
