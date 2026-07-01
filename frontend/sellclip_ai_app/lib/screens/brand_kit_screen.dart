import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/brand_kit/brand_kit_widgets.dart';
import 'package:sellclip_ai_app/components/home/home_background.dart';
import 'package:sellclip_ai_app/components/projects/project_cards.dart';
import 'package:sellclip_ai_app/screens/create_brand_kit_screen.dart';
import 'package:sellclip_ai_app/services/brand_kit_api.dart';

enum BrandKitScreenStatus {
  loading,
  ready,
  empty,
  error,
  applying,
  applied,
  creating,
}

class BrandKitScreen extends StatefulWidget {
  const BrandKitScreen({
    super.key,
    required this.ownerId,
    required this.selectedBrandKitName,
  });

  final int ownerId;
  final String selectedBrandKitName;

  @override
  State<BrandKitScreen> createState() => _BrandKitScreenState();
}

class _BrandKitScreenState extends State<BrandKitScreen> {
  final _api = BrandKitApi();
  final _search = TextEditingController();
  Timer? _debounce;

  BrandKitScreenStatus _status = BrandKitScreenStatus.loading;
  List<BrandKitSummary> _items = const [];
  int? _selectedId;
  String _message = '';
  bool _showInfo = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load({String query = ''}) async {
    setState(() {
      _status = BrandKitScreenStatus.loading;
      _message = '';
    });

    final response = await _api.listBrandKits(
      ownerId: widget.ownerId,
      query: query,
    );
    if (!mounted) return;

    if (!response.ok) {
      setState(() {
        _status = BrandKitScreenStatus.error;
        _message = response.message;
      });
      return;
    }

    setState(() {
      _items = response.items;
      _selectedId = _findSelectedId(response.items);
      _status = response.items.isEmpty
          ? BrandKitScreenStatus.empty
          : BrandKitScreenStatus.ready;
    });
  }

  int? _findSelectedId(List<BrandKitSummary> items) {
    for (final item in items) {
      if (item.selected) return item.id;
    }
    for (final item in items) {
      if (item.name == widget.selectedBrandKitName) return item.id;
    }
    return items.isNotEmpty ? items.first.id : null;
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) _load(query: value);
    });
  }

  Future<void> _apply() async {
    final selectedId = _selectedId;
    if (selectedId == null) {
      setState(() {
        _status = BrandKitScreenStatus.error;
        _message = 'Vui lòng chọn Brand Kit';
      });
      return;
    }

    setState(() {
      _status = BrandKitScreenStatus.applying;
      _message = '';
    });

    final response = await _api.applyBrandKit(
      ownerId: widget.ownerId,
      brandKitId: selectedId,
    );
    if (!mounted) return;

    if (!response.ok || response.brandKit == null) {
      setState(() {
        _status = BrandKitScreenStatus.error;
        _message = response.message;
      });
      return;
    }

    setState(() {
      _status = BrandKitScreenStatus.applied;
      _message = response.message;
    });
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (mounted) Navigator.of(context).pop(response.brandKit);
  }

  Future<void> _createBrandKit() async {
    setState(() {
      _status = BrandKitScreenStatus.creating;
      _message = '';
    });
    final created = await Navigator.of(context).push<BrandKitSummary>(
      MaterialPageRoute(
        builder: (_) => CreateBrandKitScreen(ownerId: widget.ownerId),
      ),
    );
    if (!mounted) return;
    if (created == null) {
      setState(() => _status = BrandKitScreenStatus.ready);
      return;
    }
    await _load(query: _search.text);
    if (!mounted) return;
    setState(() {
      _selectedId = created.id;
      _status = BrandKitScreenStatus.ready;
      _message = 'Đã tạo ${created.name}';
    });
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(side, 8, side, 0),
              child: Column(
                children: [
                  const _BrandKitHeader(),
                  const SizedBox(height: 18),
                  BrandKitSearchField(
                    controller: _search,
                    onChanged: _onSearchChanged,
                  ),
                  if (_showInfo) ...[
                    const SizedBox(height: 14),
                    BrandKitInfoBanner(
                      onClose: () => setState(() => _showInfo = false),
                    ),
                  ],
                  const SizedBox(height: 12),
                  CreateBrandKitTile(onTap: _createBrandKit),
                  if (_message.isNotEmpty &&
                      _status != BrandKitScreenStatus.error) ...[
                    const SizedBox(height: 10),
                    Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: projectBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Expanded(child: _buildBrandKitList()),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(side, 8, side, 10),
          child: BrandKitApplyButton(
            loading: _status == BrandKitScreenStatus.applying,
            onPressed: _apply,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandKitList() {
    if (_status == BrandKitScreenStatus.loading) {
      return const _CenteredState(
        icon: Icons.sync_rounded,
        text: 'Đang tải Brand Kit...',
      );
    }
    if (_status == BrandKitScreenStatus.error) {
      return _CenteredState(
        icon: Icons.wifi_off_rounded,
        text: _message,
        actionText: 'Thử lại',
        onAction: () => _load(query: _search.text),
      );
    }
    if (_status == BrandKitScreenStatus.empty) {
      return const _CenteredState(
        icon: Icons.search_off_rounded,
        text: 'Không tìm thấy Brand Kit',
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 18),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _items[index];
        return BrandKitCard(
          brandKit: item,
          selected: _selectedId == item.id,
          onTap: () => setState(() {
            _selectedId = item.id;
            _status = BrandKitScreenStatus.ready;
            _message = '';
          }),
        );
      },
    );
  }
}

class _BrandKitHeader extends StatelessWidget {
  const _BrandKitHeader();

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
              tooltip: 'Quay lại',
            ),
          ),
          const Text(
            'Chọn Brand Kit',
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

class _CenteredState extends StatelessWidget {
  const _CenteredState({
    required this.icon,
    required this.text,
    this.actionText,
    this.onAction,
  });

  final IconData icon;
  final String text;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 18),
      decoration: BoxDecoration(
        color: projectPanel.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: projectPurple, size: 34),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 14),
            TextButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ],
      ),
    );
  }
}
