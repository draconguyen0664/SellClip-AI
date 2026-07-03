import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/home/home_background.dart';
import 'package:sellclip_ai_app/components/projects/project_cards.dart';
import 'package:sellclip_ai_app/services/project_api.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final ProjectItem project;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final _api = ProjectApi();
  bool _busy = false;

  Future<void> _duplicateProject() async {
    if (_busy) return;
    setState(() => _busy = true);
    final response = await _api.duplicateProject(ownerId: 1, projectId: widget.project.id);
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: response.ok ? const Color(0xFF102545) : const Color(0xFF9B1830),
      ),
    );
    if (response.ok) {
      Navigator.of(context).pop(true);
    }
  }

  void _showRenderMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đưa project vào hàng đợi render'),
        backgroundColor: Color(0xFF102545),
      ),
    );
  }

  void _showActionMenu() {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF11152E),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: projectPurple.withValues(alpha: 0.48)),
              boxShadow: [BoxShadow(color: projectPurple.withValues(alpha: 0.24), blurRadius: 26, offset: const Offset(0, -8))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.24), borderRadius: BorderRadius.circular(99)),
                ),
                _SheetAction(icon: Icons.edit_outlined, label: 'Đổi tên', onTap: () => Navigator.pop(context)),
                _SheetAction(icon: Icons.copy_rounded, label: 'Nhân bản', onTap: _duplicateProject),
                _SheetAction(icon: Icons.play_circle_outline_rounded, label: 'Render', onTap: _showRenderMessage),
                _SheetAction(icon: Icons.archive_outlined, label: 'Archive', onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 390;
    final side = (width * 0.04).clamp(12.0, 18.0);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final actionBarReserve = (compact ? 148.0 : 166.0) + bottomInset;
    return Scaffold(
      backgroundColor: const Color(0xFF020514),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(side, compact ? 4 : 8, side, compact ? 14 : 18),
                  sliver: SliverList.list(
                    children: [
                      _DetailHeader(onBack: () => Navigator.of(context).pop(), onMenu: _showActionMenu),
                      SizedBox(height: compact ? 10 : 18),
                      _HeroPreview(project: widget.project),
                      SizedBox(height: compact ? 10 : 18),
                      Text(
                        widget.project.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: compact ? 22 : 28, height: 1.05, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: compact ? 8 : 12),
                      _DetailStatus(status: widget.project.status),
                      SizedBox(height: compact ? 10 : 16),
                      _InfoPanel(project: widget.project),
                      SizedBox(height: compact ? 10 : 16),
                      _RenderHistory(project: widget.project),
                      SizedBox(height: actionBarReserve),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: side,
            right: side,
            bottom: bottomInset + (compact ? 10 : 12),
            child: _BottomActions(
              busy: _busy,
              onEdit: () => Navigator.of(context).pop(),
              onRender: _showRenderMessage,
              onDuplicate: _duplicateProject,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.onBack, required this.onMenu});

  final VoidCallback onBack;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width < 390 ? 42 : 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: MediaQuery.sizeOf(context).width < 390 ? 23 : 28),
            ),
          ),
          const Text(
            'Chi tiết project',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onMenu,
              icon: Icon(Icons.more_vert_rounded, color: Colors.white, size: MediaQuery.sizeOf(context).width < 390 ? 25 : 30),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPreview extends StatelessWidget {
  const _HeroPreview({required this.project});

  final ProjectItem project;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: MediaQuery.sizeOf(context).width < 390 ? 16 / 6.2 : 16 / 7,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: projectPurple.withValues(alpha: 0.55)),
          gradient: _gradient(project.status),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _HeroPainter(color: _statusColor(project.status))),
            ),
            Positioned(
              left: MediaQuery.sizeOf(context).width < 390 ? 16 : 22,
              top: MediaQuery.sizeOf(context).width < 390 ? 16 : 20,
              bottom: MediaQuery.sizeOf(context).width < 390 ? 14 : 18,
              child: Icon(project.icon, color: Colors.white.withValues(alpha: 0.9), size: MediaQuery.sizeOf(context).width < 390 ? 70 : 96),
            ),
            Positioned(
              right: MediaQuery.sizeOf(context).width < 390 ? 16 : 22,
              top: MediaQuery.sizeOf(context).width < 390 ? 18 : 24,
              child: Text(
                _heroTitle(project),
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: MediaQuery.sizeOf(context).width < 390 ? 24 : 32, height: 0.95, fontWeight: FontWeight.w900),
              ),
            ),
            Positioned(
              left: MediaQuery.sizeOf(context).width < 390 ? 12 : 16,
              bottom: MediaQuery.sizeOf(context).width < 390 ? 10 : 14,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width < 390 ? 9 : 11, vertical: MediaQuery.sizeOf(context).width < 390 ? 5 : 7),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.58), borderRadius: BorderRadius.circular(9)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white, size: MediaQuery.sizeOf(context).width < 390 ? 18 : 22),
                    const SizedBox(width: 5),
                    Text(project.duration, style: TextStyle(color: Colors.white, fontSize: MediaQuery.sizeOf(context).width < 390 ? 13 : 16, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _gradient(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.done => const LinearGradient(colors: [Color(0xFF15114D), Color(0xFF0A5C70), Color(0xFF1C0A3D)]),
      ProjectStatus.rendering => const LinearGradient(colors: [Color(0xFF21083D), Color(0xFF5720D8), Color(0xFF050517)]),
      ProjectStatus.error => const LinearGradient(colors: [Color(0xFF3C1023), Color(0xFF953D44), Color(0xFF120414)]),
      ProjectStatus.archived => const LinearGradient(colors: [Color(0xFF20253C), Color(0xFF0A1024)]),
      ProjectStatus.draft => const LinearGradient(colors: [Color(0xFF14033A), Color(0xFF4014B8), Color(0xFF061E4C)]),
    };
  }

  Color _statusColor(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.done => const Color(0xFF40D863),
      ProjectStatus.rendering => projectPurple,
      ProjectStatus.error => const Color(0xFFFF5656),
      ProjectStatus.archived => const Color(0xFFB0AEC4),
      ProjectStatus.draft => projectBlue,
    };
  }

  String _heroTitle(ProjectItem project) {
    if (project.title.trim().isEmpty) return 'SELLCLIP\nPROJECT';
    final parts = project.title.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.toUpperCase();
    return '${parts.take(2).join(' ')}\n${parts.skip(2).take(2).join(' ')}'.trim().toUpperCase();
  }
}

