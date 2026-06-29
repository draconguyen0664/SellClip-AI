import 'package:flutter/material.dart';

const projectBlue = Color(0xFF0996FF);
const projectPurple = Color(0xFFB735FF);
const projectPanel = Color(0xFF081027);
const projectPanel2 = Color(0xFF101631);
const projectMuted = Color(0xFFA9A6B6);

class ProjectSearchField extends StatelessWidget {
  const ProjectSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: projectPurple.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded,
              color: Colors.white.withValues(alpha: 0.74), size: 27),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tìm kiếm dự án...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 16,
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
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          _FilterChip(icon: Icons.tune_rounded, label: 'Trạng thái'),
          SizedBox(width: 10),
          _FilterChip(icon: Icons.calendar_today_outlined, label: 'Ngày'),
          SizedBox(width: 10),
          _FilterChip(icon: Icons.folder_outlined, label: 'Loại'),
          SizedBox(width: 10),
          _ViewToggle(),
        ],
      ),
    );
  }
}

class ProjectList extends StatelessWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    const projects = [
      ProjectItem(
        title: 'Serum Glow Launch',
        category: 'Video Marketing',
        status: ProjectStatus.draft,
        duration: '00:25',
        ratio: '9:16',
        date: '28/05/2025',
        icon: Icons.water_drop_outlined,
      ),
      ProjectItem(
        title: 'Flash Sale 6.6',
        category: 'Quảng cáo',
        status: ProjectStatus.rendering,
        duration: '00:32',
        ratio: '9:16',
        date: '26/05/2025',
        icon: Icons.local_offer_outlined,
      ),
      ProjectItem(
        title: 'Review Son Mới',
        category: 'Review Sản phẩm',
        status: ProjectStatus.done,
        duration: '00:28',
        ratio: '1:1',
        date: '24/05/2025',
        icon: Icons.face_retouching_natural_outlined,
      ),
      ProjectItem(
        title: 'Fashion Sale',
        category: 'Quảng cáo',
        status: ProjectStatus.error,
        duration: '00:30',
        ratio: '1:1',
        date: '22/05/2025',
        icon: Icons.checkroom_outlined,
      ),
      ProjectItem(
        title: 'Tai Nghe X10',
        category: 'Video Marketing',
        status: ProjectStatus.done,
        duration: '00:20',
        ratio: '16:9',
        date: '22/05/2025',
        icon: Icons.headphones_rounded,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < projects.length; i++) ...[
          ProjectCard(item: projects[i], showOpenMenu: i == 1),
          if (i != projects.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.item, this.showOpenMenu = false, super.key});

  final ProjectItem item;
  final bool showOpenMenu;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: projectPanel.withValues(alpha: 0.74),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProjectThumb(item: item),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 116,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.more_horiz_rounded,
                              color: Colors.white, size: 24),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(Icons.folder_outlined,
                              color: projectMuted, size: 17),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: projectMuted, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _StatusPill(status: item.status),
                      const Spacer(),
                      Wrap(
                        spacing: 18,
                        runSpacing: 5,
                        children: [
                          _Meta(
                              icon: Icons.schedule_rounded,
                              text: item.duration),
                          _Meta(
                              icon: Icons.aspect_ratio_rounded,
                              text: item.ratio),
                          _Meta(
                              icon: Icons.calendar_today_outlined,
                              text: item.date),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showOpenMenu)
          const Positioned(
            right: -4,
            top: 94,
            child: _ProjectContextMenu(),
          ),
      ],
    );
  }
}

class ProjectItem {
  const ProjectItem({
    required this.title,
    required this.category,
    required this.status,
    required this.duration,
    required this.ratio,
    required this.date,
    required this.icon,
  });

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
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 21),
          const SizedBox(width: 9),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white.withValues(alpha: 0.8), size: 22),
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
      height: 48,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_view_rounded,
              color: Colors.white.withValues(alpha: 0.72), size: 25),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: projectPurple),
              boxShadow: [
                BoxShadow(
                    color: projectPurple.withValues(alpha: 0.38),
                    blurRadius: 16),
              ],
            ),
            child: const Icon(Icons.view_list_rounded,
                color: Colors.white, size: 27),
          ),
        ],
      ),
    );
  }
}

class _ProjectThumb extends StatelessWidget {
  const _ProjectThumb({required this.item});

  final ProjectItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 108,
          height: 116,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            gradient: _thumbGradient(item.status),
          ),
          child: Icon(item.icon,
              color: Colors.white.withValues(alpha: 0.9), size: 44),
        ),
        Positioned(
          left: 7,
          bottom: 7,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.duration,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
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
            colors: [Color(0xFF4010A6), Color(0xFF9D20FF)]);
      case ProjectStatus.done:
        return const LinearGradient(
            colors: [Color(0xFF6F2FE8), Color(0xFF0A506E)]);
      case ProjectStatus.error:
        return const LinearGradient(
            colors: [Color(0xFFB07451), Color(0xFF402456)]);
      case ProjectStatus.draft:
        return const LinearGradient(
            colors: [Color(0xFF4815AF), Color(0xFF061D49)]);
    }
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final config = switch (status) {
      ProjectStatus.draft => (
          label: 'Draft',
          color: const Color(0xFF4F93FF),
          icon: Icons.circle
        ),
      ProjectStatus.rendering => (
          label: 'Rendering',
          color: const Color(0xFFDD59FF),
          icon: Icons.play_arrow_rounded
        ),
      ProjectStatus.done => (
          label: 'Done',
          color: const Color(0xFF40D863),
          icon: Icons.circle
        ),
      ProjectStatus.error => (
          label: 'Lỗi render',
          color: const Color(0xFFFF5656),
          icon: Icons.warning_amber_rounded
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 13, color: config.color),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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
        Icon(icon, color: projectMuted, size: 17),
        const SizedBox(width: 6),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: projectMuted, fontSize: 13),
        ),
      ],
    );
  }
}

class _ProjectContextMenu extends StatelessWidget {
  const _ProjectContextMenu();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF11152E).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: projectPurple.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MenuAction(icon: Icons.open_in_new_rounded, label: 'Mở'),
          _MenuAction(icon: Icons.edit_outlined, label: 'Đổi tên'),
          _MenuAction(icon: Icons.copy_rounded, label: 'Duplicate'),
          _MenuAction(icon: Icons.folder_outlined, label: 'Đưa vào folder'),
          Divider(color: Color(0x335D6078), height: 16),
          _MenuAction(icon: Icons.archive_outlined, label: 'Archive'),
          _MenuAction(
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              danger: true),
        ],
      ),
    );
  }
}

class _MenuAction extends StatelessWidget {
  const _MenuAction(
      {required this.icon, required this.label, this.danger = false});

  final IconData icon;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFFF5656) : Colors.white;
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
