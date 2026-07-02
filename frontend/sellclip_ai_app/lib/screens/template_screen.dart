import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/home/home_background.dart';
import 'package:sellclip_ai_app/components/template/template_widgets.dart';
import 'package:sellclip_ai_app/services/template_api.dart';

enum TemplateScreenStatus { loading, ready, empty, error, applying, applied }

class TemplateScreenResult {
  const TemplateScreenResult.blank() : template = null;
  const TemplateScreenResult.template(this.template);

  final TemplateSummary? template;

  bool get noTemplate => template == null;
}

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({
    super.key,
    required this.ownerId,
    required this.selectedTemplateName,
  });

  final int ownerId;
  final String selectedTemplateName;

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  final _api = TemplateApi();
  final _search = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounce;

  TemplateScreenStatus _status = TemplateScreenStatus.loading;
  List<TemplateSummary> _items = const [];
  String _category = 'T\u1ea5t c\u1ea3';
  String _message = '';
  int? _selectedTemplateId;
  bool _noTemplate = true;

  @override
  void initState() {
    super.initState();
    _noTemplate = widget.selectedTemplateName == 'Kh\u00f4ng d\u00f9ng template';
    _loadTemplates();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _status = TemplateScreenStatus.loading;
      _message = '';
    });

    final response = await _api.listTemplates(
      ownerId: widget.ownerId,
      query: _search.text,
      category: _category,
    );
    if (!mounted) return;

    final items = response.ok ? response.items : TemplateApi.localTemplates;
    final selected = items.where((item) => item.selected).toList();
    setState(() {
      _items = items;
      _selectedTemplateId = selected.isNotEmpty ? selected.first.id : _findSelectedId(items);
      if (_selectedTemplateId != null) _noTemplate = false;
      _status = _items.isEmpty ? TemplateScreenStatus.empty : TemplateScreenStatus.ready;
      _message = '';
    });
  }

  int? _findSelectedId(List<TemplateSummary> items) {
    for (final item in items) {
      if (item.name == widget.selectedTemplateName) return item.id;
    }
    return null;
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), _loadTemplates);
  }

  void _chooseBlank() {
    setState(() {
      _noTemplate = true;
      _selectedTemplateId = null;
      _status = TemplateScreenStatus.ready;
    });
  }

  void _chooseTemplate(TemplateSummary template) {
    if (template.premium) {
      _showPremiumDialog(template);
      return;
    }
    setState(() {
      _noTemplate = false;
      _selectedTemplateId = template.id;
      _status = TemplateScreenStatus.ready;
    });
  }

  Future<void> _showPremiumDialog(TemplateSummary template) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF070525),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFD424).withValues(alpha: 0.55)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD424).withValues(alpha: 0.18),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD424), Color(0xFF7B35FF)],
                    ),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Template Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Template "${template.name}" c\u1ea7n g\u00f3i Premium. N\u00e2ng c\u1ea5p \u0111\u1ec3 s\u1eed d\u1ee5ng template n\u00e0y.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFB8B3C8),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Để sau'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B35FF), Color(0xFF009BFF)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Mua gói',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _apply() async {
    TemplateSummary? selected;
    if (!_noTemplate) {
      for (final item in _items) {
        if (item.id == _selectedTemplateId) {
          selected = item;
          break;
        }
      }
    }

    setState(() {
      _status = TemplateScreenStatus.applying;
      _message = '';
    });

    final response = await _api.applyTemplate(
      ownerId: widget.ownerId,
      templateId: _selectedTemplateId,
      noTemplate: _noTemplate,
    );

    if (!mounted) return;
    if (!response.ok && selected == null && !_noTemplate) {
      setState(() {
        _status = TemplateScreenStatus.error;
        _message = response.message;
      });
      return;
    }

    final result = _noTemplate
        ? const TemplateScreenResult.blank()
        : TemplateScreenResult.template(response.template ?? selected!);

    setState(() {
      _status = TemplateScreenStatus.applied;
      _message = response.ok ? response.message : '';
    });
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final side = (MediaQuery.sizeOf(context).width * 0.04).clamp(14.0, 22.0);
    return Scaffold(
      backgroundColor: const Color(0xFF020514),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _TemplateHeader(onBack: () => Navigator.of(context).pop()),
                Expanded(
                  child: ListView(
                    controller: _scroll,
                    padding: EdgeInsets.fromLTRB(side, 12, side, 96),
                    children: [
                      TemplateSearchField(controller: _search, onChanged: _onSearchChanged),
                      const SizedBox(height: 12),
                      TemplateCategoryChips(
                        selected: _category,
                        onSelected: (value) {
                          setState(() => _category = value);
                          _loadTemplates();
                        },
                      ),
                      const SizedBox(height: 14),
                      NoTemplateCard(selected: _noTemplate, onTap: _chooseBlank),
                      const SizedBox(height: 14),
                      _buildTemplateGrid(),
                      if (_message.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _status == TemplateScreenStatus.error
                                ? const Color(0xFFFF6175)
                                : const Color(0xFF46E38C),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
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
          child: TemplateApplyButton(
            loading: _status == TemplateScreenStatus.applying,
            onPressed: _apply,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateGrid() {
    if (_status == TemplateScreenStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    if (_status == TemplateScreenStatus.empty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Text(
            'Ch\u01b0a c\u00f3 template ph\u00f9 h\u1ee3p',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final tileWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final template in _items)
              SizedBox(
                width: tileWidth,
                height: 250,
                child: TemplateCard(
                  template: template,
                  selected: !_noTemplate && _selectedTemplateId == template.id,
                  onTap: () => _chooseTemplate(template),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TemplateHeader extends StatelessWidget {
  const _TemplateHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.white,
                iconSize: 23,
              ),
            ),
          ),
          const Text(
            'Ch\u1ecdn template',
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