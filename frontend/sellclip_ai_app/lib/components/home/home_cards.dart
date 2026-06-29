import 'package:flutter/material.dart';

const _blue = Color(0xFF0996FF);
const _purple = Color(0xFFB735FF);
const _panel = Color(0xFF070B22);
const _panel2 = Color(0xFF101330);
const _muted = Color(0xFFA7A4B3);

class HomeUserGreeting extends StatelessWidget {
  const HomeUserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF26364F), Color(0xFF0B1329)],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.78)),
          ),
          child:
              const Icon(Icons.person_rounded, color: Colors.white, size: 27),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào Long 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                'Nguyễn Hoàng Long',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CreditBalanceCard extends StatelessWidget {
  const CreditBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _GlowPanel(
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 1000000;
          const creditInfo = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Số dư hiện tại',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              _CreditAmount(),
              SizedBox(height: 12),
              _CreditLine(
                  icon: Icons.event_available_outlined,
                  text: 'Sắp hết hạn: 200'),
              SizedBox(height: 6),
              _CreditLine(
                  icon: Icons.schedule_rounded,
                  text: 'Reset vào: 30/08/2026',
                  accent: true),
            ],
          );

          const upgrade = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.shrink(),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: _GradientButton(
                    label: 'Nâng cấp',
                    icon: Icons.workspace_premium_outlined,
                    compact: true),
              ),
            ],
          );

          if (!wide) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                creditInfo,
                SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: _GradientButton(
                      label: 'Nâng cấp',
                      icon: Icons.workspace_premium_outlined),
                ),
              ],
            );
          }

          return const Row(
            children: [
              Expanded(child: creditInfo),
              SizedBox(width: 12),
              SizedBox(width: 0, child: upgrade),
            ],
          );
        },
      ),
    );
  }
}

class CreateVideoPanel extends StatelessWidget {
  const CreateVideoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = [
      _HomeAction(Icons.image_outlined, 'Chọn ảnh'),
      _HomeAction(Icons.movie_creation_outlined, 'Video từ clip'),
      _HomeAction(Icons.article_outlined, 'Poster'),
      _HomeAction(Icons.auto_fix_high_rounded, 'AI content'),
    ];

    return _GlowPanel(
      padding: EdgeInsets.zero,
      borderColor: Colors.cyanAccent.withValues(alpha: 0.52),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [_purple, Color(0xFF0BA3FF)]),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline_rounded,
                    color: Colors.white, size: 22),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Tạo video mới',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 9999 ? 4 : 2;
                final itemWidth =
                    (constraints.maxWidth - (columns - 1) * 8) / columns;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: actions
                      .map((action) => SizedBox(
                            width: itemWidth,
                            height: 66,
                            child: _ActionTile(action: action),
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuickToolsSection extends StatelessWidget {
  const QuickToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const tools = [
      _HomeAction(Icons.content_cut_rounded, 'Xóa nền'),
      _HomeAction(Icons.edit_rounded, 'Viết content'),
      _HomeAction(Icons.graphic_eq_rounded, 'Tạo voice'),
      _HomeAction(Icons.chat_bubble_rounded, 'Tạo caption'),
      _HomeAction(Icons.open_in_full_rounded, 'Resize'),
      _HomeAction(Icons.image_outlined, 'Tạo poster'),
    ];

    return _Section(
      title: 'Công cụ nhanh',
      child: SizedBox(
        height: 72,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: tools.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) => SizedBox(
            width: 82,
            child: _ActionTile(action: tools[index], dense: true),
          ),
        ),
      ),
    );
  }
}

class RecentProjectsSection extends StatelessWidget {
  const RecentProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const projects = [
      _ProjectInfo(
        title: 'Serum Glow Launch',
        status: 'Draft',
        date: '28/05/2025',
        duration: '00:25',
        icon: Icons.water_drop_outlined,
        statusColor: _purple,
      ),
      _ProjectInfo(
        title: 'Review Son Mới',
        status: 'Done',
        date: '24/05/2025',
        duration: '00:28',
        icon: Icons.face_retouching_natural_outlined,
        statusColor: Color(0xFF22B957),
      ),
    ];

