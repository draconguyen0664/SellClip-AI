import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/login/login_background.dart';
import 'package:sellclip_ai_app/components/login/login_form_card.dart';
import 'package:sellclip_ai_app/components/login/login_header.dart';
import 'package:sellclip_ai_app/screens/dashboard_page.dart';
import 'package:sellclip_ai_app/screens/forgot_password_screen.dart';
import 'package:sellclip_ai_app/screens/onboarding_flow_screen.dart';
import 'package:sellclip_ai_app/screens/register_screen.dart';
import 'package:sellclip_ai_app/services/auth_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _afterLogin(BuildContext context, AuthApiResponse response) {
    if (!response.onboardingCompleted && response.userId != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => OnboardingFlowScreen(userId: response.userId!),
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const DashboardPage()),
    );
  }

  void _openForgotPassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  void _openRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020514),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: LoginBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final metrics = _LoginLayoutMetrics(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                );

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    metrics.sidePadding,
                    metrics.topPadding,
                    metrics.sidePadding,
                    metrics.bottomPadding,
                  ),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: metrics.contentHeight),
                    child: Column(
                      children: [
                        LoginHeader(
                          logoWidth: metrics.logoWidth,
                          subtitleSize: metrics.subtitleSize,
                        ),
                        SizedBox(height: metrics.headerCardGap),
                        LoginFormCard(
                          onLogin: (response) => _afterLogin(context, response),
                          onForgotPassword: () => _openForgotPassword(context),
                          onRegister: () => _openRegister(context),
                        ),
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

class _LoginLayoutMetrics {
  _LoginLayoutMetrics({required this.width, required this.height});

  final double width;
  final double height;

  late final bool tiny = height < 700;
  late final double sidePadding = (width * 0.075).clamp(18.0, 38.0);
  late final double topPadding = (height * (tiny ? 0.018 : 0.035)).clamp(
    10.0,
    36.0,
  );
  late final double bottomPadding = (height * 0.038).clamp(18.0, 44.0);
  late final double logoWidth = (width * (tiny ? 0.48 : 0.54)).clamp(
    168.0,
    250.0,
  );
  late final double subtitleSize = (width * (tiny ? 0.035 : 0.038)).clamp(
    12.5,
    17.0,
  );
  late final double headerCardGap = (height * (tiny ? 0.018 : 0.034)).clamp(
    12.0,
    32.0,
  );
  late final double contentHeight = height - topPadding - bottomPadding;
}
