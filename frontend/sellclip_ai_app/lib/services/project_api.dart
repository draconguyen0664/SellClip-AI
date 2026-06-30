import 'dart:convert';

import 'package:http/http.dart' as http;

class ProjectApi {
  ProjectApi({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = String.fromEnvironment(
    'CLIP_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8082',
  );

  final http.Client _client;

  Future<ProjectApiResponse> createProject({
    required int ownerId,
    required String name,
    required ProjectType type,
    required AspectRatioOption aspectRatio,
    required String brandKit,
    required String templateName,
  }) async {
    final uri = Uri.parse('$baseUrl/api/projects');
    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'ownerId': ownerId,
              'name': name,
              'type': type.apiValue,
              'aspectRatio': aspectRatio.apiValue,
              'brandKit': brandKit,
              'templateName': templateName,
            }),
          )
          .timeout(const Duration(seconds: 4));

      final decoded =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ProjectApiResponse.success(ProjectSummary.fromJson(decoded));
      }
      return ProjectApiResponse.failure(
        decoded['message']?.toString() ?? 'Tạo project thất bại',
      );
    } catch (_) {
      return const ProjectApiResponse.failure('Không kết nối được clip-service');
    }
  }
}

enum ProjectType {
  imageToVideo('IMAGE_TO_VIDEO'),
  rawVideoEditor('RAW_VIDEO_EDITOR'),
  poster('POSTER'),
  imageEditor('IMAGE_EDITOR');

  const ProjectType(this.apiValue);
  final String apiValue;
}

enum AspectRatioOption {
  ratio916('RATIO_9_16', '9:16'),
  ratio11('RATIO_1_1', '1:1'),
  ratio45('RATIO_4_5', '4:5'),
  ratio169('RATIO_16_9', '16:9');

  const AspectRatioOption(this.apiValue, this.label);
  final String apiValue;
  final String label;
}

class ProjectApiResponse {
  const ProjectApiResponse._({
    required this.ok,
    required this.message,
    this.project,
  });

  const ProjectApiResponse.failure(String message)
      : this._(ok: false, message: message);

  const ProjectApiResponse.success(ProjectSummary project)
      : this._(
          ok: true,
          message: 'Tạo project thành công',
          project: project,
        );

  final bool ok;
  final String message;
  final ProjectSummary? project;
}

class ProjectSummary {
  const ProjectSummary({
    required this.id,
    required this.name,
    required this.status,
  });

  factory ProjectSummary.fromJson(Map<String, dynamic> json) {
    return ProjectSummary(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'DRAFT',
    );
  }

  final int id;
  final String name;
  final String status;
}
