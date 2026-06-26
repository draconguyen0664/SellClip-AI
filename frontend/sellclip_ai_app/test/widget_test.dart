import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sellclip_ai_app/main.dart';
import 'package:sellclip_ai_app/screens/forgot_password_screen.dart';
import 'package:sellclip_ai_app/screens/login_screen.dart';
import 'package:sellclip_ai_app/screens/onboarding_flow_screen.dart';
import 'package:sellclip_ai_app/screens/register_screen.dart';
import 'package:sellclip_ai_app/screens/reset_password_screen.dart';
import 'package:sellclip_ai_app/screens/verify_email_screen.dart';
import 'package:sellclip_ai_app/screens/welcome_screen.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SellClipApp());

    expect(find.text('Checking login status...'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
  });

  const mobileSizes = <Size>[
    Size(320, 568),
    Size(360, 640),
    Size(390, 844),
    Size(430, 932),
  ];

  for (final size in mobileSizes) {
    testWidgets('Splash screen fits ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const SellClipApp());
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Checking login status...'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  for (final size in mobileSizes) {
    testWidgets('Welcome screen fits ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: WelcomeScreen()),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Tạo clip bán hàng'), findsOneWidget);
      expect(find.text('bằng AI'), findsOneWidget);
      expect(find.text('Bắt đầu'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  for (final size in mobileSizes) {
    testWidgets('Login screen fits ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: LoginScreen()),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mật khẩu'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsOneWidget);
      expect(find.text('Tiếp tục với Google'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  for (final size in mobileSizes) {
    testWidgets('Register screen fits ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Đăng ký'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  for (final size in mobileSizes) {
    testWidgets('Verify email screen fits ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: VerifyEmailScreen(email: 'long.nguyen@sellclip.ai'),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Kiểm tra email của bạn'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  for (final size in mobileSizes) {
    testWidgets('Forgot password screen fits ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Quên mật khẩu'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  for (final size in mobileSizes) {
    testWidgets('Reset password screen fits ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: ResetPasswordScreen(email: 'long.nguyen@sellclip.ai'),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Đặt lại mật khẩu'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  for (final size in mobileSizes) {
    testWidgets('Onboarding flow fits ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: OnboardingFlowScreen(userId: 1)),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Chọn ngành hàng'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
