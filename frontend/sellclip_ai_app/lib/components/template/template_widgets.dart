import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/projects/project_cards.dart';
import 'package:sellclip_ai_app/services/template_api.dart';

class TemplateSearchField extends StatelessWidget {
  const TemplateSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'T\u00ecm ki\u1ebfm template...',
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Colors.white.withValues(alpha: 0.75),
          size: 24,
        ),
        filled: true,
        fillColor: projectPanel.withValues(alpha: 0.72),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: _border(projectPurple.withValues(alpha: 0.45)),
        focusedBorder: _border(projectBlue),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1.1),
    );
  }
}

class TemplateCategoryChips extends StatelessWidget {
  const TemplateCategoryChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  static const categories = [
    'T\u1ea5t c\u1ea3',
    'M\u1ef9 ph\u1ea9m',
    'Th\u1eddi trang',
    'Flash sale',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories) ...[
            _CategoryChip(
              label: category,
              selected: selected == category,
              onTap: () => onSelected(category),
            ),
            const SizedBox(width: 9),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(colors: [projectPurple, Color(0xFF153DFF)])
                : null,
            color: selected ? null : projectPanel.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.transparent : Colors.white.withValues(alpha: 0.14),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class NoTemplateCard extends StatelessWidget {
  const NoTemplateCard({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF071834).withValues(alpha: 0.96)
                : projectPanel.withValues(alpha: 0.68),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? projectBlue : Colors.white.withValues(alpha: 0.13),
              width: selected ? 1.4 : 1,
            ),
            boxShadow: selected
                ? [BoxShadow(color: projectPurple.withValues(alpha: 0.28), blurRadius: 20)]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
                ),
                child: const Icon(Icons.block_rounded, color: projectMuted, size: 31),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kh\u00f4ng d\u00f9ng template',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'B\u1eaft \u0111\u1ea7u t\u1eeb trang tr\u1ed1ng',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: projectMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _SelectedBadge(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class TemplateCard extends StatelessWidget {
  const TemplateCard({
    super.key,
    required this.template,
    required this.selected,
    required this.onTap,
  });

  final TemplateSummary template;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: projectPanel.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected ? projectBlue : Colors.white.withValues(alpha: 0.14),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _TemplateThumb(template: template)),
              const SizedBox(height: 8),
              Text(
                template.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              _CategoryPill(label: template.category),
              const SizedBox(height: 8),
              _TemplateMeta(template: template),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateMeta extends StatelessWidget {
  const _TemplateMeta({required this.template});

  final TemplateSummary template;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.crop_portrait_rounded, color: projectMuted, size: 13),
        const SizedBox(width: 3),
        Text(
          template.aspectRatio,
          style: const TextStyle(color: projectMuted, fontSize: 10.5),
        ),
        const SizedBox(width: 7),
        const Icon(Icons.schedule_rounded, color: projectMuted, size: 13),
        const SizedBox(width: 3),
        Text(
          template.durationLabel,
          style: const TextStyle(color: projectMuted, fontSize: 10.5),
        ),
      ],
    );
  }
}
class _TemplateThumb extends StatelessWidget {
  const _TemplateThumb({required this.template});

  final TemplateSummary template;

  @override
  Widget build(BuildContext context) {
    final theme = _TemplateTheme.fromCode(template.thumbnailCode);
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.colors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -18,
              child: Icon(
                theme.icon,
                color: Colors.white.withValues(alpha: 0.14),
                size: 106,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(theme.icon, color: Colors.white, size: 28),
                  const Spacer(),
                  Text(
                    theme.headline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 0.95,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 7,
              top: 7,
              child: _AccessBadge(premium: template.premium),
            ),
            Positioned(
              right: 7,
              bottom: 7,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
                    Text(
                      '0:${template.durationSeconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _AccessBadge extends StatelessWidget {
  const _AccessBadge({required this.premium});

  final bool premium;

  @override
  Widget build(BuildContext context) {
    if (!premium) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF14371F).withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF52F279).withValues(alpha: 0.55)),
        ),
        child: const Text(
          'Free',
          style: TextStyle(
            color: Color(0xFF52F279),
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return Container(
      width: 28,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2200).withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFD424), width: 1),
      ),
      child: const Icon(
        Icons.workspace_premium_outlined,
        color: Color(0xFFFFD424),
        size: 15,
      ),
    );
  }
}
class _TemplateTheme {
  const _TemplateTheme({
    required this.colors,
    required this.icon,
    required this.headline,
  });

  final List<Color> colors;
  final IconData icon;
  final String headline;

  static _TemplateTheme fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'fashion':
        return const _TemplateTheme(
          colors: [Color(0xFF3E1235), Color(0xFFB94E8C)],
          icon: Icons.checkroom_rounded,
          headline: 'FASHION\nSALE',
        );
      case 'flash':
        return const _TemplateTheme(
          colors: [Color(0xFFFF2A18), Color(0xFFFFB000)],
          icon: Icons.flash_on_rounded,
          headline: 'FLASH\n6.6',
        );
      case 'review':
        return const _TemplateTheme(
          colors: [Color(0xFFFFC0D4), Color(0xFFD94F73)],
          icon: Icons.reviews_rounded,
          headline: 'REVIEW\nSON M\u00d4I',
        );
      default:
        return const _TemplateTheme(
          colors: [Color(0xFFD7C6FF), Color(0xFF7A42FF)],
          icon: Icons.water_drop_outlined,
          headline: 'GLOW\nSERUM',
        );
    }
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 92),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: projectPurple.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Color(0xFFD8A9FF), fontSize: 11),
      ),
    );
  }
}

class _SelectedBadge extends StatelessWidget {
  const _SelectedBadge({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (!selected) return const SizedBox.shrink();
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [projectPurple, projectBlue]),
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 23),
    );
  }
}

class TemplateApplyButton extends StatelessWidget {
  const TemplateApplyButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4B0DFF), projectBlue]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: projectBlue.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 52,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.4,
                      ),
                    )
                  : const Text(
                      '\u00c1p d\u1ee5ng template',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}