class _HeroPainter extends CustomPainter {
  const _HeroPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(colors: [color.withValues(alpha: 0.45), Colors.transparent]).createShader(
        Rect.fromCircle(center: Offset(size.width * 0.45, size.height * 0.48), radius: size.width * 0.62),
      );
    canvas.drawCircle(Offset(size.width * 0.46, size.height * 0.52), size.width * 0.55, paint);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.1;
    for (var i = 0; i < 8; i++) {
      final y = size.height * (0.1 + i * 0.12);
      canvas.drawLine(Offset(size.width * 0.36, y), Offset(size.width, y - 36), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeroPainter oldDelegate) => oldDelegate.color != color;
}

class _DetailStatus extends StatelessWidget {
  const _DetailStatus({required this.status});

  final ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final data = switch (status) {
      ProjectStatus.draft => (label: 'Draft', color: const Color(0xFF4F93FF), icon: Icons.circle),
      ProjectStatus.rendering => (label: 'Đang render', color: const Color(0xFFDD59FF), icon: Icons.sync_rounded),
      ProjectStatus.done => (label: 'Hoàn thành', color: const Color(0xFF40D863), icon: Icons.check_circle_rounded),
      ProjectStatus.error => (label: 'Thất bại', color: const Color(0xFFFF5656), icon: Icons.error_outline_rounded),
      ProjectStatus.archived => (label: 'Archived', color: const Color(0xFFB0AEC4), icon: Icons.archive_rounded),
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width < 390 ? 10 : 13, vertical: MediaQuery.sizeOf(context).width < 390 ? 6 : 9),
        decoration: BoxDecoration(
          color: data.color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: data.color.withValues(alpha: 0.75)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(data.icon, color: data.color, size: MediaQuery.sizeOf(context).width < 390 ? 16 : 21),
            const SizedBox(width: 8),
            Text(data.label, style: TextStyle(color: data.color, fontSize: MediaQuery.sizeOf(context).width < 390 ? 13 : 16, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.project});

  final ProjectItem project;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _InfoData(Icons.calendar_today_outlined, 'Ngày tạo', project.date),
      _InfoData(Icons.edit_square, 'Chỉnh sửa gần nhất', project.date),
      _InfoData(Icons.aspect_ratio_rounded, 'Tỷ lệ khung hình', project.ratio),
      _InfoData(Icons.timer_outlined, 'Thời lượng', project.duration),
      _InfoData(Icons.bookmark_border_rounded, 'Template', project.category),
      const _InfoData(Icons.palette_outlined, 'Brand Kit', 'SellClip Default'),
      const _InfoData(Icons.image_outlined, 'Số lượng media', '0'),
      _InfoData(Icons.grid_view_rounded, 'Số lượng scene', project.status == ProjectStatus.draft ? '0' : '9'),
    ];
    return _GlassPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCols = constraints.maxWidth >= 300;
          if (!twoCols) {
            return Column(children: [for (var i = 0; i < rows.length; i++) _InfoRow(data: rows[i], showDivider: i != rows.length - 1)]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: [for (var i = 0; i < 4; i++) _InfoRow(data: rows[i], showDivider: i != 3)])),
              Container(width: 1, height: 196, margin: const EdgeInsets.symmetric(horizontal: 10), color: Colors.white.withValues(alpha: 0.12)),
              Expanded(child: Column(children: [for (var i = 4; i < rows.length; i++) _InfoRow(data: rows[i], showDivider: i != rows.length - 1)])),
            ],
          );
        },
      ),
    );
  }
}

