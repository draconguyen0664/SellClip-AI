import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/projects/project_cards.dart';
import 'package:sellclip_ai_app/screens/create_project_screen.dart';
import 'package:sellclip_ai_app/screens/project_detail_screen.dart';
import 'package:sellclip_ai_app/services/project_api.dart';

class ProjectsScreenBody extends StatefulWidget {
  const ProjectsScreenBody({super.key});

  @override
  State<ProjectsScreenBody> createState() => _ProjectsScreenBodyState();
}

class _ProjectsScreenBodyState extends State<ProjectsScreenBody> {
  final _api = ProjectApi();
  List<ProjectItem> _allProjects = const [];
  List<ProjectFolderItem> _folders = const [];
  String? _selectedFolder;
  bool _loading = true;
  bool _busy = false;
  String _message = '';

  List<ProjectItem> get _visibleProjects {
    final folder = _selectedFolder;
    if (folder == null) return _allProjects;
    return _allProjects.where((project) => project.folderName == folder).toList();
  }

  List<ProjectFolderItem> get _effectiveFolders {
    final byName = <String, int>{};
    for (final folder in _folders) {
      final name = folder.name.trim();
      if (name.isEmpty) continue;
      byName[name] = folder.projectCount;
    }
    for (final folder in _foldersFromProjects(_allProjects)) {
      byName[folder.name] = byName[folder.name] ?? folder.projectCount;
    }
    return byName.entries
        .map((entry) => ProjectFolderItem(name: entry.key, projectCount: entry.value))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _loading = true;
      _message = '';
    });
    final responses = await Future.wait([
      _api.listProjects(ownerId: 1),
      _api.listFolders(ownerId: 1),
    ]);
    final projectResponse = responses[0] as ProjectListResponse;
    final folderResponse = responses[1] as ProjectFolderListResponse;
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (projectResponse.ok) {
        _allProjects = projectResponse.projects.map(_projectItemFromSummary).toList();
      } else {
        _message = projectResponse.message;
      }
      final foldersFromProjects = _foldersFromProjects(_allProjects);
      if (folderResponse.ok && folderResponse.folders.isNotEmpty) {
        _folders = folderResponse.folders
            .where((folder) => folder.name.trim().isNotEmpty)
            .map((folder) => ProjectFolderItem(name: folder.name, projectCount: folder.projectCount))
            .toList();
      } else {
        _folders = foldersFromProjects;
      }
      if (_selectedFolder != null && !_folders.any((folder) => folder.name == _selectedFolder)) {
        _selectedFolder = null;
      }
      if (!folderResponse.ok && _message.isEmpty && foldersFromProjects.isEmpty) {
        _message = folderResponse.message;
      }
    });
  }


  List<ProjectFolderItem> _foldersFromProjects(List<ProjectItem> projects) {
    final counts = <String, int>{};
    for (final project in projects) {
      final name = project.folderName?.trim();
      if (name == null || name.isEmpty) continue;
      counts[name] = (counts[name] ?? 0) + 1;
    }
    return counts.entries
        .map((entry) => ProjectFolderItem(name: entry.key, projectCount: entry.value))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
  Future<void> _openCreateProject() async {
    final result = await Navigator.of(context).push<ProjectSummary?>(
      MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
    );
    if (!mounted || result == null) return;
    _showSnack('Tạo project thanh cong');
    await _loadProjects();
  }

  ProjectItem _projectItemFromSummary(ProjectSummary project) {
    return ProjectItem(
      id: project.id,
      title: project.name,
      category: _categoryFromType(project.type),
      status: _statusFromApi(project.status),
      duration: '00:00',
      ratio: project.aspectRatioLabel,
      date: _formatDate(project.createdAt),
      icon: _iconFromType(project.type),
      folderName: project.folderName,
    );
  }

  Future<void> _openProject(ProjectItem item) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: item)),
    );
    if (changed == true && mounted) {
      await _loadProjects();
    }
  }

  Future<void> _renameProject(ProjectItem item) async {
    final name = await _showTextDialog(
      title: 'Đổi tên project',
      label: 'Tên project',
      initialValue: item.title,
      actionLabel: 'Lưu',
    );
    if (name == null || name.trim().isEmpty || name.trim() == item.title) return;
    await _runAction(
      () => _api.renameProject(ownerId: 1, projectId: item.id, name: name.trim()),
      reload: true,
    );
  }

  Future<void> _duplicateProject(ProjectItem item) async {
    await _runAction(
      () => _api.duplicateProject(ownerId: 1, projectId: item.id),
      reload: true,
    );
  }

  Future<void> _moveProjectToFolder(ProjectItem item) async {
    final folderName = await _showTextDialog(
      title: 'Đưa vào folder',
      label: 'Ten folder',
      initialValue: item.folderName ?? '',
      hintText: 'Để trống nếu muốn bỏ khỏi folder',
      actionLabel: 'Lưu',
    );
    if (folderName == null) return;
    await _runAction(
      () => _api.moveProjectToFolder(ownerId: 1, projectId: item.id, folderName: folderName.trim()),
      reload: true,
    );
    if (folderName.trim().isNotEmpty && mounted) {
      setState(() => _selectedFolder = folderName.trim());
    }
  }

  Future<void> _archiveProject(ProjectItem item) async {
    await _runAction(
      () => _api.archiveProject(ownerId: 1, projectId: item.id),
      reload: true,
    );
  }

  Future<void> _deleteProject(ProjectItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF09072A),
        title: const Text('Xóa project?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Text(
          'Project "${item.title}" sẽ bị ẩn khỏi danh sách.',
          style: const TextStyle(color: projectMuted),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Color(0xFFFF5656))),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _runAction(
      () => _api.deleteProject(ownerId: 1, projectId: item.id),
      reload: true,
    );
  }

  Future<void> _runAction(
    Future<ProjectApiResponse> Function() action, {
    bool reload = false,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    final result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    _showSnack(result.message, isError: !result.ok);
    if (result.ok && reload) {
      await _loadProjects();
    }
  }

  Future<String?> _showTextDialog({
    required String title,
    required String label,
    required String initialValue,
    required String actionLabel,
    String? hintText,
  }) async {
    final controller = TextEditingController(text: initialValue);
    try {
      return await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color(0xFF09072A),
          title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              hintText: hintText,
              labelStyle: const TextStyle(color: projectMuted),
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.36)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: projectBlue),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Hủy')),
            TextButton(onPressed: () => Navigator.pop(dialogContext, controller.text), child: Text(actionLabel)),
          ],
        ),
      );
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFF9B1830) : const Color(0xFF102545),
      ),
    );
  }

  String _categoryFromType(String type) {
    return switch (type) {
      'IMAGE_TO_VIDEO' => 'Video Marketing',
      'RAW_VIDEO_EDITOR' => 'Chỉnh sửa video',
      'POSTER' => 'Poster',
      'IMAGE_EDITOR' => 'Image Editor',
      'AI_CONTENT' => 'AI Content',
      _ => 'Video Marketing',
    };
  }

  IconData _iconFromType(String type) {
    return switch (type) {
      'RAW_VIDEO_EDITOR' => Icons.movie_creation_outlined,
      'POSTER' => Icons.article_outlined,
      'IMAGE_EDITOR' => Icons.auto_fix_high_rounded,
      'AI_CONTENT' => Icons.psychology_alt_outlined,
      _ => Icons.water_drop_outlined,
    };
  }

  ProjectStatus _statusFromApi(String status) {
    return switch (status) {
      'RENDERING' => ProjectStatus.rendering,
      'DONE' => ProjectStatus.done,
      'FAILED' || 'ERROR' || 'RENDER_ERROR' => ProjectStatus.error,
      'ARCHIVED' => ProjectStatus.archived,
      _ => ProjectStatus.draft,
    };
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = (constraints.maxWidth * 0.045).clamp(14.0, 22.0);
        final visibleProjects = _visibleProjects;
        final effectiveFolders = _effectiveFolders;
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadProjects,
              color: projectBlue,
              backgroundColor: const Color(0xFF070525),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(side, 14, side, 178),
                    sliver: SliverList.list(
                      children: [
                        _ProjectsHeader(onCreate: _openCreateProject),
                        const SizedBox(height: 22),
                        const _ProjectsTitleRow(),
                        const SizedBox(height: 18),
                        const ProjectSearchField(),
                        const SizedBox(height: 16),
                        _InlineFolderSection
                          (
                          folders: effectiveFolders,
                          selectedFolder: _selectedFolder,
                          onSelected: (folder) => setState(() => _selectedFolder = folder),
                        ),
                        const SizedBox(height: 16),
                        ProjectFilters(
                          folders: effectiveFolders,
                          selectedFolder: _selectedFolder,
                          onFolderSelected: (folder) => setState(() => _selectedFolder = folder),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 18),
                        if (_loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: CircularProgressIndicator(color: Colors.white)),
                          )
                        else ...[
                          if (_message.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                _message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Color(0xFFFF6175), fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                            ),
                          if (_selectedFolder != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Folder: $_selectedFolder',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  TextButton(onPressed: () => setState(() => _selectedFolder = null), child: const Text('Bộ lọc')),
                                ],
                              ),
                            ),
                          ProjectList(
                            projects: visibleProjects,
                            onOpen: _openProject,
                            onRename: _renameProject,
                            onDuplicate: _duplicateProject,
                            onMoveToFolder: _moveProjectToFolder,
                            onArchive: _archiveProject,
                            onDelete: _deleteProject,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_busy)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.05),
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 8),
                    child: const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: projectBlue),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProjectsHeader extends StatelessWidget {
  const _ProjectsHeader({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/logo_icon.png', width: 34, height: 34, fit: BoxFit.contain, filterQuality: FilterQuality.high),
        const SizedBox(width: 9),
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
              children: [
                const TextSpan(text: 'SellClip '),
                TextSpan(
                  text: 'AI',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = const LinearGradient(colors: [projectPurple, projectBlue]).createShader(const Rect.fromLTWH(0, 0, 48, 24)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _CreateProjectButton(onPressed: onCreate),
      ],
    );
  }
}

class _ProjectsTitleRow extends StatelessWidget {
  const _ProjectsTitleRow();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Dự án',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.white, fontSize: 34, height: 1, fontWeight: FontWeight.w900),
    );
  }
}

