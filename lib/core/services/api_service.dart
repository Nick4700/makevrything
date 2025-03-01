import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService(this.baseUrl) : _client = http.Client();

  // Endpoint getters
  String get aiEndpoint => '/ai/generate';
  String get appsEndpoint => '/api/apps';
  String get templatesEndpoint => '/templates';
  String get accountEndpoint => '/account';
  String get healthEndpoint => '/health';

  String _getFullUrl(String path) {
    return '$baseUrl${path.startsWith('/') ? path : '/$path'}';
  }

  Future<http.Response> get(String path) async {
    final url = Uri.parse(_getFullUrl(path));
    return await _client.get(url);
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse(_getFullUrl(path));
    return await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    final url = Uri.parse(_getFullUrl(path));
    return await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) async {
    final url = Uri.parse(_getFullUrl(path));
    return await _client.delete(url);
  }

  void dispose() {
    _client.close();
  }
}
