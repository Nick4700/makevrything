import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/html_file.dart';

class FileService {
  static const String _filesKey = 'html_files';
  final SharedPreferences _prefs;

  FileService(this._prefs);

  Future<List<HtmlFile>> getFiles() async {
    final String? filesJson = _prefs.getString(_filesKey);
    if (filesJson == null) return [];

    final List<dynamic> filesList = json.decode(filesJson);
    return filesList.map((e) => HtmlFile.fromJson(e)).toList();
  }

  Future<void> saveFile(HtmlFile file) async {
    final files = await getFiles();
    files.add(file);
    await _saveFiles(files);
  }

  Future<void> updateFile(HtmlFile file) async {
    final files = await getFiles();
    final index = files.indexWhere((f) => f.id == file.id);
    if (index != -1) {
      files[index] = file;
      await _saveFiles(files);
    }
  }

  Future<void> deleteFile(String id) async {
    final files = await getFiles();
    files.removeWhere((f) => f.id == id);
    await _saveFiles(files);
  }

  Future<void> _saveFiles(List<HtmlFile> files) async {
    final filesJson = json.encode(files.map((e) => e.toJson()).toList());
    await _prefs.setString(_filesKey, filesJson);
  }
}
