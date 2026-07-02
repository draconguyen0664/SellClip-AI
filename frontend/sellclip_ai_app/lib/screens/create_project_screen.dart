import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/home/home_background.dart';
import 'package:sellclip_ai_app/components/projects/project_cards.dart';
import 'package:sellclip_ai_app/screens/brand_kit_screen.dart';
import 'package:sellclip_ai_app/screens/template_screen.dart';
import 'package:sellclip_ai_app/services/brand_kit_api.dart';
import 'package:sellclip_ai_app/services/project_api.dart';
import 'package:sellclip_ai_app/services/template_api.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _api = ProjectApi();
  final _name = TextEditingController();
  ProjectType _type = ProjectType.imageToVideo;
  AspectRatioOption _ratio = AspectRatioOption.ratio916;
  BrandKitSummary? _selectedBrandKit;
  TemplateSummary? _selectedTemplate;
  String _brandKit = 'SellClip Default';
  String _templateName = 'Không dùng template';
  bool _loading = false;
  String _message = '';
  bool _isError = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _createProject() async {
    if (_name.text.trim().isEmpty) {
      setState(() {
        _message = 'Vui lòng nhập tên project';
        _isError = true;
      });
      return;
    }

    setState(() {
      _loading = true;
      _message = '';
      _isError = false;
    });

    final response = await _api.createProject(
      ownerId: 1,
      name: _name.text.trim(),
      type: _type,
      aspectRatio: _ratio,
      brandKit: _brandKit,
      templateName: _templateName,
    );

    if (!mounted) return;
    setState(() {
      _loading = false;
      _message = response.message;
      _isError = !response.ok;
    });

    if (response.ok) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (mounted) Navigator.of(context).pop(response.project);
    }
  }

  Future<void> _chooseBrandKit() async {
    final selected = await Navigator.of(context).push<BrandKitSummary>(
      MaterialPageRoute(
        builder: (_) => BrandKitScreen(
          ownerId: 1,
          selectedBrandKitName: _brandKit,
        ),
      ),
    );
    if (!mounted || selected == null) return;
    setState(() {
      _selectedBrandKit = selected;
      _brandKit = selected.name;
      _message = 'Đã áp dụng ${selected.name}';
      _isError = false;
    });
  }

  Future<void> _chooseTemplate() async {
    final result = await Navigator.of(context).push<TemplateScreenResult>(
      MaterialPageRoute(
        builder: (_) => TemplateScreen(
          ownerId: 1,
          selectedTemplateName: _templateName,
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (result.noTemplate) {
        _selectedTemplate = null;
        _templateName = 'Không dùng template';
        _message = 'Đã chọn không dùng template';
      } else {
        _selectedTemplate = result.template;
        _templateName = result.template!.name;
        _message = 'Đã áp dụng ${result.template!.name}';
      }
      _isError = false;
    });
  }

  String get _brandKitSubtitle {
    final selected = _selectedBrandKit;
    if (selected == null) return 'Bộ nhận diện thương hiệu mặc định';
    return '${selected.fontCount} fonts • ${selected.assetCount} assets';
  }

  String get _templateSubtitle {
    final selected = _selectedTemplate;
    if (selected == null) return 'Bắt đầu từ trang trống';
    return '${selected.category} • ${selected.aspectRatio} • ${selected.durationLabel}';
  }

  @override
  Widget build(BuildContext context) {
    final side = (MediaQuery.sizeOf(context).width * 0.05).clamp(16.0, 24.0);
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
                  padding: EdgeInsets.fromLTRB(side, 8, side, 104),
                  sliver: SliverList.list(
                    children: [
                      const _CreateProjectHeader(),
                      const SizedBox(height: 16),
                      _NameSection(controller: _name),
                      const SizedBox(height: 12),
                      _ProjectTypeSection(
                        selected: _type,
                        onChanged: (value) => setState(() => _type = value),
                      ),
                      const SizedBox(height: 12),
                      _RatioSection(
                        selected: _ratio,
                        onChanged: (value) => setState(() => _ratio = value),
                      ),
                      const SizedBox(height: 12),
                      _PickerSection(
                        title: 'Brand Kit',
                        icon: Icons.workspace_premium_outlined,
                        titleText: _brandKit,
                        subtitle: _brandKitSubtitle,
                        onTap: _chooseBrandKit,
                      ),
                      const SizedBox(height: 12),
                      _TemplatePickerSection(
                        titleText: _templateName,
                        subtitle: _templateSubtitle,
                        onTap: _chooseTemplate,
                      ),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isError
                                  ? const Color(0xFFFF6175)
                                  : const Color(0xFF46E38C),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
          child: _CreateButton(loading: _loading, onPressed: _createProject),
        ),
      ),
    );
  }
}

