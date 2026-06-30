import 'package:flutter/material.dart';

const projectBlue = Color(0xFF0996FF);
const projectPurple = Color(0xFFB735FF);
const projectPanel = Color(0xFF081027);
const projectMuted = Color(0xFFA9A6B6);

class ProjectSearchField extends StatelessWidget {
  const ProjectSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: projectPurple.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: Colors.white.withValues(alpha: 0.72),
            size: 23,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tìm kiếm dự án...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.56),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectFilters extends StatelessWidget {
  const ProjectFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final available = constraints.maxWidth;
        final chipWidth = (available - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            SizedBox(
              width: chipWidth,
              child: const _FilterChip(
                icon: Icons.tune_rounded,
                label: 'Trạng thái',
              ),
            ),
            SizedBox(
              width: chipWidth,
              child: const _FilterChip(
                icon: Icons.calendar_today_outlined,
                label: 'Ngày',
              ),
            ),
            SizedBox(
              width: chipWidth,
              child: const _FilterChip(
                icon: Icons.folder_outlined,
                label: 'Loại',
              ),
            ),
            SizedBox(width: chipWidth, child: const _ViewToggle()),
          ],
        );
      },
    );
  }
}

class ProjectList extends StatelessWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    const projects = [
      ProjectItem(
        'Serum Glow Launch',
        'Video Marketing',
        ProjectStatus.draft,
        '00:25',
        '9:16',
        '28/05/2025',
        Icons.water_drop_outlined,
      ),
      ProjectItem(
        'Flash Sale 6.6',
        'Quảng cáo',
        ProjectStatus.rendering,
        '00:32',
        '9:16',
        '26/05/2025',
        Icons.local_offer_outlined,
      ),
      ProjectItem(
        'Review Son Mới',
        'Review Sản phẩm',
        ProjectStatus.done,
        '00:28',
        '1:1',
        '24/05/2025',
        Icons.face_retouching_natural_outlined,
      ),
      ProjectItem(
        'Fashion Sale',
        'Quảng cáo',
        ProjectStatus.error,
        '00:30',
        '1:1',
        '22/05/2025',
        Icons.checkroom_outlined,
      ),
      ProjectItem(
        'Tai Nghe X10',
        'Video Marketing',
        ProjectStatus.done,
        '00:20',
        '16:9',
        '22/05/2025',
        Icons.headphones_rounded,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < projects.length; i++) ...[
          ProjectCard(item: projects[i]),
          if (i != projects.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.item, super.key});

  final ProjectItem item;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final thumbWidth = compact ? 84.0 : 96.0;
        final thumbHeight = compact ? 92.0 : 104.0;
        final titleSize = compact ? 14.5 : 16.0;
        final metaSize = compact ? 10.8 : 11.5;

        return Container(
          padding: EdgeInsets.all(compact ? 9 : 10),
          decoration: BoxDecoration(
            color: projectPanel.withValues(alpha: 0.76),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProjectThumb(
                item: item,
                width: thumbWidth,
                height: thumbHeight,
                compact: compact,
              ),
              SizedBox(width: compact ? 10 : 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSize,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        _ProjectMoreMenu(compact: compact),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.folder_outlined,
                          color: projectMuted,
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: projectMuted,
                              fontSize: 12,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _StatusPill(status: item.status, compact: compact),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: compact ? 7 : 10,
                      runSpacing: 5,
                      children: [
                        _Meta(
                          icon: Icons.schedule_rounded,
                          text: item.duration,
                          fontSize: metaSize,
                        ),
                        _Meta(
                          icon: Icons.aspect_ratio_rounded,
                          text: item.ratio,
                          fontSize: metaSize,
                        ),
                        _Meta(
                          icon: Icons.calendar_today_outlined,
                          text: item.date,
                          fontSize: metaSize,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProjectItem {
  const ProjectItem(
    this.title,
    this.category,
    this.status,
    this.duration,
    this.ratio,
    this.date,
    this.icon,
  );

  final String title;
  final String category;
  final ProjectStatus status;
  final String duration;
  final String ratio;
  final String date;
  final IconData icon;
}

enum ProjectStatus { draft, rendering, done, error }

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withValues(alpha: 0.82),
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Icon(
              Icons.grid_view_rounded,
              color: Colors.white.withValues(alpha: 0.72),
              size: 20,
            ),
          ),
          Expanded(
            child: Container(
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: projectPurple),
                boxShadow: [
                  BoxShadow(
                    color: projectPurple.withValues(alpha: 0.35),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: const Icon(
                Icons.view_list_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectThumb extends StatelessWidget {
  const _ProjectThumb({
    required this.item,
    required this.width,
    required this.height,
    required this.compact,
  });

  final ProjectItem item;
  final double width;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            gradient: _thumbGradient(item.status),
          ),
          child: Icon(
            item.icon,
            color: Colors.white.withValues(alpha: 0.9),
            size: compact ? 32 : 38,
          ),
        ),
        Positioned(
          left: 7,
          bottom: 7,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.duration,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 11 : 12,
                height: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  LinearGradient _thumbGradient(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.rendering:
        return const LinearGradient(
          colors: [Color(0xFF4010A6), Color(0xFF9D20FF)],
        );
      case ProjectStatus.done:
        return const LinearGradient(
          colors: [Color(0xFF6F2FE8), Color(0xFF0A506E)],
        );
      case ProjectStatus.error:
        return const LinearGradient(
          colors: [Color(0xFFB07451), Color(0xFF402456)],
        );
      case ProjectStatus.draft:
        return const LinearGradient(
          colors: [Color(0xFF4815AF), Color(0xFF061D49)],
        );
    }
  }
}

class _ProjectMoreMenu extends StatelessWidget {
  const _ProjectMoreMenu({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Tùy chọn',
      padding: EdgeInsets.zero,
      iconSize: compact ? 19 : 21,
      offset: const Offset(-8, 30),
      color: const Color(0xFF11152E),
      surfaceTintColor: Colors.transparent,
      constraints: const BoxConstraints(minWidth: 178),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: projectPurple.withValues(alpha: 0.45)),
      ),
      icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'open',
          child: _ProjectMenuItem(icon: Icons.open_in_new_rounded, label: 'Mở'),
        ),
        PopupMenuItem(
          value: 'rename',
          child: _ProjectMenuItem(icon: Icons.edit_outlined, label: 'Đổi tên'),
        ),
        PopupMenuItem(
          value: 'duplicate',
          child: _ProjectMenuItem(icon: Icons.copy_rounded, label: 'Duplicate'),
        ),
        PopupMenuItem(
          value: 'folder',
          child: _ProjectMenuItem(
            icon: Icons.folder_outlined,
            label: 'Đưa vào folder',
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 'archive',
          child:
              _ProjectMenuItem(icon: Icons.archive_outlined, label: 'Archive'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: _ProjectMenuItem(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            danger: true,
          ),
        ),
      ],
    );
  }
}

class _ProjectMenuItem extends StatelessWidget {
  const _ProjectMenuItem({
    required this.icon,
    required this.label,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFFF5656) : Colors.white;
    return Row(
      children: [
        Icon(icon, color: color, size: 19),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.compact});

  final ProjectStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final config = switch (status) {
      ProjectStatus.draft => (
          label: 'Draft',
          color: const Color(0xFF4F93FF),
          icon: Icons.circle,
        ),
      ProjectStatus.rendering => (
          label: 'Rendering',
          color: const Color(0xFFDD59FF),
          icon: Icons.play_arrow_rounded,
        ),
      ProjectStatus.done => (
          label: 'Done',
          color: const Color(0xFF40D863),
          icon: Icons.circle,
        ),
      ProjectStatus.error => (
          label: 'Lỗi render',
          color: const Color(0xFFFF5656),
          icon: Icons.warning_amber_rounded,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 8,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 11, color: config.color),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: compact ? 11 : 12,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({
    required this.icon,
    required this.text,
    required this.fontSize,
  });

  final IconData icon;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: projectMuted, size: 13),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: projectMuted,
            fontSize: fontSize,
            height: 1,
          ),
        ),
      ],
    );
  }
}