    return _Section(
      title: 'Dự án gần đây',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 9999 ? 2 : 1;
          final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: projects
                .map((project) => SizedBox(
                      width: width,
                      height: 86,
                      child: _ProjectCard(project: project),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class RenderingSection extends StatelessWidget {
  const RenderingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Section(
      title: 'Đang render',
      child: Column(
        children: [
          _RenderRow(
              title: 'Serum Glow Launch',
              subtitle: 'Đang tạo video',
              time: '02:14',
              percent: 88),
          SizedBox(height: 8),
          _RenderRow(
              title: 'Flash Sale 6.6',
              subtitle: 'Đang ghép video',
              time: '05:32',
              percent: 33),
        ],
      ),
    );
  }
}

class SuggestedTemplatesSection extends StatelessWidget {
  const SuggestedTemplatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const templates = [
      _TemplateInfo(
        title: 'Glow Serum Ad',
        category: 'Mỹ phẩm',
        badge: 'Premium',
        duration: '15s',
        icon: Icons.water_drop_outlined,
      ),
      _TemplateInfo(
        title: 'Fashion Sale',
        category: 'Thời trang',
        badge: 'Free',
        duration: '30s',
        icon: Icons.checkroom_outlined,
      ),
    ];

    return _Section(
      title: 'Template đề xuất',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 9999 ? 2 : 1;
          final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: templates
                .map((template) => SizedBox(
                      width: width,
                      height: 136,
                      child: _TemplateCard(template: template),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class UpdatesSection extends StatelessWidget {
  const UpdatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const updates = [
      _HomeAction(Icons.workspace_premium_outlined, 'Gói nâng cấp'),
      _HomeAction(Icons.confirmation_number_rounded, 'Coupon'),
      _HomeAction(Icons.copyright_rounded, 'Credit bonus'),
      _HomeAction(Icons.new_releases_rounded, 'Template mới'),
    ];

    return _Section(
      title: 'Ưu đãi & cập nhật',
      showAll: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 9999 ? 4 : 2;
          final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: updates
                .map((item) => SizedBox(
                      width: width,
                      height: 62,
                      child: _UpdateTile(action: item),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(
      {required this.title, required this.child, this.showAll = true});

  final String title;
  final Widget child;
  final bool showAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (showAll)
              TextButton.icon(
                onPressed: () {},
                label: const Text('Xem tất cả'),
                icon: const Icon(Icons.chevron_right_rounded),
                iconAlignment: IconAlignment.end,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.58),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(76, 34),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(fontSize: 13, fontFamily: 'Inter'),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final _ProjectInfo project;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _Thumb(icon: project.icon, size: 72),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.more_horiz_rounded,
                        color: Colors.white, size: 18),
                  ],
                ),
                const SizedBox(height: 5),
                _Pill(label: project.status, color: project.statusColor),
                const Spacer(),
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  children: [
                    _Meta(
                        icon: Icons.calendar_today_outlined,
                        text: project.date),
                    _Meta(icon: Icons.schedule_rounded, text: project.duration),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RenderRow extends StatelessWidget {
  const _RenderRow({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.percent,
  });

  final String title;
  final String subtitle;
  final String time;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const _SaleThumb(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _Meta(icon: Icons.schedule_rounded, text: time),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          value: percent / 100,
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(_blue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('$percent%',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 78,
            height: 34,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                    color: Colors.cyanAccent.withValues(alpha: 0.72)),
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11),
              ),
              child: const Text('Chi tiết'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final _TemplateInfo template;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _Thumb(icon: template.icon, size: 76),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Pill(label: template.category, color: _purple),
                const SizedBox(height: 5),
                Text(
                  template.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 8,
                  children: [
                    _Pill(
                        label: template.badge,
                        color: template.badge == 'Free'
                            ? Colors.green
                            : Colors.amber),
                    _Meta(
                        icon: Icons.schedule_rounded, text: template.duration),
                  ],
                ),
                const Spacer(),
                const SizedBox(
                  height: 28,
                  width: double.infinity,
                  child: _GradientButton(label: 'Sử dụng', compact: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, this.dense = false});

  final _HomeAction action;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: EdgeInsets.all(dense ? 7 : 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GradientIcon(action.icon, size: dense ? 23 : 26),
          const SizedBox(height: 6),
          Text(
            action.label,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: dense ? 10.5 : 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateTile extends StatelessWidget {
  const _UpdateTile({required this.action});

  final _HomeAction action;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _GradientIcon(action.icon, size: 26),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              action.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowPanel extends StatelessWidget {
  const _GlowPanel({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _panel.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: borderColor ?? _purple.withValues(alpha: 0.42),
        ),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.14),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard(
      {required this.child, this.padding = const EdgeInsets.all(12)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 58),
      padding: padding,
      decoration: BoxDecoration(
        color: _panel2.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: child,
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, this.icon, this.compact = false});

  final String label;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_purple, _blue]),
        borderRadius: BorderRadius.circular(compact ? 10 : 14),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.2),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(compact ? 10 : 14),
          onTap: () {},
          child: Container(
            height: compact ? 34 : 46,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 17),
                  const SizedBox(width: 7),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 13 : 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreditAmount extends StatelessWidget {
  const _CreditAmount();

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      alignment: Alignment.centerLeft,
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          GradientText(
            '1,250',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          SizedBox(width: 8),
          Text('credits', style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5E18C7), Color(0xFF06305B)],
        ),
      ),
      child: _GradientIcon(icon, size: size * 0.42),
    );
  }
}

class _SaleThumb extends StatelessWidget {
  const _SaleThumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        gradient: const LinearGradient(
            colors: [Color(0xFF4010A6), Color(0xFF8F1BFF)]),
      ),
      child: const Text(
        '6.6\nFLASH SALE',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          height: 1.05,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CreditLine extends StatelessWidget {
  const _CreditLine(
      {required this.icon, required this.text, this.accent = false});

  final IconData icon;
  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _muted, size: 15),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: accent ? Colors.cyanAccent : _muted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _muted, size: 13),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _muted, fontSize: 11),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: color, fontSize: 10.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _GradientIcon extends StatelessWidget {
  const _GradientIcon(this.icon, {required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [_purple, _blue],
      ).createShader(bounds),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [_purple, _blue],
      ).createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}

class _ProjectInfo {
  const _ProjectInfo({
    required this.title,
    required this.status,
    required this.date,
    required this.duration,
    required this.icon,
    required this.statusColor,
  });

  final String title;
  final String status;
  final String date;
  final String duration;
  final IconData icon;
  final Color statusColor;
}

class _TemplateInfo {
  const _TemplateInfo({
    required this.title,
    required this.category,
    required this.badge,
    required this.duration,
    required this.icon,
  });

  final String title;
  final String category;
  final String badge;
  final String duration;
  final IconData icon;
}

class _HomeAction {
  const _HomeAction(this.icon, this.label);

  final IconData icon;
  final String label;
}