class _InfoData {
  const _InfoData(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.data, required this.showDivider});

  final _InfoData data;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: showDivider ? Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.10))) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(shape: BoxShape.circle, color: projectPurple.withValues(alpha: 0.20), border: Border.all(color: projectPurple.withValues(alpha: 0.35))),
            child: Icon(data.icon, color: projectPurple, size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: projectMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(data.value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RenderHistory extends StatelessWidget {
  const _RenderHistory({required this.project});

  final ProjectItem project;

  @override
  Widget build(BuildContext context) {
    final base = project.title.replaceAll(RegExp(r'\s+'), '_');
    final rows = [
      _RenderRowData('${base}_v4.mp4', project.date, 'Đang render', projectPurple, Icons.sync_rounded),
      _RenderRowData('${base}_v3.mp4', project.date, 'Hoàn thành', const Color(0xFF40D863), Icons.check_circle_rounded),
      _RenderRowData('${base}_v2.mp4', project.date, 'Thất bại', const Color(0xFFFF5656), Icons.error_outline_rounded),
      _RenderRowData('${base}_v1.mp4', project.date, 'Hoàn thành', const Color(0xFF40D863), Icons.check_circle_rounded),
    ];
    return _GlassPanel(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Text('Lịch sử render', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900))),
              Text('Xem tất cả', style: TextStyle(color: projectPurple.withValues(alpha: 0.95), fontSize: 13, fontWeight: FontWeight.w800)),
              const Icon(Icons.chevron_right_rounded, color: projectPurple),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < rows.length; i++) _RenderRow(data: rows[i], showDivider: i != rows.length - 1),
        ],
      ),
    );
  }
}

class _RenderRowData {
  const _RenderRowData(this.name, this.date, this.status, this.color, this.icon);
  final String name;
  final String date;
  final String status;
  final Color color;
  final IconData icon;
}

class _RenderRow extends StatelessWidget {
  const _RenderRow({required this.data, required this.showDivider});

  final _RenderRowData data;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(border: showDivider ? Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.10))) : null),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.09), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.movie_creation_outlined, color: projectMuted, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(data.date, style: const TextStyle(color: projectMuted, fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(color: data.color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(10), border: Border.all(color: data.color.withValues(alpha: 0.70))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(data.icon, color: data.color, size: 17),
                const SizedBox(width: 5),
                Text(data.status, style: TextStyle(color: data.color, fontSize: 12.5, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.busy, required this.onEdit, required this.onRender, required this.onDuplicate});

  final bool busy;
  final VoidCallback onEdit;
  final VoidCallback onRender;
  final VoidCallback onDuplicate;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 390;
    return Container(
      padding: EdgeInsets.all(compact ? 8 : 10),
      decoration: BoxDecoration(
        color: const Color(0xFF071225).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: projectBlue.withValues(alpha: 0.32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.50), blurRadius: 24, offset: const Offset(0, -8)),
          BoxShadow(color: projectBlue.withValues(alpha: 0.14), blurRadius: 18),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(icon: Icons.play_circle_outline_rounded, label: 'Render', primary: true, wide: true, onTap: onRender),
          SizedBox(height: compact ? 8 : 10),
          Row(
            children: [
              Expanded(child: _ActionButton(icon: Icons.edit_outlined, label: 'Chỉnh sửa', onTap: onEdit)),
              SizedBox(width: compact ? 8 : 10),
              Expanded(child: _ActionButton(icon: Icons.copy_rounded, label: busy ? 'Đang xử lý' : 'Nhân bản', onTap: busy ? null : onDuplicate)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap, this.primary = false, this.wide = false});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool primary;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: wide ? (MediaQuery.sizeOf(context).width < 390 ? 48 : 54) : (MediaQuery.sizeOf(context).width < 390 ? 44 : 48),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            gradient: primary ? const LinearGradient(colors: [Color(0xFF5600FF), Color(0xFFB735FF), Color(0xFF0097FF)]) : null,
            color: primary ? null : projectPanel.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primary ? Colors.transparent : Colors.white.withValues(alpha: 0.16)),
            boxShadow: primary ? [BoxShadow(color: projectPurple.withValues(alpha: 0.35), blurRadius: 20)] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: MediaQuery.sizeOf(context).width < 390 ? 19 : 22),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: MediaQuery.sizeOf(context).width < 390 ? 11.5 : 13, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 390 ? 12 : 16),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: projectPurple.withValues(alpha: 0.32)),
      ),
      child: child,
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}
