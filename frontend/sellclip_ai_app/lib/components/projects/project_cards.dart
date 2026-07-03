import 'package:flutter/material.dart';

const projectBlue = Color(0xFF0996FF);
const projectPurple = Color(0xFFB735FF);
const projectPanel = Color(0xFF081027);
const projectMuted = Color(0xFFA9A6B6);

typedef ProjectActionCallback = void Function(ProjectItem item);

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
          Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.72), size: 23),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'T\u00ecm ki\u1ebfm d\u1ef1 \u00e1n...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.56), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectFilters extends StatelessWidget {
  const ProjectFilters({
    super.key,
    this.folders = const [],
    this.selectedFolder,
    this.onFolderSelected,
  });

  final List<ProjectFolderItem> folders;
  final String? selectedFolder;
  final ValueChanged<String?>? onFolderSelected;

  @override
  Widget build(BuildContext context) {
    final folderLabel = selectedFolder ?? 'Tất cả folder';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showFilterSheet(context),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: projectPanel.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.34)),
          ),
          child: Row(
            children: [
              const Icon(Icons.tune_rounded, color: Colors.white, size: 21),
              const SizedBox(width: 10),
              const Text(
                'Bộ lọc',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Trạng thái - Ngày - $folderLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.62), fontSize: 12.2, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.82), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.62,
          minChildSize: 0.36,
          maxChildSize: 0.86,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A082B),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: projectPurple.withValues(alpha: 0.45)),
                boxShadow: [BoxShadow(color: projectPurple.withValues(alpha: 0.2), blurRadius: 28, offset: const Offset(0, -8))],
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.24), borderRadius: BorderRadius.circular(99)),
                    ),
                  ),
                  const Text(
                    'Bộ lọc project',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  const _FilterGroup(
                    icon: Icons.tune_rounded,
                    title: 'Trạng thái',
                    options: ['Tất cả', 'Draft', 'Rendering', 'Done', 'Lỗi render', 'Archive'],
                  ),
                  const SizedBox(height: 14),
                  const _FilterGroup(
                    icon: Icons.calendar_today_outlined,
                    title: 'Ngày',
                    options: ['Mới nhất', 'Hôm nay', '7 ngày', '30 ngày'],
                  ),
                  const SizedBox(height: 14),
                  _FolderFilterGroup(
                    folders: folders,
                    selectedFolder: selectedFolder,
                    onSelected: (folder) {
                      Navigator.pop(sheetContext);
                      onFolderSelected?.call(folder);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            onFolderSelected?.call(null);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text('Xóa loc'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [projectPurple, projectBlue]),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            style: TextButton.styleFrom(foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13)),
                            child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
class _FilterGroup extends StatelessWidget {
  const _FilterGroup({required this.icon, required this.title, required this.options});

  final IconData icon;
  final String title;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: projectBlue, size: 18),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < options.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: BoxDecoration(
                  color: i == 0 ? projectBlue.withValues(alpha: 0.18) : projectPanel.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: i == 0 ? projectBlue : Colors.white.withValues(alpha: 0.12)),
                ),
                child: Text(
                  options[i],
                  style: TextStyle(
                    color: i == 0 ? Colors.white : projectMuted,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
class _FolderFilterGroup extends StatelessWidget {
  const _FolderFilterGroup({
    required this.folders,
    required this.selectedFolder,
    required this.onSelected,
  });

  final List<ProjectFolderItem> folders;
  final String? selectedFolder;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final folderOptions = folders.isEmpty ? const <ProjectFolderItem>[] : folders;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.folder_outlined, color: projectBlue, size: 18),
            SizedBox(width: 8),
            Text('Folder', style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FolderFilterChip(
              label: 'Tất cả folder',
              count: null,
              selected: selectedFolder == null,
              onTap: () => onSelected(null),
            ),
            for (final folder in folderOptions)
              _FolderFilterChip(
                label: folder.name,
                count: folder.projectCount,
                selected: selectedFolder == folder.name,
                onTap: () => onSelected(folder.name),
              ),
          ],
        ),
      ],
    );
  }
}

