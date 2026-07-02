import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sellclip_ai_app/services/project_api.dart';

class TemplateApi {
  TemplateApi({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = ProjectApi.baseUrl;

  static const localTemplates = [
    TemplateSummary(
      id: 1,
      name: 'Glow Serum Ad',
      category: 'M\u1ef9 ph\u1ea9m',
      aspectRatio: '9:16',
      durationSeconds: 15,
      premium: false,
      thumbnailCode: 'glow',
      selected: false,
    ),
    TemplateSummary(
      id: 2,
      name: 'Fashion Sale',
      category: 'Th\u1eddi trang',
      aspectRatio: '9:16',
      durationSeconds: 15,
      premium: true,
      thumbnailCode: 'fashion',
      selected: false,
    ),
    TemplateSummary(
      id: 3,
      name: 'Flash Sale 6.6',
      category: 'Flash sale',
      aspectRatio: '9:16',
      durationSeconds: 15,
      premium: true,
      thumbnailCode: 'flash',
      selected: false,
    ),
    TemplateSummary(
      id: 4,
      name: 'Review Son M\u00f4i',
      category: 'Review',
      aspectRatio: '9:16',
      durationSeconds: 15,
      premium: false,
      thumbnailCode: 'review',
      selected: false,
    ),
  ];

  final http.Client _client;

  Future<TemplateListResponse> listTemplates({
    required int ownerId,
    String query = '',
    String category = '',
  }) async {
    final uri = Uri.parse('$baseUrl/api/templates').replace(
      queryParameters: {
        'ownerId': ownerId.toString(),
        if (query.trim().isNotEmpty) 'query': query.trim(),
        if (category.trim().isNotEmpty && category != 'T\u1ea5t c\u1ea3')
          'category': category.trim(),
      },
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= 200 && response.statusCode < 300 && decoded is List) {
        return TemplateListResponse.success(
          decoded.whereType<Map<String, dynamic>>().map(TemplateSummary.fromJson).toList(),
        );
      }
      return const TemplateListResponse.failure('Kh\u00f4ng t\u1ea3i \u0111\u01b0\u1ee3c template');
    } catch (_) {
      return const TemplateListResponse.failure('Kh\u00f4ng k\u1ebft n\u1ed1i \u0111\u01b0\u1ee3c clip-service');
    }
  }

  Future<TemplateApplyResponse> applyTemplate({
    required int ownerId,
    int? templateId,
    bool noTemplate = false,
  }) async {
    final uri = Uri.parse('$baseUrl/api/templates/selection');

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'ownerId': ownerId,
              'templateId': templateId,
              'noTemplate': noTemplate,
            }),
          )
          .timeout(const Duration(seconds: 4));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final templateJson = decoded['template'];
        if (decoded['noTemplate'] == true) {
          return TemplateApplyResponse.blank(
            decoded['message']?.toString() ?? '\u0110\u00e3 ch\u1ecdn kh\u00f4ng d\u00f9ng template',
          );
        }
        if (templateJson is Map<String, dynamic>) {
          return TemplateApplyResponse.success(
            TemplateSummary.fromJson(templateJson),
            message: decoded['message']?.toString() ?? '\u0110\u00e3 \u00e1p d\u1ee5ng template',
          );
        }
      }
      return TemplateApplyResponse.failure(
        decoded['message']?.toString() ?? '\u00c1p d\u1ee5ng template th\u1ea5t b\u1ea1i',
      );
    } catch (_) {
      return const TemplateApplyResponse.failure('Kh\u00f4ng k\u1ebft n\u1ed1i \u0111\u01b0\u1ee3c clip-service');
    }
  }
}

class TemplateSummary {
  const TemplateSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.aspectRatio,
    required this.durationSeconds,
    required this.premium,
    required this.thumbnailCode,
    required this.selected,
  });

  factory TemplateSummary.fromJson(Map<String, dynamic> json) {
    return TemplateSummary(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      aspectRatio: json['aspectRatio']?.toString() ?? '9:16',
      durationSeconds: int.tryParse(json['durationSeconds']?.toString() ?? '') ?? 15,
      premium: json['premium'] == true,
      thumbnailCode: json['thumbnailCode']?.toString() ?? 'glow',
      selected: json['selected'] == true,
    );
  }

  final int id;
  final String name;
  final String category;
  final String aspectRatio;
  final int durationSeconds;
  final bool premium;
  final String thumbnailCode;
  final bool selected;

  String get durationLabel => '${durationSeconds}s';
}

class TemplateListResponse {
  const TemplateListResponse._({
    required this.ok,
    required this.message,
    required this.items,
  });

  const TemplateListResponse.success(List<TemplateSummary> items)
      : this._(ok: true, message: '', items: items);

  const TemplateListResponse.failure(String message)
      : this._(ok: false, message: message, items: const []);

  final bool ok;
  final String message;
  final List<TemplateSummary> items;
}

class TemplateApplyResponse {
  const TemplateApplyResponse._({
    required this.ok,
    required this.message,
    required this.noTemplate,
    this.template,
  });

  const TemplateApplyResponse.success(
    TemplateSummary template, {
    String message = '\u0110\u00e3 \u00e1p d\u1ee5ng template',
  }) : this._(ok: true, message: message, noTemplate: false, template: template);

  const TemplateApplyResponse.blank(String message)
      : this._(ok: true, message: message, noTemplate: true);

  const TemplateApplyResponse.failure(String message)
      : this._(ok: false, message: message, noTemplate: false);

  final bool ok;
  final String message;
  final bool noTemplate;
  final TemplateSummary? template;
}