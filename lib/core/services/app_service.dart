import '../models/app.dart';
import 'api_service.dart';
import 'dart:convert';

class AppService {
  final ApiService _apiService;

  AppService(this._apiService);

  Future<List<App>> getApps() async {
    final response = await _apiService.get(_apiService.appsEndpoint);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => App.fromJson(json)).toList();
    } else {
      throw Exception('Uygulamalar yüklenemedi');
    }
  }

  Future<App> createApp(App app) async {
    final response = await _apiService.post(
      _apiService.appsEndpoint,
      app.toJson(), // Zaten Map<String, dynamic> döndürüyor
    );

    if (response.statusCode == 201) {
      return App.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Uygulama oluşturulamadı');
    }
  }

  Future<void> updateApp(App app) async {
    final response = await _apiService.put(
      '${_apiService.appsEndpoint}/${app.id}',
      app.toJson(), // Zaten Map<String, dynamic> döndürüyor
    );

    if (response.statusCode != 200) {
      throw Exception('Uygulama güncellenemedi');
    }
  }

  Future<void> deleteApp(String id) async {
    final response = await _apiService.delete('${_apiService.appsEndpoint}/$id');

    if (response.statusCode != 204) {
      throw Exception('Uygulama silinemedi');
    }
  }
}