class _FolderFilterChip extends StatelessWidget {
  const _FolderFilterChip({required this.label, required this.selected, required this.onTap, this.count});

  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            gradient: selected ? const LinearGradient(colors: [projectPurple, projectBlue]) : null,
            color: selected ? null : projectPanel.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? Colors.transparent : Colors.white.withValues(alpha: 0.12)),
          ),
          child: Text(
            count == null ? label : '$label ($count)',
            style: TextStyle(color: selected ? Colors.white : projectMuted, fontSize: 12.5, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
class ProjectList extends StatelessWidget {
  const ProjectList({
    super.key,
    required this.projects,
    required this.onOpen,
    required this.onRename,
    required this.onDuplicate,
    required this.onMoveToFolder,
    required this.onArchive,
    required this.onDelete,
  });

  final List<ProjectItem> projects;
  final ProjectActionCallback onOpen;
  final ProjectActionCallback onRename;
  final ProjectActionCallback onDuplicate;
  final ProjectActionCallback onMoveToFolder;
  final ProjectActionCallback onArchive;
  final ProjectActionCallback onDelete;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        decoration: BoxDecoration(
          color: projectPanel.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: const Column(
          children: [
            Icon(Icons.folder_open_rounded, color: projectMuted, size: 38),
            SizedBox(height: 10),
            Text(
              'Ch\u01b0a c\u00f3 project n\u00e0o',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 5),
            Text(
              'B\u1ea5m T\u1ea1o project \u0111\u1ec3 th\u00eam d\u1ef1 \u00e1n m\u1edbi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: projectMuted, fontSize: 12.5),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < projects.length; i++) ...[
          ProjectCard(
            item: projects[i],
            onOpen: onOpen,
            onRename: onRename,
            onDuplicate: onDuplicate,
            onMoveToFolder: onMoveToFolder,
            onArchive: onArchive,
            onDelete: onDelete,
          ),
          if (i != projects.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.item,
    required this.onOpen,
    required this.onRename,
    required this.onDuplicate,
    required this.onMoveToFolder,
    required this.onArchive,
    required this.onDelete,
    super.key,
  });

  final ProjectItem item;
  final ProjectActionCallback onOpen;
  final ProjectActionCallback onRename;
  final ProjectActionCallback onDuplicate;
  final ProjectActionCallback onMoveToFolder;
  final ProjectActionCallback onArchive;
  final ProjectActionCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final thumbWidth = compact ? 84.0 : 96.0;
        final thumbHeight = compact ? 92.0 : 104.0;
        final titleSize = compact ? 14.5 : 16.0;
        final metaSize = compact ? 10.8 : 11.5;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onOpen(item),
            child: Container(
              padding: EdgeInsets.all(compact ? 9 : 10),
              decoration: BoxDecoration(
                color: projectPanel.withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProjectThumb(item: item, width: thumbWidth, height: thumbHeight, compact: compact),
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
                            style: TextStyle(color: Colors.white, fontSize: titleSize, height: 1.12, fontWeight: FontWeight.w800),
                          ),
                        ),
                        _ProjectMoreMenu(
                          compact: compact,
                          item: item,
                          onOpen: onOpen,
                          onRename: onRename,
                          onDuplicate: onDuplicate,
                          onMoveToFolder: onMoveToFolder,
                          onArchive: onArchive,
                          onDelete: onDelete,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.folder_outlined, color: projectMuted, size: 13),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.folderName == null || item.folderName!.isEmpty ? item.category : '${item.category} / ${item.folderName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: projectMuted, fontSize: 12, height: 1.15),
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
                        _Meta(icon: Icons.schedule_rounded, text: item.duration, fontSize: metaSize),
                        _Meta(icon: Icons.aspect_ratio_rounded, text: item.ratio, fontSize: metaSize),
                        _Meta(icon: Icons.calendar_today_outlined, text: item.date, fontSize: metaSize),
                      ],
                    ),
                  ],
                ),
              ),
            ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProjectItem {
  const ProjectItem({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.duration,
    required this.ratio,
    required this.date,
    required this.icon,
    this.folderName,
  });

  final int id;
  final String title;
  final String category;
  final ProjectStatus status;
  final String duration;
  final String ratio;
  final String date;
  final IconData icon;
  final String? folderName;
}

enum ProjectStatus { draft, rendering, done, error, archived }

class _ProjectThumb extends StatelessWidget {
  const _ProjectThumb({required this.item, required this.width, required this.height, required this.compact});

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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), gradient: _thumbGradient(item.status)),
          child: Icon(item.icon, color: Colors.white.withValues(alpha: 0.9), size: compact ? 32 : 38),
        ),
        Positioned(
          left: 7,
          bottom: 7,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.72), borderRadius: BorderRadius.circular(6)),
            child: Text(item.duration, style: TextStyle(color: Colors.white, fontSize: compact ? 11 : 12, height: 1, fontWeight: FontWeight.w800)),
          ),
        ),
      ],
    );
  }

  LinearGradient _thumbGradient(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.rendering:
        return const LinearGradient(colors: [Color(0xFF4010A6), Color(0xFF9D20FF)]);
      case ProjectStatus.done:
        return const LinearGradient(colors: [Color(0xFF6F2FE8), Color(0xFF0A506E)]);
      case ProjectStatus.error:
        return const LinearGradient(colors: [Color(0xFFB07451), Color(0xFF402456)]);
      case ProjectStatus.archived:
        return const LinearGradient(colors: [Color(0xFF2E3357), Color(0xFF11182E)]);
      case ProjectStatus.draft:
        return const LinearGradient(colors: [Color(0xFF4815AF), Color(0xFF061D49)]);
    }
  }
}

class _ProjectMoreMenu extends StatelessWidget {
  const _ProjectMoreMenu({
    required this.compact,
    required this.item,
    required this.onOpen,
    required this.onRename,
    required this.onDuplicate,
    required this.onMoveToFolder,
    required this.onArchive,
    required this.onDelete,
  });

