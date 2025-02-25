import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/template.dart';
import 'dart:convert';

class TemplateProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  List<Template> _templates = [];
  static const String _key = 'templates';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TemplateProvider(this._prefs) {
    _loadTemplates();
  }

  List<Template> get templates => List.unmodifiable(_templates);

  void _loadTemplates() {
    final json = _prefs.getString(_key);
    if (json != null) {
      final list = jsonDecode(json) as List;
      _templates = list.map((e) => Template.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> addTemplate(Template template) async {
    try {
      _isLoading = true;
      notifyListeners();

      _templates.add(template);
      await _saveTemplates();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTemplate(Template template) async {
    final index = _templates.indexWhere((t) => t.id == template.id);
    if (index != -1) {
      _templates[index] = template;
      await _saveTemplates();
      notifyListeners();
    }
  }

  Future<void> deleteTemplate(String id) async {
    _templates.removeWhere((t) => t.id == id);
    await _saveTemplates();
    notifyListeners();
  }

  Future<void> _saveTemplates() async {
    final json = jsonEncode(_templates.map((t) => t.toJson()).toList());
    await _prefs.setString(_key, json);
  }
}
