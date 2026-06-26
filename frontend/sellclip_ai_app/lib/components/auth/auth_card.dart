import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({required this.children, this.compact = false, super.key});

  final List<Widget> children;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        compact ? 18 : 24,
        compact ? 22 : 28,
        compact ? 18 : 24,
        compact ? 22 : 26,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF080A20).withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
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
        children: children,
      ),
    );
  }
}
