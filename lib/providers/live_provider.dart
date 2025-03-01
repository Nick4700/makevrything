import 'package:flutter/material.dart';
import '../core/models/live_site.dart';
import '../core/services/live_service.dart';

class LiveProvider extends ChangeNotifier {
  final LiveService _liveService;
  List<LiveSite> _sites = [];
  bool _isLoading = false;
  String? _error;

  LiveProvider(this._liveService) {
    _loadSites();
  }

  List<LiveSite> get sites => List.unmodifiable(_sites);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _loadSites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sites = await _liveService.getLiveSites();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> publishSite(String name, String htmlContent) async {
    try {
      await _liveService.publishSite(name, htmlContent);
      await _loadSites();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> unpublishSite(String id) async {
    try {
      await _liveService.unpublishSite(id);
      await _loadSites();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
