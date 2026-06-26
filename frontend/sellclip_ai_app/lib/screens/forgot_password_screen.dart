import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/auth/auth_card.dart';
import 'package:sellclip_ai_app/components/auth/auth_controls.dart';
import 'package:sellclip_ai_app/components/auth/auth_screen_frame.dart';
import 'package:sellclip_ai_app/components/login/login_text_field.dart';
import 'package:sellclip_ai_app/screens/login_screen.dart';
import 'package:sellclip_ai_app/screens/reset_password_screen.dart';
import 'package:sellclip_ai_app/services/auth_api.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _api = AuthApi();
  final _email = TextEditingController();
  String _method = 'link';
  bool _loading = false;
  String _message = '';
  bool _isError = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _message = '';
    });
    final response = await _api.forgotPassword(
      email: _email.text,
      deliveryMethod: _method,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _message = response.devResetToken == null
          ? response.message
          : '${response.message} - Mã dev: ${response.devResetToken}';
      _isError = !response.ok;
    });
    if (response.ok) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ResetPasswordScreen(
            email: response.email ?? _email.text.trim(),
            initialCode: response.devResetToken,
          ),
        ),
      );
    }
  }

  void _openLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenFrame(
      subtitle: 'Đăng nhập để tiếp tục tạo\nnhững clip bán hàng ấn tượng',
      child: AuthCard(
        children: [
          const Text(
            'Quên mật khẩu',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Nhập email của bạn để nhận liên kết đặt lại mật khẩu hoặc mã xác minh.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 16,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 28),
          LoginTextField(
            controller: _email,
            icon: Icons.mail_outline,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          const AuthDivider(label: 'Chọn cách nhận'),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final linkButton = _MethodButton(
                selected: _method == 'link',
                icon: Icons.link,
                label: 'Gửi link',
                onTap: () => setState(() => _method = 'link'),
              );
              final otpButton = _MethodButton(
                selected: _method == 'otp',
                icon: Icons.lock_outline,
                label: 'Gửi mã OTP',
                onTap: () => setState(() => _method = 'otp'),
              );

              if (constraints.maxWidth < 300) {
                return Column(
                  children: [
                    linkButton,
                    const SizedBox(height: 10),
                    otpButton,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: linkButton),
                  const SizedBox(width: 8),
                  Expanded(child: otpButton),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          AuthStatusText(message: _message, isError: _isError),
          AuthGradientButton(
            label: _method == 'link' ? 'Gửi link đặt lại' : 'Gửi mã OTP',
            loading: _loading,
            onPressed: _submit,
          ),
          const SizedBox(height: 22),
          Center(
            child: InkWell(
              onTap: _openLogin,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: Color(0xFF0AA5FF)),
                      SizedBox(width: 8),
                      Text(
                        'Quay lại đăng nhập',
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0xFF0AA5FF),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodButton extends StatelessWidget {
  const _MethodButton({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: selected ? 0.07 : 0.04),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFF2E94FF)
                  : Colors.white.withValues(alpha: 0.17),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: const Color(0xFF8F37FF).withValues(alpha: 0.25),
                      blurRadius: 18,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 23,
                    color: selected
                        ? const Color(0xFF9C38FF)
                        : Colors.white.withValues(alpha: 0.72),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.64),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
