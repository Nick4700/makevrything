import 'ai_service.dart';

class HealthService {
  final AIService _aiService;
  static const baseUrl = 'http://makeverything.pythonanywhere.com/';

  HealthService(this._aiService);

  Future<bool> checkConnection() async {
    try {
      return await _aiService.checkHealth();
    } catch (e) {
      print('Sağlık kontrolü hatası: $e');
      return false;
    }
  }
}