class _CreateProjectButton extends StatelessWidget {
  const _CreateProjectButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [projectPurple, projectBlue]),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [BoxShadow(color: projectPurple.withValues(alpha: 0.3), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onPressed,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 22),
                SizedBox(width: 7),
                Text('Tạo project', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineFolderSection extends StatelessWidget {
  const _InlineFolderSection({
    required this.folders,
    required this.selectedFolder,
    required this.onSelected,
  });

  final List<ProjectFolderItem> folders;
  final String? selectedFolder;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: projectBlue.withValues(alpha: 0.42)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_rounded, color: projectBlue, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Folder đã lưu',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              if (selectedFolder != null)
                TextButton(onPressed: () => onSelected(null), child: const Text('Tất cả')),
            ],
          ),
          const SizedBox(height: 10),
          if (folders.isEmpty)
            const Row(
              children: [
                Icon(Icons.folder_off_outlined, color: projectMuted, size: 19),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Chưa có folder nào',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: projectMuted, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InlineFolderChip(
                  name: 'Tất cả',
                  count: folders.fold<int>(0, (total, folder) => total + folder.projectCount),
                  selected: selectedFolder == null,
                  onTap: () => onSelected(null),
                ),
                for (final folder in folders)
                  _InlineFolderChip(
                    name: folder.name,
                    count: folder.projectCount,
                    selected: selectedFolder == folder.name,
                    onTap: () => onSelected(folder.name),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InlineFolderChip extends StatelessWidget {
  const _InlineFolderChip({
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
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 118),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? const LinearGradient(colors: [projectPurple, projectBlue]) : null,
          color: selected ? null : const Color(0xFF11152E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Colors.transparent : Colors.white.withValues(alpha: 0.16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.folder_rounded, color: Colors.white, size: 17),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                '$name ($count)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}