import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/motion/sellclip_motion.dart';

enum SellClipTab { home, projects, create, templates, profile }

class SellClipBottomNavigation extends StatefulWidget {
  const SellClipBottomNavigation({
    required this.currentTab,
    required this.onTabSelected,
    super.key,
  });

  final SellClipTab currentTab;
  final ValueChanged<SellClipTab> onTabSelected;

  @override
  State<SellClipBottomNavigation> createState() => _SellClipBottomNavigationState();
}

class _SellClipBottomNavigationState extends State<SellClipBottomNavigation> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <_NavigationItem>[
      const _NavigationItem(SellClipTab.home, Icons.home_outlined, 'Home'),
      const _NavigationItem(SellClipTab.projects, Icons.video_library_outlined, 'Projects'),
      const _NavigationItem(SellClipTab.create, Icons.add_circle, 'Create', isPrimary: true),
      const _NavigationItem(SellClipTab.templates, Icons.dashboard_customize_outlined, 'Templates'),
      const _NavigationItem(SellClipTab.profile, Icons.person_outline, 'Profile'),
    ];

    return SafeArea(
      top: false,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          return Container(
            margin: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF071024).withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF005DFF).withValues(alpha: 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.map((item) {
                return Expanded(
                  child: _NavigationButton(
                    item: item,
                    isSelected: widget.currentTab == item.tab,
                    pulse: _pulseController.value,
                    onPressed: () => widget.onTabSelected(item.tab),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.item,
    required this.isSelected,
    required this.pulse,
    required this.onPressed,
  });

  final _NavigationItem item;
  final bool isSelected;
  final double pulse;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = item.isPrimary
        ? Colors.white
        : isSelected
            ? Colors.white
            : Colors.white.withValues(alpha: 0.56);

    return Tooltip(
      message: item.label,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: EdgeInsets.symmetric(horizontal: item.isPrimary ? 8 : 4, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(item.isPrimary ? 28 : 16)),
        ),
        child: AnimatedContainer(
          duration: SellClipMotion.fast,
          curve: SellClipMotion.entranceCurve,
          padding: EdgeInsets.symmetric(horizontal: item.isPrimary ? 0 : 6, vertical: item.isPrimary ? 0 : 6),
          decoration: BoxDecoration(
            color: !item.isPrimary && isSelected ? const Color(0xFF12234B).withValues(alpha: 0.7) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: !item.isPrimary && isSelected ? Border.all(color: const Color(0xFF8D32FF).withValues(alpha: 0.35)) : null,
            boxShadow: !item.isPrimary && isSelected
                ? [BoxShadow(color: const Color(0xFF8D32FF).withValues(alpha: 0.18), blurRadius: 18)]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavIcon(item: item, isSelected: isSelected, pulse: pulse),
              if (!item.isPrimary) ...[
                const SizedBox(height: 6),
                AnimatedDefaultTextStyle(
                  duration: SellClipMotion.fast,
                  curve: SellClipMotion.entranceCurve,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.56),
                    fontSize: isSelected ? 11.5 : 10.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                  child: Text(item.label),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.item, required this.isSelected, required this.pulse});

  final _NavigationItem item;
  final bool isSelected;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    if (item.isPrimary) {
      final wave = math.sin(pulse * math.pi * 2);
      final glow = 0.45 + (wave + 1) * 0.18;
      return SizedBox(
        height: 66,
        width: 66,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1.08 + (wave + 1) * 0.06,
              child: Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF38B7FF).withValues(alpha: 0.38)),
                  boxShadow: [BoxShadow(color: const Color(0xFF006DFF).withValues(alpha: 0.24), blurRadius: 24)],
                ),
              ),
            ),
            Transform.scale(
              scale: 1 + wave * 0.035,
              child: Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7D2DFF), Color(0xFF008DFF)],
                  ),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF006DFF).withValues(alpha: glow), blurRadius: 24),
                    BoxShadow(color: const Color(0xFFB735FF).withValues(alpha: glow * 0.65), blurRadius: 18),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 42),
              ),
            ),
          ],
        ),
      );
    }

    final size = isSelected ? 30.0 : 27.0;
    final icon = AnimatedScale(
      scale: isSelected ? 1.08 : 1,
      duration: SellClipMotion.fast,
      curve: SellClipMotion.entranceCurve,
      child: Icon(item.icon, color: Colors.white, size: size),
    );

    if (!isSelected) {
      return Icon(item.icon, color: Colors.white.withValues(alpha: 0.56), size: size);
    }

    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFB735FF), Color(0xFF168DFF)],
      ).createShader(bounds),
      child: icon,
    );
  }
}

class _NavigationItem {
  const _NavigationItem(this.tab, this.icon, this.label, {this.isPrimary = false});

  final SellClipTab tab;
  final IconData icon;
  final String label;
  final bool isPrimary;
}