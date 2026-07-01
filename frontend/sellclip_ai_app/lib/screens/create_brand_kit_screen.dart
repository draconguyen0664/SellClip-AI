import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellclip_ai_app/components/home/home_background.dart';
import 'package:sellclip_ai_app/components/projects/project_cards.dart';
import 'package:sellclip_ai_app/services/brand_kit_api.dart';

enum CreateBrandKitStatus {
  idle,
  missingName,
  logoSelected,
  colorAdded,
  assetAdded,
  saving,
  success,
  serverError,
}

class CreateBrandKitScreen extends StatefulWidget {
  const CreateBrandKitScreen({super.key, required this.ownerId});

  final int ownerId;

  @override
  State<CreateBrandKitScreen> createState() => _CreateBrandKitScreenState();
}

class _CreateBrandKitScreenState extends State<CreateBrandKitScreen> {
  final _api = BrandKitApi();
  final _picker = ImagePicker();
  final _name = TextEditingController();
  final _palette = <String>[
    '#4D1C8F',
    '#6E2D73',
    '#123D9B',
    '#248E9B',
    '#F7F7F7',
  ];

  CreateBrandKitStatus _status = CreateBrandKitStatus.idle;
  String _message = '';
  String _headingFont = '';
  String _bodyFont = '';
  XFile? _logoImage;
  int _productAssetCount = 0;
  int _iconAssetCount = 0;

  bool get _canCreate => _name.text.trim().isNotEmpty;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _setStatus(CreateBrandKitStatus status, String message) {
    setState(() {
      _status = status;
      _message = message;
    });
  }

