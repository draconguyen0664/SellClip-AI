import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sellclip_ai_app/components/auth/auth_controls.dart';
import 'package:sellclip_ai_app/components/login/login_text_field.dart';
import 'package:sellclip_ai_app/components/login/social_login_button.dart';
import 'package:sellclip_ai_app/services/auth_api.dart';

class LoginFormCard extends StatefulWidget {
  const LoginFormCard({
    required this.onLogin,
    required this.onForgotPassword,
    required this.onRegister,
    super.key,
  });

  final ValueChanged<AuthApiResponse> onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  final _api = AuthApi();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  bool _rememberMe = true;
  bool _showPassword = false;
  bool _loading = false;
  bool _googleLoading = false;
  String _message = '';
  bool _isError = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _message = '';
    });
    final response = await _api.login(
      email: _email.text,
      password: _password.text,
      rememberMe: _rememberMe,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _message = response.message;
      _isError = !response.ok;
    });
    if (response.ok) {
      widget.onLogin(response);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _googleLoading = true;
      _message = '';
    });

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        if (!mounted) return;
        setState(() {
          _googleLoading = false;
          _message = 'Bạn đã hủy đăng nhập Google';
          _isError = true;
        });
        return;
      }

      final auth = await account.authentication;
      final response = await _api.googleLogin(
        email: account.email,
        displayName: account.displayName ?? account.email.split('@').first,
        googleId: account.id,
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );

      if (!mounted) return;
      setState(() {
        _googleLoading = false;
        _message = response.message;
        _isError = !response.ok;
      });
      if (response.ok) {
        widget.onLogin(response);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _googleLoading = false;
        _message = 'Đăng nhập Google thất bại';
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 330;
        final cardPadding = compact ? 16.0 : 20.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            cardPadding,
            compact ? 18 : 22,
            cardPadding,
            compact ? 18 : 22,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF080A20).withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFF9B4DFF).withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF732DFF).withValues(alpha: 0.25),
                blurRadius: 34,
                spreadRadius: 1,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: const Color(0xFF2D92FF).withValues(alpha: 0.14),
                blurRadius: 42,
                offset: const Offset(18, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white.withValues(alpha: 0.72),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _RememberAndForgotRow(
                rememberMe: _rememberMe,
                onRememberChanged: (value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
                onForgotPassword: widget.onForgotPassword,
              ),
              const SizedBox(height: 18),
              AuthStatusText(message: _message, isError: _isError),
              _LoginButton(onPressed: _login, loading: _loading),
              const SizedBox(height: 22),
              const _DividerText(),
              const SizedBox(height: 18),
              SocialLoginButton(
                label: _googleLoading
                    ? 'Đang đăng nhập...'
                    : 'Tiếp tục với Google',
                onPressed: _googleLoading ? () {} : _loginWithGoogle,
                child: const GoogleMark(),
              ),
              const SizedBox(height: 22),
              _RegisterPrompt(onPressed: widget.onRegister),
            ],
          ),
        );
      },
    );
  }
}

class _RememberAndForgotRow extends StatelessWidget {
  const _RememberAndForgotRow({
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPassword,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final remember = Row(
                children: [
                  _RememberCheckbox(
                    value: rememberMe,
                    onChanged: onRememberChanged,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ghi nhớ',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              );
              final forgot = Align(
                alignment: constraints.maxWidth < 280
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: TextButton(
                  onPressed: onForgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 34),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Quên mật khẩu?',
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF1996FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );

              return Row(
                children: [
                  Flexible(flex: 8, child: remember),
                  const SizedBox(width: 8),
                  Flexible(flex: 10, child: forgot),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RememberCheckbox extends StatelessWidget {
  const _RememberCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(7),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFF9C38FF).withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xFF9C38FF), width: 1.5),
        ),
        child: value
            ? const Icon(Icons.check, color: Color(0xFFA738FF), size: 19)
            : null,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed, required this.loading});

  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFB837FF), Color(0xFF168DFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF375DFF).withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(13),
          child: SizedBox(
            height: 52,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerText extends StatelessWidget {
  const _DividerText();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.20))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'hoặc',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.50),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.20))),
      ],
    );
  }
}

class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Chưa có tài khoản? ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: const Text(
            'Đăng ký',
            style: TextStyle(
              color: Color(0xFFB33CFF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
