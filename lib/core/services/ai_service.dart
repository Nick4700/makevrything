import 'package:dio/dio.dart';

class AIService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://makeverything.pythonanywhere.com/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<String> generateHtmlResponse(
      List<Map<String, dynamic>> messages) async {
    try {
      final response = await _dio.post(
        '/generate',
        data: {'messages': messages},
      );

      if (response.data['error'] != null) {
        throw Exception(response.data['error']);
      }

      return response.data['html'] as String;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Bağlantı zaman aşımına uğradı');
      } else if (e.response?.statusCode == 429) {
        throw Exception('API kotası doldu. Lütfen daha sonra tekrar deneyin.');
      }
      throw Exception('AI servisi hatası: ${e.message}');
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.data['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }
}
