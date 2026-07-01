import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sellclip_ai_app/services/project_api.dart';

class BrandKitApi {
  BrandKitApi({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = ProjectApi.baseUrl;

  final http.Client _client;

  Future<BrandKitApplyResponse> createBrandKit({
    required int ownerId,
    required String name,
    required String logoCode,
    required List<String> palette,
    required String headingFont,
    required String bodyFont,
    required int productAssetCount,
    required int iconAssetCount,
  }) async {
    final uri = Uri.parse('$baseUrl/api/brand-kits');

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'ownerId': ownerId,
              'name': name,
              'logoCode': logoCode,
              'palette': palette,
              'headingFont': headingFont,
              'bodyFont': bodyFont,
              'productAssetCount': productAssetCount,
              'iconAssetCount': iconAssetCount,
            }),
          )
          .timeout(const Duration(seconds: 4));

      final decoded =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final brandKitJson = decoded['brandKit'];
        if (brandKitJson is Map<String, dynamic>) {
          return BrandKitApplyResponse.success(
            BrandKitSummary.fromJson(brandKitJson),
            message:
                decoded['message']?.toString() ?? 'Tạo Brand Kit thành công',
          );
        }
      }
      return BrandKitApplyResponse.failure(
        decoded['message']?.toString() ?? 'Tạo Brand Kit thất bại',
      );
    } catch (_) {
      return const BrandKitApplyResponse.failure(
        'Không kết nối được clip-service',
      );
    }
  }

  Future<BrandKitListResponse> listBrandKits({
    required int ownerId,
    String query = '',
  }) async {
    final uri = Uri.parse('$baseUrl/api/brand-kits').replace(
      queryParameters: {
        'ownerId': ownerId.toString(),
        if (query.trim().isNotEmpty) 'query': query.trim(),
      },
    );

    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 4));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          decoded is List) {
        return BrandKitListResponse.success(
          decoded
              .whereType<Map<String, dynamic>>()
              .map(BrandKitSummary.fromJson)
              .toList(),
        );
      }
      return const BrandKitListResponse.failure('Không tải được Brand Kit');
    } catch (_) {
      return const BrandKitListResponse.failure(
        'Không kết nối được clip-service',
      );
    }
  }

  Future<BrandKitApplyResponse> applyBrandKit({
    required int ownerId,
    required int brandKitId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/brand-kits/selection');

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'ownerId': ownerId,
              'brandKitId': brandKitId,
            }),
          )
          .timeout(const Duration(seconds: 4));
      final decoded =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final brandKitJson = decoded['brandKit'];
        if (brandKitJson is Map<String, dynamic>) {
          return BrandKitApplyResponse.success(
            BrandKitSummary.fromJson(brandKitJson),
          );
        }
      }
      return BrandKitApplyResponse.failure(
        decoded['message']?.toString() ?? 'Áp dụng Brand Kit thất bại',
      );
    } catch (_) {
      return const BrandKitApplyResponse.failure(
        'Không kết nối được clip-service',
      );
    }
  }
}

class BrandKitSummary {
  const BrandKitSummary({
    required this.id,
    required this.name,
    required this.logoCode,
    required this.palette,
    required this.fontCount,
    required this.assetCount,
    required this.updatedDate,
    required this.selected,
  });

  factory BrandKitSummary.fromJson(Map<String, dynamic> json) {
    final rawPalette = json['palette'];
    return BrandKitSummary(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      logoCode: json['logoCode']?.toString() ?? '',
      palette: rawPalette is List
          ? rawPalette.map((item) => item.toString()).toList()
          : const [],
      fontCount: int.tryParse(json['fontCount']?.toString() ?? '') ?? 0,
      assetCount: int.tryParse(json['assetCount']?.toString() ?? '') ?? 0,
      updatedDate: json['updatedDate']?.toString() ?? '',
      selected: json['selected'] == true,
    );
  }

  final int id;
  final String name;
  final String logoCode;
  final List<String> palette;
  final int fontCount;
  final int assetCount;
  final String updatedDate;
  final bool selected;

  BrandKitSummary copyWith({bool? selected}) {
    return BrandKitSummary(
      id: id,
      name: name,
      logoCode: logoCode,
      palette: palette,
      fontCount: fontCount,
      assetCount: assetCount,
      updatedDate: updatedDate,
      selected: selected ?? this.selected,
    );
  }
}

class BrandKitListResponse {
  const BrandKitListResponse._({
    required this.ok,
    required this.message,
    required this.items,
  });

  const BrandKitListResponse.success(List<BrandKitSummary> items)
      : this._(ok: true, message: '', items: items);

  const BrandKitListResponse.failure(String message)
      : this._(ok: false, message: message, items: const []);

  final bool ok;
  final String message;
  final List<BrandKitSummary> items;
}

class BrandKitApplyResponse {
  const BrandKitApplyResponse._({
    required this.ok,
    required this.message,
    this.brandKit,
  });

  const BrandKitApplyResponse.success(
    BrandKitSummary brandKit, {
    String message = 'Áp dụng Brand Kit thành công',
  }) : this._(
          ok: true,
          message: message,
          brandKit: brandKit,
        );

  const BrandKitApplyResponse.failure(String message)
      : this._(ok: false, message: message);

  final bool ok;
  final String message;
  final BrandKitSummary? brandKit;
}
