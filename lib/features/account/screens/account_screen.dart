import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../shared/widgets/app_scaffold.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return AppScaffold(
      title: 'Hesabım',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Şablonlar'),
            onTap: () => context.go('/templates'),
          ),
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('Uygulamalar'),
            onTap: () => context.go('/apps'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              themeProvider.isSystemMode
                  ? Icons.brightness_auto
                  : themeProvider.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
            ),
            title: Text(
              themeProvider.isSystemMode
                  ? 'Sistem Teması'
                  : themeProvider.isDarkMode
                      ? 'Koyu Tema'
                      : 'Açık Tema',
            ),
            onTap: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
    );
  }
}
