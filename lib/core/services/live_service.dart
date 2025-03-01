import 'package:dio/dio.dart';
import '../models/live_site.dart';

class LiveService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: '1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<LiveSite> publishSite(String name, String htmlContent) async {
    try {
      final response = await _dio.post(
        '/publish',
        data: {
          'name': name,
          'htmlContent': htmlContent,
        },
      );

      if (response.data['error'] != null) {
        throw Exception(response.data['error']);
      }

      return LiveSite.fromJson(response.data['site']);
    } catch (e) {
      throw Exception('Site yayınlanırken hata oluştu: $e');
    }
  }

  Future<void> unpublishSite(String id) async {
    try {
      await _dio.delete('/publish/$id');
    } catch (e) {
      throw Exception('Site yayından kaldırılırken hata oluştu: $e');
    }
  }

  Future<List<LiveSite>> getLiveSites() async {
    try {
      final response = await _dio.get('/sites');
      final List<dynamic> sites = response.data['sites'];
      return sites.map((site) => LiveSite.fromJson(site)).toList();
    } catch (e) {
      throw Exception('Yayındaki siteler alınırken hata oluştu: $e');
    }
  }
}
