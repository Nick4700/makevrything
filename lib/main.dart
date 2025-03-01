import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'core/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService('http://your-api-base-url');

  timeago.setLocaleMessages('tr', timeago.TrMessages());
  runApp(EverythingApp(
    prefs: prefs,
    apiService: apiService,
  ));
}
