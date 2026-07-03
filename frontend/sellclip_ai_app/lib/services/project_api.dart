import 'dart:convert';

import 'package:http/http.dart' as http;

class ProjectApi {
  ProjectApi({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = String.fromEnvironment(
    'CLIP_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8082',
  );

  final http.Client _client;

  Future<ProjectListResponse> listProjects({required int ownerId}) async {
    final uri = Uri.parse('$baseUrl/api/projects').replace(
      queryParameters: {'ownerId': ownerId.toString()},
    );
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= 200 && response.statusCode < 300 && decoded is List) {
        return ProjectListResponse.success(
          decoded.whereType<Map<String, dynamic>>().map(ProjectSummary.fromJson).toList(),
        );
      }
      return const ProjectListResponse.failure('Khong tai duoc danh sach project');
    } catch (_) {
      return const ProjectListResponse.failure('Khong ket noi duoc clip-service');
    }
  }


  Future<ProjectFolderListResponse> listFolders({required int ownerId}) async {
    final uri = Uri.parse('$baseUrl/api/projects/folders').replace(
      queryParameters: {'ownerId': ownerId.toString()},
    );
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= 200 && response.statusCode < 300 && decoded is List) {
        return ProjectFolderListResponse.success(
          decoded.whereType<Map<String, dynamic>>().map(ProjectFolder.fromJson).toList(),
        );
      }
      return const ProjectFolderListResponse.failure('Khong tai duoc danh sach folder');
    } catch (_) {
      return const ProjectFolderListResponse.failure('Khong ket noi duoc clip-service');
    }
  }
  Future<ProjectApiResponse> createProject({
    required int ownerId,
    required String name,
    required ProjectType type,
    required AspectRatioOption aspectRatio,
    required String brandKit,
    required String templateName,
  }) async {
    return _sendProject(
      Uri.parse('$baseUrl/api/projects'),
      method: 'POST',
      body: {
        'ownerId': ownerId,
        'name': name,
        'type': type.apiValue,
        'aspectRatio': aspectRatio.apiValue,
        'brandKit': brandKit,
        'templateName': templateName,
      },
      successMessage: 'Tao project thanh cong',
      fallbackMessage: 'Tao project that bai',
    );
  }

  Future<ProjectApiResponse> openProject({required int ownerId, required int projectId}) async {
    final uri = Uri.parse('$baseUrl/api/projects/$projectId').replace(
      queryParameters: {'ownerId': ownerId.toString()},
    );
    return _sendProject(
      uri,
      method: 'GET',
      successMessage: 'Da mo project',
      fallbackMessage: 'Khong mo duoc project',
    );
  }

  Future<ProjectApiResponse> renameProject({
    required int ownerId,
    required int projectId,
    required String name,
  }) async {
    return _sendProject(
      Uri.parse('$baseUrl/api/projects/$projectId/rename'),
      method: 'PATCH',
      body: {'ownerId': ownerId, 'name': name},
      successMessage: 'Da doi ten project',
      fallbackMessage: 'Doi ten project that bai',
    );
  }

  Future<ProjectApiResponse> duplicateProject({required int ownerId, required int projectId}) async {
    return _sendProject(
      Uri.parse('$baseUrl/api/projects/$projectId/duplicate'),
      method: 'POST',
      body: {'ownerId': ownerId},
      successMessage: 'Da duplicate project',
      fallbackMessage: 'Nhân bản project thất bại',
    );
  }

  Future<ProjectApiResponse> moveProjectToFolder({
    required int ownerId,
    required int projectId,
    required String folderName,
  }) async {
    return _sendProject(
      Uri.parse('$baseUrl/api/projects/$projectId/folder'),
      method: 'PATCH',
      body: {'ownerId': ownerId, 'folderName': folderName},
      successMessage: folderName.trim().isEmpty ? 'Da bo khoi folder' : 'Da dua vao folder',
      fallbackMessage: 'Dua vao folder that bai',
    );
  }

  Future<ProjectApiResponse> archiveProject({required int ownerId, required int projectId}) async {
    return _sendProject(
      Uri.parse('$baseUrl/api/projects/$projectId/archive'),
      method: 'PATCH',
      body: {'ownerId': ownerId},
      successMessage: 'Da archive project',
      fallbackMessage: 'Archive project that bai',
    );
  }

  Future<ProjectApiResponse> deleteProject({required int ownerId, required int projectId}) async {
    final uri = Uri.parse('$baseUrl/api/projects/$projectId').replace(
      queryParameters: {'ownerId': ownerId.toString()},
    );
    try {
      final response = await _client.delete(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const ProjectApiResponse.successMessage('Da xoa project');
      }
      return const ProjectApiResponse.failure('Xoa project that bai');
    } catch (_) {
      return const ProjectApiResponse.failure('Khong ket noi duoc clip-service');
    }
  }

  Future<ProjectApiResponse> _sendProject(
    Uri uri, {
    required String method,
    Map<String, dynamic>? body,
    required String successMessage,
    required String fallbackMessage,
  }) async {
    try {
      final headers = body == null ? null : {'Content-Type': 'application/json'};
      final encodedBody = body == null ? null : jsonEncode(body);
      final response = await switch (method) {
        'GET' => _client.get(uri).timeout(const Duration(seconds: 4)),
        'PATCH' => _client.patch(uri, headers: headers, body: encodedBody).timeout(const Duration(seconds: 4)),
        'POST' => _client.post(uri, headers: headers, body: encodedBody).timeout(const Duration(seconds: 4)),
        _ => throw UnsupportedError('Unsupported method $method'),
      };
      final decoded = response.bodyBytes.isEmpty ? null : jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= 200 && response.statusCode < 300 && decoded is Map<String, dynamic>) {
        return ProjectApiResponse.success(ProjectSummary.fromJson(decoded), message: successMessage);
      }
      return ProjectApiResponse.failure(_messageFrom(decoded) ?? fallbackMessage);
    } catch (_) {
      return const ProjectApiResponse.failure('Khong ket noi duoc clip-service');
    }
  }

  String? _messageFrom(Object? decoded) {
    if (decoded is Map<String, dynamic>) {
      return decoded['message']?.toString();
    }
    return null;
  }
}

