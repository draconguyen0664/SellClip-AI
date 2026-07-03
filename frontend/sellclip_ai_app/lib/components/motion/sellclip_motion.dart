import 'package:flutter/material.dart';

class SellClipMotion {
  const SellClipMotion._();

  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 520);

  static const Curve entranceCurve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;
}

class SellClipPageTransitionsBuilder extends PageTransitionsBuilder {
  const SellClipPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == Navigator.defaultRouteName && route.isFirst) {
      return child;
    }

    final fade = CurvedAnimation(
      parent: animation,
      curve: SellClipMotion.entranceCurve,
      reverseCurve: SellClipMotion.exitCurve,
    );
    final slide = Tween<Offset>(
      begin: const Offset(0.035, 0.018),
      end: Offset.zero,
    ).animate(fade);
    final scale = Tween<double>(begin: 0.985, end: 1).animate(fade);

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: ScaleTransition(
          scale: scale,
          child: child,
        ),
      ),
    );
  }
}

class SellClipAnimatedPage extends StatelessWidget {
  const SellClipAnimatedPage({
    super.key,
    required this.child,
    this.offset = const Offset(0, 0.035),
    this.duration = SellClipMotion.normal,
  });

  final Widget child;
  final Offset offset;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: SellClipMotion.entranceCurve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(offset.dx * (1 - value) * 100, offset.dy * (1 - value) * 100),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}