  final bool compact;
  final ProjectItem item;
  final ProjectActionCallback onOpen;
  final ProjectActionCallback onRename;
  final ProjectActionCallback onDuplicate;
  final ProjectActionCallback onMoveToFolder;
  final ProjectActionCallback onArchive;
  final ProjectActionCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        tooltip: 'T\u00f9y ch\u1ecdn',
        padding: EdgeInsets.zero,
        iconSize: compact ? 22 : 24,
        splashRadius: 22,
        onPressed: () => _showActions(context),
        icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            decoration: BoxDecoration(
              color: const Color(0xFF11152E),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: projectPurple.withValues(alpha: 0.45)),
              boxShadow: [
                BoxShadow(
                  color: projectPurple.withValues(alpha: 0.22),
                  blurRadius: 28,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _ProjectActionTile(icon: Icons.open_in_new_rounded, label: 'M\u1edf', onTap: () => _run(sheetContext, onOpen)),
                _ProjectActionTile(icon: Icons.edit_outlined, label: '\u0110\u1ed5i t\u00ean', onTap: () => _run(sheetContext, onRename)),
                _ProjectActionTile(icon: Icons.copy_rounded, label: 'Nhân bản', onTap: () => _run(sheetContext, onDuplicate)),
                _ProjectActionTile(icon: Icons.folder_outlined, label: '\u0110\u01b0a v\u00e0o folder', onTap: () => _run(sheetContext, onMoveToFolder)),
                Divider(color: Colors.white.withValues(alpha: 0.12), height: 18),
                _ProjectActionTile(icon: Icons.archive_outlined, label: 'Archive', onTap: () => _run(sheetContext, onArchive)),
                _ProjectActionTile(icon: Icons.delete_outline_rounded, label: 'Delete', danger: true, onTap: () => _run(sheetContext, onDelete)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _run(BuildContext sheetContext, ProjectActionCallback callback) {
    Navigator.of(sheetContext).pop();
    Future<void>.delayed(const Duration(milliseconds: 120), () => callback(item));
  }
}

class _ProjectActionTile extends StatelessWidget {
  const _ProjectActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFFF5656) : Colors.white;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: color, size: 21),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
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
      ProjectStatus.draft => (label: 'Draft', color: const Color(0xFF4F93FF), icon: Icons.circle),
      ProjectStatus.rendering => (label: 'Rendering', color: const Color(0xFFDD59FF), icon: Icons.play_arrow_rounded),
      ProjectStatus.done => (label: 'Done', color: const Color(0xFF40D863), icon: Icons.circle),
      ProjectStatus.error => (label: 'L\u1ed7i render', color: const Color(0xFFFF5656), icon: Icons.warning_amber_rounded),
      ProjectStatus.archived => (label: 'Archived', color: const Color(0xFFB0AEC4), icon: Icons.archive_rounded),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 8, vertical: compact ? 3 : 4),
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
          Text(config.label, style: TextStyle(color: config.color, fontSize: compact ? 11 : 12, height: 1, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text, required this.fontSize});

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
        Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: projectMuted, fontSize: fontSize, height: 1)),
      ],
    );
  }
}


class ProjectFolderBar extends StatelessWidget {
  const ProjectFolderBar({
    super.key,
    required this.folders,
    required this.selectedFolder,
    required this.onSelected,
  });

  final List<ProjectFolderItem> folders;
  final String? selectedFolder;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: projectPanel.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: const Row(
          children: [
            Icon(Icons.folder_off_outlined, color: projectMuted, size: 20),
            SizedBox(width: 9),
            Expanded(
              child: Text(
                'Chưa có folder nào',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: projectMuted, fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.folder_rounded, color: projectBlue, size: 18),
            const SizedBox(width: 7),
            const Expanded(
              child: Text(
                'Folder đã lưu',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
              ),
            ),
            if (selectedFolder != null)
              TextButton(
                onPressed: () => onSelected(null),
                child: const Text('Tất cả'),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 74,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: folders.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index == 0) {
                final selected = selectedFolder == null;
                final count = folders.fold<int>(0, (total, folder) => total + folder.projectCount);
                return _FolderChipCard(
                  name: 'Tất cả',
                  count: count,
                  selected: selected,
                  onTap: () => onSelected(null),
                );
              }
              final folder = folders[index - 1];
              final selected = selectedFolder == folder.name;
              return _FolderChipCard(
                name: folder.name,
                count: folder.projectCount,
                selected: selected,
                onTap: () => onSelected(folder.name),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProjectFolderItem {
  const ProjectFolderItem({required this.name, required this.projectCount});

  final String name;
  final int projectCount;
}

class _FolderChipCard extends StatelessWidget {
  const _FolderChipCard({
    required this.name,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 138,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? projectBlue.withValues(alpha: 0.16) : projectPanel.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: selected ? projectBlue : Colors.white.withValues(alpha: 0.12)),
            boxShadow: selected
                ? [BoxShadow(color: projectBlue.withValues(alpha: 0.22), blurRadius: 18, offset: const Offset(0, 8))]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [projectPurple, projectBlue]),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.folder_rounded, color: Colors.white, size: 21),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$count project',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: projectMuted, fontSize: 11.2, fontWeight: FontWeight.w600),
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
