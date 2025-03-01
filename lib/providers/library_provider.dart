import 'package:flutter/material.dart';
import '../core/models/html_file.dart';
import '../core/services/file_service.dart';

class LibraryProvider extends ChangeNotifier {
  final FileService _fileService;
  List<HtmlFile> _files = [];
  bool _isLoading = false;
  String? _error;

  LibraryProvider(this._fileService) {
    _loadFiles();
  }

  List<HtmlFile> get files => List.unmodifiable(_files);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _loadFiles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _files = await _fileService.getFiles();
    } catch (e) {
      _error = 'Dosyalar yüklenirken hata oluştu: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveCurrentHtml(String name, String content) async {
    final file = HtmlFile(
      id: DateTime.now().toString(),
      name: name,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _fileService.saveFile(file);
      await _loadFiles();
    } catch (e) {
      _error = 'Dosya kaydedilirken hata oluştu: $e';
      notifyListeners();
    }
  }

  Future<void> deleteFile(String id) async {
    try {
      await _fileService.deleteFile(id);
      await _loadFiles();
    } catch (e) {
      _error = 'Dosya silinirken hata oluştu: $e';
      notifyListeners();
    }
  }

  Future<void> updateFile(HtmlFile file) async {
    try {
      await _fileService.updateFile(file);
      await _loadFiles();
    } catch (e) {
      _error = 'Dosya güncellenirken hata oluştu: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  List<HtmlFile> get templates => _files.where((f) => f.isTemplate).toList();

  Future<void> createFromTemplate(HtmlFile template, String newName) async {
    final newFile = HtmlFile(
      id: DateTime.now().toString(),
      name: newName,
      content: template.content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isTemplate: false,
    );

    try {
      await _fileService.saveFile(newFile);
      await _loadFiles();
    } catch (e) {
      _error = 'Şablondan dosya oluşturulurken hata oluştu: $e';
      notifyListeners();
    }
  }

  Future<void> addFile(HtmlFile file) async {
    try {
      await _fileService.saveFile(file);
      await _loadFiles();
    } catch (e) {
      _error = 'Dosya eklenirken hata oluştu: $e';
      notifyListeners();
    }
  }
}
