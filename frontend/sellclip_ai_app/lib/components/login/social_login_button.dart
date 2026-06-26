import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.label,
    required this.child,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.white.withValues(alpha: 0.12),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.17)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(left: 24, child: child),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 58),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(painter: _GoogleMarkPainter()),
    );
  }
}

class _GoogleMarkPainter extends CustomPainter {
  const _GoogleMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.16;
    final rect = Rect.fromLTWH(
        stroke, stroke, size.width - stroke * 2, size.height - stroke * 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -0.05, 1.48, false, paint);

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 1.43, 1.15, false, paint);

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 2.58, 1.04, false, paint);

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, 3.62, 1.45, false, paint);

    paint
      ..color = const Color(0xFF4285F4)
      ..strokeCap = StrokeCap.square;
    final centerY = size.height * 0.50;
    canvas.drawLine(
      Offset(size.width * 0.52, centerY),
      Offset(size.width * 0.88, centerY),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.88, centerY),
      Offset(size.width * 0.88, size.height * 0.40),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
