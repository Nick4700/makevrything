import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'providers/template_provider.dart';
import 'providers/app_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/theme_provider.dart';
import 'core/services/api_service.dart';

class EverythingApp extends StatelessWidget {
  final SharedPreferences prefs;
  final ApiService apiService;

  const EverythingApp({
    super.key,
    required this.prefs,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (context) => AppProvider(prefs, apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TemplateProvider(prefs),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp.router(
          title: 'Everything',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