class _CreateProjectHeader extends StatelessWidget {
  const _CreateProjectHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
              iconSize: 24,
              tooltip: 'Quay lại',
            ),
          ),
          const Text(
            'Tạo project',
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

class _NameSection extends StatelessWidget {
  const _NameSection({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _GlassSection(
      title: 'Tên project',
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'Nhập tên project của bạn',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
          filled: true,
          fillColor: const Color(0xFF071026).withValues(alpha: 0.82),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: _inputBorder(projectPurple.withValues(alpha: 0.9)),
          focusedBorder: _inputBorder(projectBlue),
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }
}

class _ProjectTypeSection extends StatelessWidget {
  const _ProjectTypeSection({required this.selected, required this.onChanged});

  final ProjectType selected;
  final ValueChanged<ProjectType> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      _ProjectTypeOption(
        type: ProjectType.imageToVideo,
        icon: Icons.image_outlined,
        title: 'Image to Video',
        subtitle: 'Tạo video từ hình ảnh',
      ),
      _ProjectTypeOption(
        type: ProjectType.rawVideoEditor,
        icon: Icons.movie_creation_outlined,
        title: 'Raw Video Editor',
        subtitle: 'Chỉnh sửa video thô',
      ),
      _ProjectTypeOption(
        type: ProjectType.poster,
        icon: Icons.article_outlined,
        title: 'Poster',
        subtitle: 'Thiết kế poster ấn tượng',
      ),
      _ProjectTypeOption(
        type: ProjectType.imageEditor,
        icon: Icons.auto_fix_high_rounded,
        title: 'Image Editor',
        subtitle: 'Chỉnh sửa và nâng cấp hình ảnh',
      ),
    ];

    return _GlassSection(
      title: 'Loại project',
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _ProjectTypeTile(
              option: items[i],
              selected: selected == items[i].type,
              onTap: () => onChanged(items[i].type),
            ),
            if (i != items.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ProjectTypeOption {
  const _ProjectTypeOption({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final ProjectType type;
  final IconData icon;
  final String title;
  final String subtitle;
}

class _ProjectTypeTile extends StatelessWidget {
  const _ProjectTypeTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _ProjectTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: _selectedDecoration(selected),
          child: Row(
            children: [
              _RadioDot(selected: selected),
              const SizedBox(width: 13),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [projectPurple, projectBlue],
                ).createShader(bounds),
                child: Icon(option.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      option.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: projectMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? projectPurple : Colors.white.withValues(alpha: 0.45),
          width: 1.3,
        ),
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

class _RatioSection extends StatelessWidget {
  const _RatioSection({required this.selected, required this.onChanged});

  final AspectRatioOption selected;
  final ValueChanged<AspectRatioOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return _GlassSection(
      title: 'Tỷ lệ',
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 10.0;
          final width = (constraints.maxWidth - gap) / 2;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final ratio in AspectRatioOption.values)
                SizedBox(
                  width: width,
                  child: _RatioTile(
                    ratio: ratio,
                    selected: selected == ratio,
                    onTap: () => onChanged(ratio),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RatioTile extends StatelessWidget {
  const _RatioTile({required this.ratio, required this.selected, required this.onTap});

  final AspectRatioOption ratio;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 76,
          decoration: _selectedDecoration(selected),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_ratioIcon(ratio), color: Colors.white, size: 26),
              const SizedBox(height: 6),
              Text(
                ratio.label,
                style: TextStyle(
                  color: selected ? projectPurple : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _ratioIcon(AspectRatioOption ratio) {
    return switch (ratio) {
      AspectRatioOption.ratio916 => Icons.crop_portrait_rounded,
      AspectRatioOption.ratio11 => Icons.crop_square_rounded,
      AspectRatioOption.ratio45 => Icons.crop_5_4_rounded,
      AspectRatioOption.ratio169 => Icons.crop_16_9_rounded,
    };
  }
}

class _PickerSection extends StatelessWidget {
  const _PickerSection({
    required this.title,
    required this.icon,
    required this.titleText,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String titleText;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _GlassSection(
      title: title,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: _PickerContent(
            icon: icon,
            titleText: titleText,
            subtitle: subtitle,
          ),
        ),
      ),
    );
  }
}

class _TemplatePickerSection extends StatelessWidget {
  const _TemplatePickerSection({
    required this.titleText,
    required this.subtitle,
    required this.onTap,
  });

  final String titleText;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _GlassSection(
      title: 'Template tùy chọn',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: _PickerContent(
            icon: titleText == 'Không dùng template'
                ? Icons.block_rounded
                : Icons.play_circle_outline_rounded,
            titleText: titleText,
            subtitle: subtitle,
            plainIcon: titleText == 'Không dùng template',
          ),
        ),
      ),
    );
  }
}

class _PickerContent extends StatelessWidget {
  const _PickerContent({
    required this.icon,
    required this.titleText,
    required this.subtitle,
    this.plainIcon = false,
  });

  final IconData icon;
  final String titleText;
  final String subtitle;
  final bool plainIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 66),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF071026).withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: plainIcon ? Colors.white.withValues(alpha: 0.04) : null,
              gradient: plainIcon
                  ? null
                  : const LinearGradient(colors: [projectPurple, Color(0xFF043BFF)]),
              borderRadius: BorderRadius.circular(plainIcon ? 12 : 28),
              border: Border.all(
                color: Colors.white.withValues(alpha: plainIcon ? 0.28 : 0),
                width: 1.2,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: projectMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}

class _GlassSection extends StatelessWidget {
  const _GlassSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
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

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF3B16FF), projectBlue]),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: projectBlue.withValues(alpha: 0.2),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(13),
          child: SizedBox(
            height: 54,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Tạo project',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _selectedDecoration(bool selected) {
  return BoxDecoration(
    color: selected
        ? const Color(0xFF0A1432).withValues(alpha: 0.92)
        : const Color(0xFF071026).withValues(alpha: 0.58),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: selected ? projectBlue : Colors.white.withValues(alpha: 0.18),
      width: selected ? 1.4 : 1,
    ),
    boxShadow: selected
        ? [BoxShadow(color: projectPurple.withValues(alpha: 0.35), blurRadius: 16)]
        : null,
  );
}