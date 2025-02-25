class ApiService {
  static const String baseUrl = 'https://makeverything.pythonanywhere.com';

  static String get aiEndpoint => '$baseUrl/ai/generate';
  static String get appsEndpoint => '$baseUrl/apps';
  static String get templatesEndpoint => '$baseUrl/templates';
  static String get accountEndpoint => '$baseUrl/account';
  static String get healthEndpoint => '$baseUrl/health';
}
