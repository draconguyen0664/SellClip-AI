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
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
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
    final colorScheme = Theme.of(context).colorScheme;
    final foregroundColor = item.isPrimary
        ? colorScheme.onPrimary
        : isSelected
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant;
    final backgroundColor = item.isPrimary
        ? colorScheme.primary
        : isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.55)
            : Colors.transparent;

    return Tooltip(
      message: item.label,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: item.isPrimary ? 8 : 4,
            vertical: 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(item.isPrimary ? 22 : 18),
          ),
          backgroundColor: backgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: item.isPrimary ? 30 : 24),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: item.isPrimary ? 12 : 11,
                fontWeight: item.isPrimary || isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
