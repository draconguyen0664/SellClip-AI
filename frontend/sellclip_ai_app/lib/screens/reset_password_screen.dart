import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/auth/auth_card.dart';
import 'package:sellclip_ai_app/components/auth/auth_controls.dart';
import 'package:sellclip_ai_app/components/auth/auth_screen_frame.dart';
import 'package:sellclip_ai_app/components/login/login_text_field.dart';
import 'package:sellclip_ai_app/screens/login_screen.dart';
import 'package:sellclip_ai_app/services/auth_api.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({required this.email, this.initialCode, super.key});

  final String email;
  final String? initialCode;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _api = AuthApi();
  late final TextEditingController _code;
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
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
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    setState(() {
      _loading = true;
      _message = '';
    });
    final response = await _api.resetPassword(
      email: widget.email,
      code: _code.text,
      newPassword: _password.text,
      confirmPassword: _confirmPassword.text,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _message = response.message;
      _isError = !response.ok;
    });
    if (response.ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenFrame(
      subtitle: 'Đặt lại mật khẩu để tiếp tục',
      child: AuthCard(
        children: [
          const Text(
            'Đặt lại mật khẩu',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Nhập mã đã gửi đến ${widget.email} và tạo mật khẩu mới.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 16,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 26),
          LoginTextField(
            controller: _code,
            icon: Icons.pin_outlined,
            hintText: 'Mã xác minh',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          LoginTextField(
            controller: _password,
            icon: Icons.lock_outline,
            hintText: 'Mật khẩu mới',
            obscureText: !_showPassword,
            trailing: IconButton(
              onPressed: () {
                setState(() => _showPassword = !_showPassword);
              },
              icon: Icon(
                _showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
          ),
          const SizedBox(height: 14),
          LoginTextField(
            controller: _confirmPassword,
            icon: Icons.lock_outline,
            hintText: 'Xác nhận mật khẩu',
            obscureText: !_showConfirmPassword,
            trailing: IconButton(
              onPressed: () {
                setState(() => _showConfirmPassword = !_showConfirmPassword);
              },
              icon: Icon(
                _showConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AuthStatusText(message: _message, isError: _isError),
          AuthGradientButton(
            label: 'Cập nhật mật khẩu',
            loading: _loading,
            onPressed: _reset,
          ),
          const SizedBox(height: 18),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Quay lại'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF0AA5FF),
            ),
          ),
        ],
      ),
    );
  }
}
