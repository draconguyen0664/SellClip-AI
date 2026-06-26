import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/auth/auth_card.dart';
import 'package:sellclip_ai_app/components/auth/auth_controls.dart';
import 'package:sellclip_ai_app/components/auth/auth_screen_frame.dart';
import 'package:sellclip_ai_app/screens/dashboard_page.dart';
import 'package:sellclip_ai_app/screens/onboarding_flow_screen.dart';
import 'package:sellclip_ai_app/screens/register_screen.dart';
import 'package:sellclip_ai_app/services/auth_api.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({required this.email, this.initialCode, super.key});

  final String email;
  final String? initialCode;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _api = AuthApi();
  late final TextEditingController _code;
  bool _loading = false;
  String _message = '';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.initialCode ?? '');
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _loading = true;
      _message = '';
    });
    final response = await _api.verifyEmail(
      email: widget.email,
      code: _code.text,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _message = response.message;
      _isError = !response.ok;
    });
    if (response.ok) {
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
  }

  Future<void> _resend() async {
    final response = await _api.resendVerification(email: widget.email);
    if (!mounted) return;
    setState(() {
      _message = response.devCode == null
          ? response.message
          : '${response.message} - OTP dev: ${response.devCode}';
      _isError = !response.ok;
      if (response.devCode != null) {
        _code.text = response.devCode!;
      }
    });
  }

  void _changeEmail() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenFrame(
      subtitle: 'Xác minh email để tiếp tục',
      child: AuthCard(
        children: [
          const _EnvelopeMark(),
          const SizedBox(height: 22),
          const Text(
            'Kiểm tra email của bạn',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chúng tôi đã gửi email xác minh đến',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.58),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.email,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            'Vui lòng kiểm tra hộp thư đến và nhập mã OTP bên dưới.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.58),
              fontSize: 16,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 24),
          _OtpField(controller: _code),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, color: Color(0xFFB33CFF)),
                const SizedBox(width: 8),
                Text(
                  'Gửi lại sau ',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
                ),
                const Text(
                  '00:48',
                  style: TextStyle(color: Color(0xFF0AA5FF)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const AuthDivider(label: 'hoặc'),
          TextButton.icon(
            onPressed: _resend,
            icon: const Icon(Icons.mail_outline),
            label: const Text('Gửi lại email'),
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFF0AA5FF)),
          ),
          TextButton.icon(
            onPressed: _changeEmail,
            icon: const Icon(Icons.refresh),
            label: const Text('Đổi email'),
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFF0AA5FF)),
          ),
          const SizedBox(height: 10),
          AuthStatusText(message: _message, isError: _isError),
          AuthGradientButton(
            label: 'Tiếp tục',
            loading: _loading,
            onPressed: _verify,
          ),
        ],
      ),
    );
  }
}

class _EnvelopeMark extends StatelessWidget {
  const _EnvelopeMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF743BFF)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D92FF).withValues(alpha: 0.28),
              blurRadius: 28,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.mail_outline, color: Colors.white, size: 58),
            Positioned(
              right: 12,
              bottom: 18,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF168DFF),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpField extends StatelessWidget {
  const _OtpField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final letterSpacing = (MediaQuery.sizeOf(context).width * 0.028).clamp(
      8.0,
      14.0,
    );

    return TextField(
      controller: controller,
      maxLength: 6,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      cursorColor: const Color(0xFF2E94FF),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.w500,
      ).copyWith(letterSpacing: letterSpacing),
      decoration: InputDecoration(
        counterText: '',
        hintText: '------',
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.18),
          letterSpacing: letterSpacing,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF8F37FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2E94FF)),
        ),
      ),
    );
  }
}