enum ProjectType {
  imageToVideo('IMAGE_TO_VIDEO'),
  rawVideoEditor('RAW_VIDEO_EDITOR'),
  poster('POSTER'),
  imageEditor('IMAGE_EDITOR'),
  aiContent('AI_CONTENT');

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

class ProjectListResponse {
  const ProjectListResponse._({
    required this.ok,
    required this.message,
    required this.projects,
  });

  const ProjectListResponse.success(List<ProjectSummary> projects)
      : this._(ok: true, message: '', projects: projects);

  const ProjectListResponse.failure(String message)
      : this._(ok: false, message: message, projects: const []);

  final bool ok;
  final String message;
  final List<ProjectSummary> projects;
}


class ProjectFolderListResponse {
  const ProjectFolderListResponse._({
    required this.ok,
    required this.message,
    required this.folders,
  });

  const ProjectFolderListResponse.success(List<ProjectFolder> folders)
      : this._(ok: true, message: '', folders: folders);

  const ProjectFolderListResponse.failure(String message)
      : this._(ok: false, message: message, folders: const []);

  final bool ok;
  final String message;
  final List<ProjectFolder> folders;
}

class ProjectFolder {
  const ProjectFolder({required this.name, required this.projectCount});

  factory ProjectFolder.fromJson(Map<String, dynamic> json) {
    return ProjectFolder(
      name: json['name']?.toString() ?? '',
      projectCount: int.tryParse(json['projectCount']?.toString() ?? '') ?? 0,
    );
  }

  final String name;
  final int projectCount;
}
class ProjectApiResponse {
  const ProjectApiResponse._({
    required this.ok,
    required this.message,
    this.project,
  });

  const ProjectApiResponse.failure(String message) : this._(ok: false, message: message);

  const ProjectApiResponse.success(ProjectSummary project, {String message = 'Thanh cong'})
      : this._(ok: true, message: message, project: project);

  const ProjectApiResponse.successMessage(String message) : this._(ok: true, message: message);

  final bool ok;
  final String message;
  final ProjectSummary? project;
}

class ProjectSummary {
  const ProjectSummary({
    required this.id,
    required this.name,
    required this.type,
    required this.aspectRatioLabel,
    required this.templateName,
    required this.folderName,
    required this.status,
    required this.createdAt,
  });

  factory ProjectSummary.fromJson(Map<String, dynamic> json) {
    return ProjectSummary(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'IMAGE_TO_VIDEO',
      aspectRatioLabel: json['aspectRatioLabel']?.toString() ?? json['aspectRatio']?.toString() ?? '9:16',
      templateName: json['templateName']?.toString() ?? '',
      folderName: json['folderName']?.toString(),
      status: json['status']?.toString() ?? 'DRAFT',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  final int id;
  final String name;
  final String type;
  final String aspectRatioLabel;
  final String templateName;
  final String? folderName;
  final String status;
  final DateTime createdAt;
}
