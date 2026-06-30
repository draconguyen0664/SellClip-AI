import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8081',
  );

  final http.Client _client;

  Future<AuthApiResponse> register({
    required String displayName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) {
    return _post('/api/auth/register', {
      'displayName': displayName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'acceptedTerms': acceptedTerms,
    });
  }

  Future<AuthApiResponse> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) {
    return _post('/api/auth/login', {
      'email': email.trim(),
      'password': password,
      'rememberMe': rememberMe,
    });
  }

  Future<AuthApiResponse> googleLogin({
    required String email,
    required String displayName,
    String? googleId,
    String? idToken,
    String? accessToken,
  }) {
    return _post('/api/auth/google', {
      'email': email.trim(),
      'displayName': displayName,
      'googleId': googleId ?? '',
      'idToken': idToken ?? '',
      'accessToken': accessToken ?? '',
    });
  }

  Future<AuthApiResponse> verifyEmail({
    required String email,
    required String code,
  }) {
    return _post('/api/auth/verify-email', {
      'email': email.trim(),
      'code': code,
    });
  }

  Future<AuthApiResponse> resendVerification({required String email}) {
    return _post('/api/auth/resend-verification', {'email': email.trim()});
  }

  Future<AuthApiResponse> forgotPassword({
    required String email,
    required String deliveryMethod,
  }) {
    return _post('/api/auth/forgot-password', {
      'email': email.trim(),
      'deliveryMethod': deliveryMethod,
    });
  }

  Future<AuthApiResponse> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _post('/api/auth/reset-password', {
      'email': email.trim(),
      'code': code,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });
  }

  Future<AuthApiResponse> saveOnboarding({
    required int userId,
    required bool skipped,
    required String industry,
    required List<String> platforms,
    required List<String> contentGoals,
    required String mediaType,
    required List<String> contentStyles,
    required String voiceType,
  }) {
    return _post('/api/auth/onboarding', {
      'userId': userId,
      'skipped': skipped,
      'industry': industry,
      'platforms': platforms,
      'contentGoals': contentGoals,
      'mediaType': mediaType,
      'contentStyles': contentStyles,
      'voiceType': voiceType,
    });
  }

  Future<AuthApiResponse> _post(String path, Map<String, Object> body) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 3));
      final json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return AuthApiResponse.fromJson(json, response.statusCode);
    } catch (_) {
      return const AuthApiResponse(
        statusCode: 0,
        status: 'network_error',
        message: 'Không kết nối được backend',
      );
    }
  }
}

class AuthApiResponse {
  const AuthApiResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    this.userId,
    this.email,
    this.displayName,
    this.accessToken,
    this.onboardingCompleted = false,
    this.devCode,
    this.devResetToken,
  });

  factory AuthApiResponse.fromJson(Map<String, dynamic> json, int statusCode) {
    return AuthApiResponse(
      statusCode: statusCode,
      status: json['status']?.toString() ?? 'unknown',
      message: json['message']?.toString() ?? '',
      userId: int.tryParse(json['userId']?.toString() ?? ''),
      email: json['email']?.toString(),
      displayName: json['displayName']?.toString(),
      accessToken: json['accessToken']?.toString(),
      onboardingCompleted: json['onboardingCompleted'] == true ||
          json['onboardingCompleted']?.toString() == 'true',
      devCode: json['devCode']?.toString(),
      devResetToken: json['devResetToken']?.toString(),
    );
  }

  final int statusCode;
  final String status;
  final String message;
  final int? userId;
  final String? email;
  final String? displayName;
  final String? accessToken;
  final bool onboardingCompleted;
  final String? devCode;
  final String? devResetToken;

  bool get ok => statusCode >= 200 && statusCode < 300;
}