  Future<void> _pickLogo() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _logoImage = picked;
      _status = CreateBrandKitStatus.logoSelected;
      _message = 'Đã chọn logo từ điện thoại';
    });
  }

  Future<void> _addColor() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF080B26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ColorPickerSheet(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _palette.add(picked);
      _status = CreateBrandKitStatus.colorAdded;
      _message = 'Đã thêm màu thương hiệu';
    });
  }

  Future<void> _chooseFont(bool heading) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF080B26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _FontPickerSheet(
        title: heading ? 'Chọn font tiêu đề' : 'Chọn font nội dung',
        selected: heading ? _headingFont : _bodyFont,
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (heading) {
        _headingFont = selected;
      } else {
        _bodyFont = selected;
      }
      _message = heading ? 'Đã chọn font tiêu đề' : 'Đã chọn font nội dung';
    });
  }

  Future<void> _addAsset(bool product) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (product) {
        _productAssetCount++;
      } else {
        _iconAssetCount++;
      }
      _status = CreateBrandKitStatus.assetAdded;
      _message = product ? 'Đã chọn ảnh sản phẩm' : 'Đã chọn icon / sticker';
    });
  }

  Future<void> _createBrandKit() async {
    if (_name.text.trim().isEmpty) {
      _setStatus(
        CreateBrandKitStatus.missingName,
        'Vui lòng nhập tên Brand Kit',
      );
      return;
    }

    setState(() {
      _status = CreateBrandKitStatus.saving;
      _message = '';
    });
    try {
      final response = await _api.createBrandKit(
        ownerId: widget.ownerId,
        name: _name.text.trim(),
        logoCode: _logoImage == null ? 'SK' : 'IMG',
        palette: _palette,
        headingFont: _headingFont.isEmpty ? 'Inter Display' : _headingFont,
        bodyFont: _bodyFont.isEmpty ? 'Inter' : _bodyFont,
        productAssetCount: _productAssetCount,
        iconAssetCount: _iconAssetCount,
      );
      if (!mounted) return;
      setState(() {
        _status = CreateBrandKitStatus.success;
        _message = response.message;
      });
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (mounted) Navigator.of(context).pop(response.brandKit);
    } catch (_) {
      if (!mounted) return;
      _setStatus(
        CreateBrandKitStatus.serverError,
        'Không tạo được Brand Kit. Vui lòng thử lại.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = (width * 0.06).clamp(18.0, 28.0);

    return Scaffold(
      backgroundColor: const Color(0xFF020514),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(side, 8, side, 96),
                  sliver: SliverList.list(
                    children: [
                      const _CreateBrandKitHeader(),
                      const SizedBox(height: 16),
                      _Section(
                        title: 'Tên Brand Kit',
                        child: TextField(
                          controller: _name,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          decoration: _inputDecoration('Nhập tên brand kit'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Section(
                        title: 'Logo thương hiệu',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: _pickLogo,
                          child: Container(
                            height: 150,
                            decoration: _dashedBox(),
                            child: Center(
                              child: _logoImage == null
                                  ? const _UploadPrompt()
                                  : _SelectedImagePrompt(image: _logoImage!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Section(
                        title: 'Màu thương hiệu  ⓘ',
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final color in _palette.take(8))
                              _ColorTile(hexColor: color),
                            _AddColorTile(onTap: _addColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Section(
                        title: 'Typography',
                        child: Column(
                          children: [
                            _PickerRow(
                              label: _headingFont.isEmpty
                                  ? 'Chọn font tiêu đề từ danh sách'
                                  : _headingFont,
                              onTap: () => _chooseFont(true),
                            ),
                            const SizedBox(height: 10),
                            _PickerRow(
                              label: _bodyFont.isEmpty
                                  ? 'Chọn font nội dung từ danh sách'
                                  : _bodyFont,
                              onTap: () => _chooseFont(false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Section(
                        title: 'Brand assets',
                        child: Column(
                          children: [
                            _AssetRow(
                              icon: Icons.photo_library_outlined,
                              title: 'Ảnh sản phẩm',
                              subtitle: _productAssetCount == 0
                                  ? 'Chưa tải lên'
                                  : '$_productAssetCount ảnh đã chọn',
                              onTap: () => _addAsset(true),
                            ),
                            const SizedBox(height: 10),
                            _AssetRow(
                              icon: Icons.emoji_emotions_outlined,
                              title: 'Icon / sticker',
                              subtitle: _iconAssetCount == 0
                                  ? 'Chưa tải lên'
                                  : '$_iconAssetCount ảnh đã chọn',
                              onTap: () => _addAsset(false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Section(
                        title: 'Preview',
                        child: Container(
                          height: 130,
                          decoration: _dashedBox(),
                          child: Center(
                            child: _canCreate
                                ? _PreviewCard(
                                    name: _name.text.trim(),
                                    palette: _palette,
                                  )
                                : const _PreviewEmpty(),
                          ),
                        ),
                      ),
                      if (_message.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _status ==
                                        CreateBrandKitStatus.serverError ||
                                    _status == CreateBrandKitStatus.missingName
                                ? const Color(0xFFFF6175)
                                : projectBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(side, 8, side, 10),
          child: _CreateButton(
            enabled: _canCreate,
            loading: _status == CreateBrandKitStatus.saving,
            onTap: _createBrandKit,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
      filled: true,
      fillColor: const Color(0xFF071026).withValues(alpha: 0.72),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: _inputBorder(Colors.white.withValues(alpha: 0.16)),
      focusedBorder: _inputBorder(projectBlue),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1.1),
    );
  }

  BoxDecoration _dashedBox() {
    return BoxDecoration(
      color: const Color(0xFF071026).withValues(alpha: 0.42),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.32),
        width: 1.1,
      ),
    );
  }
}

class _CreateBrandKitHeader extends StatelessWidget {
  const _CreateBrandKitHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              color: Colors.white,
              iconSize: 28,
            ),
          ),
          const Text(
            'Tạo Brand Kit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadPrompt extends StatelessWidget {
  const _UploadPrompt();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.transparent,
          child: Icon(Icons.upload_rounded, color: projectBlue, size: 36),
        ),
        SizedBox(height: 16),
        Text(
          'Tải lên logo PNG, SVG',
          style: TextStyle(
            color: projectMuted,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Nhấn để chọn ảnh từ điện thoại',
          style: TextStyle(color: projectMuted, fontSize: 12.5),
        ),
      ],
    );
  }
}

class _SelectedImagePrompt extends StatelessWidget {
  const _SelectedImagePrompt({required this.image});

  final XFile image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(image.path),
            width: 76,
            height: 76,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đã chọn ảnh',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                image.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: projectMuted, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: projectBlue.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ColorTile extends StatelessWidget {
  const _ColorTile({required this.hexColor});

  final String hexColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: _colorFromHex(hexColor),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: projectPurple.withValues(alpha: 0.8)),
      ),
    );
  }
}

class _AddColorTile extends StatelessWidget {
  const _AddColorTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 78,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 24),
            SizedBox(height: 3),
            Text(
              'Color picker',
              style: TextStyle(color: projectMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF071026).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: projectMuted, fontSize: 15),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF071026).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: projectBlue.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: projectMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              width: 48,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FontPickerSheet extends StatelessWidget {
  const _FontPickerSheet({required this.title, required this.selected});

  final String title;
  final String selected;

  static const _fonts = [
    'Inter',
    'Inter Display',
    'Montserrat',
    'Poppins',
    'Roboto',
    'Be Vietnam Pro',
    'Playfair Display',
    'Oswald',
  ];

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.58;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: maxHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.26),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _fonts.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  itemBuilder: (context, index) {
                    final font = _fonts[index];
                    final isSelected = selected == font;
                    return ListTile(
                      onTap: () => Navigator.of(context).pop(font),
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 8,
                      title: Text(
                        font,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded, color: projectBlue)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPickerSheet extends StatefulWidget {
  const _ColorPickerSheet();

  @override
  State<_ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<_ColorPickerSheet> {
  double _hue = 12;
  double _saturation = 0;
  double _value = 1;
  double _alpha = 1;

  Color get _color =>
      HSVColor.fromAHSV(_alpha, _hue, _saturation, _value).toColor();

  int get _argb => _color.toARGB32();
  int get _red => (_argb >> 16) & 0xFF;
  int get _green => (_argb >> 8) & 0xFF;
  int get _blue => _argb & 0xFF;

  String get _hex {
    String part(int value) => value.toRadixString(16).padLeft(2, '0');
    return '#${part(_red)}${part(_green)}${part(_blue)}'.toUpperCase();
  }

  void _setRgb({int? red, int? green, int? blue}) {
    final color = Color.fromARGB(
      (_alpha * 255).round(),
      red ?? _red,
      green ?? _green,
      blue ?? _blue,
    );
    final hsv = HSVColor.fromColor(color);
    setState(() {
      _hue = hsv.hue;
      _saturation = hsv.saturation;
      _value = hsv.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.74;
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.paddingOf(context).bottom +
                34,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0D2A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: projectPurple.withValues(alpha: 0.8)),
              boxShadow: [
                BoxShadow(
                  color: projectPurple.withValues(alpha: 0.35),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SaturationValueBox(
                  hue: _hue,
                  saturation: _saturation,
                  value: _value,
                  onChanged: (saturation, value) {
                    setState(() {
                      _saturation = saturation;
                      _value = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _HueStrip(
                  hue: _hue,
                  onChanged: (hue) => setState(() => _hue = hue),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _AlphaRail(
                        alpha: _alpha,
                        color: _color.withValues(alpha: 1),
                        onChanged: (alpha) => setState(() => _alpha = alpha),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(_alpha * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF07091F),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Text(
                    _hex,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [projectPurple, projectBlue],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: projectPurple.withValues(alpha: 0.35),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: const Text(
                            'RGB',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'HSB',
                            style: TextStyle(
                              color: projectMuted,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _RgbStepper(
                        label: 'R',
                        value: _red,
                        onChanged: (value) => _setRgb(red: value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RgbStepper(
                        label: 'G',
                        value: _green,
                        onChanged: (value) => _setRgb(green: value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RgbStepper(
                        label: 'B',
                        value: _blue,
                        onChanged: (value) => _setRgb(blue: value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE174FF),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Hủy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: projectBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(_hex),
                        child: const Text(
                          'Thêm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SaturationValueBox extends StatelessWidget {
  const _SaturationValueBox({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.onChanged,
  });

  final double hue;
  final double saturation;
  final double value;
  final void Function(double saturation, double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.28,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final handleX = saturation * constraints.maxWidth;
          final handleY = (1 - value) * constraints.maxHeight;
          return GestureDetector(
            onPanDown: (details) => _update(details.localPosition, constraints),
            onPanUpdate: (details) =>
                _update(details.localPosition, constraints),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black],
                    ),
                  ),
                ),
                Positioned(
                  left: handleX.clamp(0, constraints.maxWidth) - 11,
                  top: handleY.clamp(0, constraints.maxHeight) - 11,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF403C69),
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _update(Offset offset, BoxConstraints constraints) {
    final nextSaturation = (offset.dx / constraints.maxWidth).clamp(0.0, 1.0);
    final nextValue = (1 - offset.dy / constraints.maxHeight).clamp(0.0, 1.0);
    onChanged(nextSaturation, nextValue);
  }
}

class _HueStrip extends StatelessWidget {
  const _HueStrip({required this.hue, required this.onChanged});

  final double hue;
  final ValueChanged<double> onChanged;

  static const _hueColors = [
    Color(0xFFFF3333),
    Color(0xFFFF2DD2),
    Color(0xFF6A00FF),
    Color(0xFF00A8FF),
    Color(0xFF34FF38),
    Color(0xFFFFFF00),
    Color(0xFFFF7A00),
    Color(0xFFFF3333),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final handleX = (hue / 360) * constraints.maxWidth;
          return GestureDetector(
            onPanDown: (details) => _update(details.localPosition, constraints),
            onPanUpdate: (details) =>
                _update(details.localPosition, constraints),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(colors: _hueColors),
                    border: Border.all(
                      color: projectPurple.withValues(alpha: 0.38),
                    ),
                  ),
                ),
                Positioned(
                  left: handleX.clamp(0, constraints.maxWidth) - 13,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _update(Offset offset, BoxConstraints constraints) {
    onChanged(((offset.dx / constraints.maxWidth).clamp(0.0, 1.0)) * 360);
  }
}

class _AlphaRail extends StatelessWidget {
  const _AlphaRail({
    required this.alpha,
    required this.color,
    required this.onChanged,
  });

  final double alpha;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final handleX = alpha * constraints.maxWidth;
          return GestureDetector(
            onPanDown: (details) => _update(details.localPosition, constraints),
            onPanUpdate: (details) =>
                _update(details.localPosition, constraints),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: 0), color],
                    ),
                    border: Border.all(
                      color: projectPurple.withValues(alpha: 0.42),
                    ),
                  ),
                ),
                Positioned(
                  left: handleX.clamp(0, constraints.maxWidth) - 11,
                  child: Container(
                    width: 22,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF403C69)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _update(Offset offset, BoxConstraints constraints) {
    onChanged((offset.dx / constraints.maxWidth).clamp(0.0, 1.0));
  }
}

class _RgbStepper extends StatelessWidget {
  const _RgbStepper({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF07091F),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => onChanged((value + 1).clamp(0, 255).toInt()),
                    child: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: projectMuted,
                      size: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () => onChanged((value - 1).clamp(0, 255).toInt()),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: projectMuted,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewEmpty extends StatelessWidget {
  const _PreviewEmpty();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.visibility_outlined, color: projectMuted, size: 38),
        SizedBox(height: 12),
        Text(
          'Preview sẽ hiển thị sau khi bạn\nthêm logo, màu sắc và typography.',
          textAlign: TextAlign.center,
          style: TextStyle(color: projectMuted, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.name, required this.palette});

  final String name;
  final List<String> palette;

  @override
  Widget build(BuildContext context) {
    final color = _colorFromHex(palette.first);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              const Icon(Icons.workspace_premium_outlined, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Flexible(
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: enabled
              ? const [Color(0xFF4B0DFF), projectBlue]
              : [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.06),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: loading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 54,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.4,
                      ),
                    )
                  : Text(
                      'Tạo Brand Kit',
                      style: TextStyle(
                        color: enabled ? Colors.white : projectMuted,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _colorFromHex(String hexColor) {
  final clean = hexColor.replaceAll('#', '');
  final value = int.tryParse('FF$clean', radix: 16) ?? 0xFF7B2DFF;
  return Color(value);
}
