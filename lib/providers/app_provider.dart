import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/app.dart';
import 'dart:convert';
import '../core/utils/error_handler.dart';
import '../core/services/api_service.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AppProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final ApiService _apiService;
  final BuildContext? context;
  List<App> _apps = [];
  static const String _key = 'apps';
  bool _isLoading = false;

  AppProvider(this._prefs, this._apiService, [this.context]) {
    _loadApps();
  }

  List<App> get apps => List.unmodifiable(_apps);
  bool get isLoading => _isLoading;

  void _loadApps() {
    try {
      final json = _prefs.getString(_key);
      if (json != null) {
        final list = jsonDecode(json) as List;
        _apps = list
            .map((e) {
              try {
                return App.fromJson(e as Map<String, dynamic>);
              } catch (e) {
                debugPrint('App yüklenirken hata: $e');
                return null;
              }
            })
            .whereType<App>()
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Apps yüklenirken hata: $e');
      _apps = [];
    }
  }

  Future<void> addApp(App app) async {
    try {
      _isLoading = true;
      notifyListeners();

      _apps.add(app);
      await _saveApps();
    } catch (e) {
      throw Exception(
          'Uygulama kaydedilemedi: ${ErrorHandler.getErrorMessage(e)}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteApp(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      _apps.removeWhere((a) => a.id == id);
      await _saveApps();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveApps() async {
    final json = jsonEncode(_apps.map((a) => a.toJson()).toList());
    await _prefs.setString(_key, json);
  }

  Future<void> updateAppHtml(String appId, String newHtml) async {
    try {
      _isLoading = true;
      notifyListeners();

      final index = _apps.indexWhere((app) => app.id == appId);
      if (index != -1) {
        _apps[index] = _apps[index].copyWith(htmlContent: newHtml);
        await _saveApps();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAppName(String appId, String newName) async {
    try {
      _isLoading = true;
      notifyListeners();

      final index = _apps.indexWhere((app) => app.id == appId);
      if (index != -1) {
        _apps[index] = _apps[index].copyWith(name: newName);
        await _saveApps();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> publishApp(String appId, String appName, String html, bool isPublic) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.post('${_apiService.appsEndpoint}/publish', {
        'appId': appId,
        'name': appName,
        'html': html,
        'isPublic': isPublic,
      });

      if (response.statusCode != 200) {
        throw Exception('Uygulama yayınlanamadı: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      final publishedId = responseData['id'];
      final publishedUrl = '/apps/$publishedId/$appName';
      
      if (context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Uygulama başarıyla yayınlandı'),
                Text('URL: $publishedUrl', style: const TextStyle(fontSize: 12)),
              ],
            ),
            action: SnackBarAction(
              label: 'Kopyala',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: publishedUrl));
              },
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
