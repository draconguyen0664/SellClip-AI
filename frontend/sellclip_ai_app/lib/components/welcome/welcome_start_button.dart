import 'dart:math' as math;

import 'package:flutter/material.dart';

class WelcomeStartButton extends StatefulWidget {
  const WelcomeStartButton({
    required this.height,
    required this.onPressed,
    super.key,
  });

  final double height;
  final VoidCallback onPressed;

  @override
  State<WelcomeStartButton> createState() => _WelcomeStartButtonState();
}

class _WelcomeStartButtonState extends State<WelcomeStartButton>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _tapController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 140),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_tapController.isAnimating) {
      return;
    }

    await _tapController.forward();
    await _tapController.reverse();
    if (mounted) {
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _tapController]),
      builder: (context, child) {
        final pulse = math.sin(_pulseController.value * math.pi * 2);
        final pulseScale = 1 + (pulse.clamp(0.0, 1.0) * 0.018);
        final tapScale = 1 - (_tapController.value * 0.045);
        final arrowOffset = 4 + (pulse.clamp(0.0, 1.0) * 7);
        final glowAlpha = 0.24 + (pulse.clamp(0.0, 1.0) * 0.18);

        return Transform.scale(
          scale: pulseScale * tapScale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFB837FF), Color(0xFF238CFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5338FF).withValues(alpha: glowAlpha),
                  blurRadius: 30 + pulse.clamp(0.0, 1.0) * 18,
                  spreadRadius: pulse.clamp(0.0, 1.0) * 3,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: _handleTap,
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white.withValues(alpha: 0.22),
                highlightColor: Colors.white.withValues(alpha: 0.08),
                child: SizedBox(
                  height: widget.height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.28 + _pulseController.value * 0.45,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0),
                                    Colors.white.withValues(alpha: 0.18),
                                    Colors.white.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Bắt đầu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                      Positioned(
                        right: 28 - arrowOffset,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
