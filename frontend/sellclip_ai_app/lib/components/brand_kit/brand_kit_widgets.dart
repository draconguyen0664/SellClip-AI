import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/projects/project_cards.dart';
import 'package:sellclip_ai_app/services/brand_kit_api.dart';

class BrandKitSearchField extends StatelessWidget {
  const BrandKitSearchField({
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
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm brand kit...',
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Colors.white.withValues(alpha: 0.75),
          size: 26,
        ),
        filled: true,
        fillColor: projectPanel.withValues(alpha: 0.72),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
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

class BrandKitCard extends StatelessWidget {
  const BrandKitCard({
    super.key,
    required this.brandKit,
    required this.selected,
    required this.onTap,
  });

  final BrandKitSummary brandKit;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF071834).withValues(alpha: 0.96)
              : projectPanel.withValues(alpha: 0.68),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                selected ? projectBlue : Colors.white.withValues(alpha: 0.13),
            width: selected ? 1.4 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: projectPurple.withValues(alpha: 0.35),
                    blurRadius: 20,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            BrandKitLogo(brandKit: brandKit),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brandKit.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Cập nhật: ${brandKit.updatedDate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: projectMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final color in brandKit.palette.take(5))
                        _ColorSwatch(hexColor: color),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.text_fields_rounded,
                        label: '${brandKit.fontCount} fonts',
                      ),
                      _MetaChip(
                        icon: Icons.image_outlined,
                        label: '${brandKit.assetCount} assets',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _RadioDot(selected: selected),
          ],
        ),
      ),
    );
  }
}

class BrandKitLogo extends StatelessWidget {
  const BrandKitLogo({super.key, required this.brandKit, this.size = 76});

  final BrandKitSummary brandKit;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = brandKit.palette.map(_parseColor).toList();
    final primary = colors.isNotEmpty ? colors.first : projectPurple;
    final secondary = colors.length > 1 ? colors[1] : projectBlue;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, secondary]),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_logoIcon(brandKit.logoCode),
              color: Colors.white, size: size * 0.36),
          const SizedBox(height: 5),
          Text(
            _logoText(brandKit.logoCode),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.13,
              height: 1.05,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  static IconData _logoIcon(String code) {
    final normalized = code.toUpperCase();
    if (normalized.contains('GLOW')) return Icons.local_florist_outlined;
    if (normalized.contains('FASHION')) return Icons.diamond_outlined;
    if (normalized.contains('TECH')) return Icons.shopping_cart_outlined;
    if (normalized.contains('ORGANIC')) return Icons.eco_outlined;
    return Icons.workspace_premium_outlined;
  }

  static String _logoText(String code) {
    final normalized = code.toUpperCase();
    if (normalized.contains('SELLCLIP')) return 'SELLCLIP';
    if (normalized.contains('GLOW')) return 'GLOW\nBEAUTY';
    if (normalized.contains('FASHION')) return 'FASHION\nHOUSE';
    if (normalized.contains('TECH')) return 'TECH SHOP';
    if (normalized.contains('ORGANIC')) return 'ORGANIC\nHOME';
    return normalized;
  }
}

class BrandKitInfoBanner extends StatelessWidget {
  const BrandKitInfoBanner({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF081735).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: projectBlue.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded,
              color: projectPurple, size: 34),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dùng Brand Kit để đồng bộ thương hiệu',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Áp dụng màu sắc, logo và kiểu chữ vào dự án nhanh chóng.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: projectMuted, fontSize: 12.5),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: projectMuted),
          ),
        ],
      ),
    );
  }
}

class CreateBrandKitTile extends StatelessWidget {
  const CreateBrandKitTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: projectPanel.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: projectPurple,
                  width: 1.2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child:
                  const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Tạo Brand Kit mới',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }
}

class BrandKitApplyButton extends StatelessWidget {
  const BrandKitApplyButton({
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
        gradient:
            const LinearGradient(colors: [Color(0xFF4B0DFF), projectBlue]),
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
            height: 54,
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
                      'Áp dụng Brand Kit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.88), size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.hexColor});

  final String hexColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: _parseColor(hexColor),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              selected ? projectPurple : Colors.white.withValues(alpha: 0.55),
          width: 1.2,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: projectPurple.withValues(alpha: 0.45),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? Colors.white : Colors.transparent,
        ),
      ),
    );
  }
}

Color _parseColor(String hexColor) {
  final clean = hexColor.replaceAll('#', '').trim();
  final value = int.tryParse(clean.length == 6 ? 'FF$clean' : clean, radix: 16);
  return Color(value ?? 0xFF7B2DFF);
}
