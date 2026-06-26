import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF01020B), Color(0xFF020514), Color(0xFF02030C)],
        ),
      ),
      child: CustomPaint(
        painter: _LoginBackgroundPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _paintSideGlow(
      canvas,
      Rect.fromLTWH(-size.width * 0.22, size.height * 0.25, 96, size.height),
      const Color(0xFF7637FF),
    );
    _paintLargeMark(canvas, size, Alignment.topLeft);
    _paintLargeMark(canvas, size, Alignment.centerRight);
    _paintDot(canvas, Offset(size.width * 0.25, size.height * 0.26));
    _paintDot(canvas, Offset(size.width * 0.80, size.height * 0.29));
    _paintDot(canvas, Offset(size.width * 0.17, size.height * 0.34), 2.5);
  }

  void _paintSideGlow(Canvas canvas, Rect rect, Color color) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.78),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawOval(rect, paint);
  }

  void _paintLargeMark(Canvas canvas, Size size, Alignment alignment) {
    final isLeft = alignment == Alignment.topLeft;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF1B2EFF).withValues(alpha: 0.14);
    final path = Path();

    if (isLeft) {
      path
        ..moveTo(size.width * -0.10, size.height * 0.03)
        ..quadraticBezierTo(
          size.width * 0.38,
          size.height * 0.17,
          size.width * 0.13,
          size.height * 0.28,
        )
        ..lineTo(size.width * 0.05, size.height * 0.35);
    } else {
      path
        ..moveTo(size.width * 1.08, size.height * 0.63)
        ..quadraticBezierTo(
          size.width * 0.83,
          size.height * 0.72,
          size.width * 1.04,
          size.height * 0.78,
        );
    }

    canvas.drawPath(path, paint);
  }

  void _paintDot(Canvas canvas, Offset center, [double radius = 4]) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF38A8FF), Color(0xFF214FFF)],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 2)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
