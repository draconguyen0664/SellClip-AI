import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/auth/auth_controls.dart';
import 'package:sellclip_ai_app/components/brand/sellclip_logo.dart';
import 'package:sellclip_ai_app/components/login/login_background.dart';
import 'package:sellclip_ai_app/screens/dashboard_page.dart';
import 'package:sellclip_ai_app/services/auth_api.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({required this.userId, super.key});

  final int userId;

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final _api = AuthApi();
  int _step = 0;
  String _industry = 'Công nghệ';
  final Set<String> _platforms = {'TikTok', 'YouTube Shorts', 'Website'};
  final Set<String> _goals = {'Bán sản phẩm', 'Tăng tương tác'};
  String _mediaType = 'Tôi chỉ có ảnh sản phẩm';
  final Set<String> _styles = {'Gen Z', 'Chuyên nghiệp', 'Storytelling'};
  String _voiceType = 'Nữ trẻ';
  bool _saving = false;
  String _status = 'Step incomplete';

  List<_OnboardingStep> get _steps => const [
        _OnboardingStep(
          title: 'Chọn ngành hàng',
          subtitle: 'Doanh nghiệp của bạn thuộc ngành nào?',
          hint: 'Tìm kiếm ngành hàng',
          options: [
            _Option('Mỹ phẩm', Icons.brush_outlined),
            _Option('Thời trang', Icons.checkroom_outlined),
            _Option('Đồ ăn', Icons.lunch_dining_outlined),
            _Option('Gia dụng', Icons.soup_kitchen_outlined),
            _Option('Công nghệ', Icons.laptop_mac_outlined),
            _Option('Phụ kiện', Icons.shopping_bag_outlined),
            _Option('Mẹ và bé', Icons.child_care_outlined),
            _Option('Nội thất', Icons.chair_outlined),
            _Option('Dịch vụ', Icons.support_agent_outlined),
            _Option('Affiliate', Icons.link_outlined),
            _Option('Ngành khác', Icons.more_horiz_outlined, wide: true),
          ],
        ),
        _OnboardingStep(
          title: 'Chọn nền tảng',
          subtitle: 'Bạn muốn đăng clip lên nền tảng nào?',
          helper: 'Có thể chọn nhiều',
          options: [
            _Option('TikTok', Icons.music_note_outlined),
            _Option('Facebook\nReels', Icons.facebook),
            _Option('Instagram\nReels', Icons.camera_alt_outlined),
            _Option('YouTube\nShorts', Icons.play_arrow_rounded),
            _Option('Shopee Video', Icons.shopping_bag),
            _Option('Zalo', Icons.chat_bubble_outline),
            _Option('Website', Icons.language_outlined),
          ],
        ),
        _OnboardingStep(
          title: 'Chọn mục tiêu nội dung',
          subtitle: 'Bạn muốn clip của mình hướng đến mục tiêu nào?',
          options: [
            _Option('Bán sản phẩm', Icons.shopping_bag_outlined),
            _Option('Tăng nhận diện', Icons.campaign_outlined),
            _Option('Tăng tương tác', Icons.favorite_outline),
            _Option('Làm affiliate', Icons.link_outlined),
            _Option('Tạo review', Icons.reviews_outlined),
            _Option('Chạy flash sale', Icons.bolt_outlined),
            _Option('Xây thương hiệu cá nhân', Icons.person_outline,
                wide: true),
          ],
        ),
        _OnboardingStep(
          title: 'Chọn loại media',
          subtitle: 'Bạn đang có nguyên liệu nào để tạo clip?',
          options: [
            _Option('Tôi chỉ có\nảnh sản phẩm', Icons.image_outlined,
                tall: true),
            _Option('Tôi có\nvideo thô', Icons.videocam_outlined, tall: true),
            _Option('Tôi có cả\nảnh và video', Icons.perm_media_outlined,
                tall: true),
            _Option('Tôi muốn AI tự\ntạo hình ảnh', Icons.auto_awesome_outlined,
                tall: true),
          ],
        ),
        _OnboardingStep(
          title: 'Chọn style và voice',
          subtitle:
              'Chọn phong cách nội dung và giọng đọc phù hợp với thương hiệu của bạn.',
          options: [
            _Option('Gen Z', Icons.sentiment_very_satisfied_outlined),
            _Option('Sang trọng', Icons.diamond_outlined),
            _Option('Tự nhiên', Icons.eco_outlined),
            _Option('Chuyên nghiệp', Icons.business_center_outlined),
            _Option('Dễ thương', Icons.favorite_outline),
            _Option('Năng lượng', Icons.bolt_outlined),
            _Option('Chuyên gia', Icons.person_pin_outlined),
            _Option('Storytelling', Icons.menu_book_outlined),
          ],
        ),
      ];

  Future<void> _finish({bool skipped = false}) async {
    setState(() {
      _saving = true;
      _status = skipped ? 'Skipped' : 'Syncing';
    });
    final response = await _api.saveOnboarding(
      userId: widget.userId,
      skipped: skipped,
      industry: _industry,
      platforms: _platforms.toList(),
      contentGoals: _goals.toList(),
      mediaType: _mediaType,
      contentStyles: _styles.toList(),
      voiceType: _voiceType,
    );
    if (!mounted) return;
    setState(() {
      _saving = false;
      _status =
          response.ok ? (skipped ? 'Skipped' : 'Completed') : 'Saved locally';
    });
    _openDashboard();
  }

  void _openDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const DashboardPage()),
    );
  }

  void _continue() {
    if (_step == 4) {
      _finish();
      return;
    }
    setState(() {
      _step++;
      _status = 'Step incomplete';
    });
  }

  void _toggleOption(String label) {
    setState(() {
      if (_step == 0) {
        _industry = label;
      } else if (_step == 1) {
        _toggleSet(_platforms, label);
      } else if (_step == 2) {
        _toggleSet(_goals, label);
      } else if (_step == 3) {
        _mediaType = label.replaceAll('\n', ' ');
      } else {
        _toggleSet(_styles, label);
      }
      _status = 'Saved locally';
    });
  }

  void _toggleSet(Set<String> values, String label) {
    final normalized = label.replaceAll('\n', ' ');
    if (values.contains(normalized)) {
      values.remove(normalized);
    } else {
      values.add(normalized);
    }
  }

  bool _isSelected(String label) {
    final normalized = label.replaceAll('\n', ' ');
    return switch (_step) {
      0 => _industry == normalized,
      1 => _platforms.contains(normalized),
      2 => _goals.contains(normalized),
      3 => _mediaType == normalized,
      _ => _styles.contains(normalized),
    };
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    return Scaffold(
      backgroundColor: const Color(0xFF020514),
      body: Stack(
        children: [
          const Positioned.fill(child: LoginBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 360;
                final side = (constraints.maxWidth * 0.07).clamp(18.0, 34.0);
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(side, 20, side, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 44,
                    ),
                    child: Column(
                      children: [
                        _TopBar(onSkip: () => _finish(skipped: true)),
                        const SizedBox(height: 28),
                        _StepCard(
                          stepIndex: _step,
                          status: _status,
                          step: step,
                          compact: compact,
                          saving: _saving,
                          selected: _isSelected,
                          onOptionTap: _toggleOption,
                          onContinue: _continue,
                          voiceType: _voiceType,
                          onVoiceChanged: (value) {
                            setState(() {
                              _voiceType = value;
                              _status = 'Saved locally';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SellClipLogo(width: 140, showTagline: false),
          ),
        ),
        const Spacer(),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onSkip,
              label: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Bỏ qua', maxLines: 1),
              ),
              icon: const Icon(Icons.chevron_right),
              iconAlignment: IconAlignment.end,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withValues(alpha: 0.62),
                textStyle: const TextStyle(fontSize: 17),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.stepIndex,
    required this.status,
    required this.step,
    required this.compact,
    required this.saving,
    required this.selected,
    required this.onOptionTap,
    required this.onContinue,
    required this.voiceType,
    required this.onVoiceChanged,
  });

  final int stepIndex;
  final String status;
  final _OnboardingStep step;
  final bool compact;
  final bool saving;
  final bool Function(String label) selected;
  final ValueChanged<String> onOptionTap;
  final VoidCallback onContinue;
  final String voiceType;
  final ValueChanged<String> onVoiceChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.fromLTRB(compact ? 18 : 24, 26, compact ? 18 : 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF080A20).withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(28),
        border:
            Border.all(color: const Color(0xFF9B4DFF).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF732DFF).withValues(alpha: 0.25),
            blurRadius: 34,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            step.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 31 : 36,
              height: 1.08,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            step.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.58),
              fontSize: compact ? 16 : 18,
              height: 1.35,
            ),
          ),
          if (step.helper != null) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(Icons.check_circle_outline,
                    color: Colors.white.withValues(alpha: 0.62)),
                const SizedBox(width: 8),
                Text(step.helper!,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 16)),
              ],
            ),
          ],
          const SizedBox(height: 24),
          _Progress(step: stepIndex),
          const SizedBox(height: 22),
          if (step.hint != null) ...[
            _SearchBox(hint: step.hint!),
            const SizedBox(height: 16),
          ],
          _OptionGrid(
            options: step.options,
            compact: compact,
            selected: selected,
            onTap: onOptionTap,
          ),
          if (stepIndex == 4) ...[
            const SizedBox(height: 22),
            _VoicePreview(
              voiceType: voiceType,
              onChanged: onVoiceChanged,
            ),
          ],
          const SizedBox(height: 24),
          Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: status == 'Failed to save'
                  ? const Color(0xFFFF6B8A)
                  : const Color(0xFF0AA5FF),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          AuthGradientButton(
            label: stepIndex == 4 ? 'Hoàn tất' : 'Tiếp tục',
            loading: saving,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bước ${step + 1}/5',
          style: const TextStyle(
            color: Color(0xFFBF35FF),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 7,
                margin: EdgeInsets.only(right: index == 4 ? 0 : 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  gradient: index <= step
                      ? const LinearGradient(
                          colors: [Color(0xFFB837FF), Color(0xFF168DFF)])
                      : null,
                  color: index <= step
                      ? null
                      : Colors.white.withValues(alpha: 0.10),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          Icon(Icons.search,
              color: Colors.white.withValues(alpha: 0.72), size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                hint,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.42),
                  fontSize: 17,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _OptionGrid extends StatelessWidget {
  const _OptionGrid({
    required this.options,
    required this.compact,
    required this.selected,
    required this.onTap,
  });

  final List<_Option> options;
  final bool compact;
  final bool Function(String label) selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = compact ? 10.0 : 12.0;
        final itemWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: options.map((option) {
            final wide = option.wide || constraints.maxWidth < 300;
            return SizedBox(
              width: wide ? constraints.maxWidth : itemWidth,
              child: _OptionTile(
                option: option,
                selected: selected(option.label),
                onTap: () => onTap(option.label),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _Option option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final height = option.tall ? 180.0 : 76.0;
    return Material(
      color: Colors.white.withValues(alpha: selected ? 0.06 : 0.035),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFF168DFF)
                  : Colors.white.withValues(alpha: 0.17),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                        color: const Color(0xFF8F37FF).withValues(alpha: 0.35),
                        blurRadius: 18),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: option.tall
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _GradientIcon(option.icon, size: 74),
                          const SizedBox(height: 22),
                          Text(
                            option.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 19, height: 1.2),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          _GradientIcon(option.icon),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                option.label,
                                maxLines: 2,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.15),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              if (selected)
                const Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF116DFF),
                    child: Icon(Icons.check, color: Colors.white, size: 24),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoicePreview extends StatelessWidget {
  const _VoicePreview({required this.voiceType, required this.onChanged});

  final String voiceType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const voices = ['Nữ trẻ', 'Nam ấm', 'Truyền cảm'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Voice preview',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF8F37FF)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 27,
                backgroundColor: Color(0xFF4737FF),
                child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
              ),
              const SizedBox(width: 16),
              const Expanded(
                  child: Text('Voice preview ngắn',
                      style: TextStyle(color: Colors.white, fontSize: 16))),
              Text('0:12',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: voices.map((voice) {
            final active = voiceType == voice;
            return ChoiceChip(
              selected: active,
              onSelected: (_) => onChanged(voice),
              label: Text(voice),
              avatar: Icon(
                voice == 'Nữ trẻ'
                    ? Icons.face_3_outlined
                    : voice == 'Nam ấm'
                        ? Icons.face_outlined
                        : Icons.favorite_outline,
                color: active ? Colors.white : const Color(0xFF8F37FF),
              ),
              selectedColor: const Color(0xFF116DFF),
              backgroundColor: Colors.white.withValues(alpha: 0.04),
              labelStyle: const TextStyle(color: Colors.white),
              side: BorderSide(
                  color: active
                      ? const Color(0xFF168DFF)
                      : Colors.white.withValues(alpha: 0.16)),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _GradientIcon extends StatelessWidget {
  const _GradientIcon(this.icon, {this.size = 42});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        colors: [Color(0xFFDF4CFF), Color(0xFF168DFF)],
      ).createShader(rect),
      child: Icon(icon, color: Colors.white, size: size),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.options,
    this.helper,
    this.hint,
  });

  final String title;
  final String subtitle;
  final String? helper;
  final String? hint;
  final List<_Option> options;
}

class _Option {
  const _Option(this.label, this.icon, {this.wide = false, this.tall = false});

  final String label;
  final IconData icon;
  final bool wide;
  final bool tall;
}
