import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/app.dart';
import 'api_service.dart';

class AppService {
  Future<List<App>> getApps() async {
    final response = await http.get(Uri.parse(ApiService.appsEndpoint));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => App.fromJson(json)).toList();
    } else {
      throw Exception('Uygulamalar yüklenemedi');
    }
  }

  Future<App> createApp(App app) async {
    final response = await http.post(
      Uri.parse(ApiService.appsEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(app.toJson()),
    );

    if (response.statusCode == 201) {
      return App.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Uygulama oluşturulamadı');
    }
  }

  Future<void> updateApp(App app) async {
    final response = await http.put(
      Uri.parse('${ApiService.appsEndpoint}/${app.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(app.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Uygulama güncellenemedi');
    }
  }

  Future<void> deleteApp(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiService.appsEndpoint}/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Uygulama silinemedi');
    }
  }
}
