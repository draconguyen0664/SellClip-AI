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
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.17)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(left: 22, child: child),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 58),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
    return CustomPaint(
      size: const Size.square(24),
      painter: _GoogleMarkPainter(),
    );
  }
}

class _GoogleMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.18;
    final oval = Offset.zero & size;
    final arcOval = oval.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.square;

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(arcOval, -2.88, 1.38, false, paint);

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(arcOval, 2.12, 0.96, false, paint);

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(arcOval, 1.05, 1.18, false, paint);

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(arcOval, -0.15, 1.28, false, paint);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.square;
    final y = size.height * 0.50;
    canvas.drawLine(
      Offset(size.width * 0.50, y),
      Offset(size.width * 0.88, y),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
