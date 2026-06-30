import 'package:flutter/material.dart';

enum SellClipTab { home, projects, create, templates, profile }

class SellClipBottomNavigation extends StatelessWidget {
  const SellClipBottomNavigation({
    required this.currentTab,
    required this.onTabSelected,
    super.key,
  });

  final SellClipTab currentTab;
  final ValueChanged<SellClipTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final items = <_NavigationItem>[
      const _NavigationItem(SellClipTab.home, Icons.home_outlined, 'Home'),
      const _NavigationItem(
        SellClipTab.projects,
        Icons.video_library_outlined,
        'Projects',
      ),
      const _NavigationItem(
        SellClipTab.create,
        Icons.add_circle,
        'Create',
        isPrimary: true,
      ),
      const _NavigationItem(
        SellClipTab.templates,
        Icons.dashboard_customize_outlined,
        'Templates',
      ),
      const _NavigationItem(
        SellClipTab.profile,
        Icons.person_outline,
        'Profile',
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 8, 18, 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF071024).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
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
                isSelected: currentTab == item.tab,
                onPressed: () => onTabSelected(item.tab),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  final _NavigationItem item;
  final bool isSelected;
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
          padding: EdgeInsets.symmetric(
            horizontal: item.isPrimary ? 8 : 4,
            vertical: 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(item.isPrimary ? 28 : 16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavIcon(item: item, isSelected: isSelected),
            if (!item.isPrimary) ...[
              const SizedBox(height: 6),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.item, required this.isSelected});

  final _NavigationItem item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (item.isPrimary) {
      return Container(
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
            BoxShadow(
              color: const Color(0xFF006DFF).withValues(alpha: 0.42),
              blurRadius: 22,
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 42),
      );
    }

    final icon = Icon(
      item.icon,
      color: Colors.white,
      size: 28,
    );

    if (!isSelected) {
      return Icon(
        item.icon,
        color: Colors.white.withValues(alpha: 0.56),
        size: 28,
      );
    }

    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF9B32FF), Color(0xFF168DFF)],
      ).createShader(bounds),
      child: icon,
    );
  }
}

class _NavigationItem {
  const _NavigationItem(
    this.tab,
    this.icon,
    this.label, {
    this.isPrimary = false,
  });

  final SellClipTab tab;
  final IconData icon;
  final String label;
  final bool isPrimary;
}
