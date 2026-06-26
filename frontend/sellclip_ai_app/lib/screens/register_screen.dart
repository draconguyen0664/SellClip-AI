import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/auth/auth_card.dart';
import 'package:sellclip_ai_app/components/auth/auth_controls.dart';
import 'package:sellclip_ai_app/components/auth/auth_screen_frame.dart';
import 'package:sellclip_ai_app/components/login/login_text_field.dart';
import 'package:sellclip_ai_app/screens/login_screen.dart';
import 'package:sellclip_ai_app/screens/verify_email_screen.dart';
import 'package:sellclip_ai_app/services/auth_api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _api = AuthApi();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _acceptedTerms = true;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _loading = false;
  String _message = '';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _password.addListener(_refreshPasswordStrength);
  }

  @override
  void dispose() {
    _password.removeListener(_refreshPasswordStrength);
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _refreshPasswordStrength() {
    setState(() {});
  }

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _message = '';
    });
    final response = await _api.register(
      displayName: _name.text,
      email: _email.text,
      password: _password.text,
      confirmPassword: _confirmPassword.text,
      acceptedTerms: _acceptedTerms,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _message = response.devCode == null
          ? response.message
          : '${response.message} - OTP dev: ${response.devCode}';
      _isError = !response.ok;
    });
    if (response.ok) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VerifyEmailScreen(
            email: response.email ?? _email.text.trim(),
            initialCode: response.devCode,
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
      subtitle: 'Tạo tài khoản để bắt đầu\ntạo clip bán hàng bằng AI',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 330;
          return AuthCard(
            compact: compact,
            children: [
              LoginTextField(
                controller: _name,
                icon: Icons.person_outline,
                hintText: 'Tên hiển thị',
              ),
              const SizedBox(height: 14),
              LoginTextField(
                controller: _email,
                icon: Icons.mail_outline,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              LoginTextField(
                controller: _password,
                icon: Icons.lock_outline,
                hintText: 'Mật khẩu',
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
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _showConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _PasswordStrength(password: _password.text),
              const SizedBox(height: 18),
              _TermsRow(
                accepted: _acceptedTerms,
                onChanged: (value) => setState(() => _acceptedTerms = value),
              ),
              const SizedBox(height: 20),
              AuthStatusText(message: _message, isError: _isError),
              AuthGradientButton(
                label: 'Đăng ký',
                loading: _loading,
                onPressed: _register,
              ),
              const SizedBox(height: 22),
              _BottomPrompt(onTap: _openLogin),
            ],
          );
        },
      ),
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final score = [
      password.length >= 8,
      password.contains(RegExp(r'[A-Za-z]')),
      password.contains(RegExp(r'\d')),
    ].where((ok) => ok).length;
    final label = score >= 3
        ? 'Mạnh'
        : score == 2
            ? 'Vừa'
            : 'Yếu';

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            'Độ mạnh mật khẩu',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
          ),
          const SizedBox(width: 28),
          for (var i = 0; i < 3; i++) ...[
            Container(
              width: 42,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: i < score
                    ? (i == 0
                        ? const Color(0xFFB837FF)
                        : const Color(0xFF168DFF))
                    : Colors.white.withValues(alpha: 0.10),
              ),
            ),
            if (i < 2) const SizedBox(width: 4),
          ],
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Color(0xFF1AA0FF))),
        ],
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.accepted, required this.onChanged});

  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AuthCheckbox(value: accepted, onChanged: onChanged),
        const SizedBox(width: 12),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                text: 'Tôi đồng ý với ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 16,
                ),
                children: const [
                  TextSpan(
                    text: 'Điều khoản',
                    style: TextStyle(color: Color(0xFF0AA5FF)),
                  ),
                  TextSpan(text: ' và '),
                  TextSpan(
                    text: 'Chính sách',
                    style: TextStyle(color: Color(0xFF0AA5FF)),
                  ),
                ],
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomPrompt extends StatelessWidget {
  const _BottomPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          'Đã có tài khoản? ',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Đăng nhập',
            style: TextStyle(
              color: Color(0xFFB33CFF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
