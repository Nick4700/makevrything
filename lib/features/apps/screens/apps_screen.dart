import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../../providers/app_provider.dart';
import '../widgets/app_card.dart';
import 'package:go_router/go_router.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Uygulamalar',
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.apps.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.apps_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz uygulama yok',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => context.go('/templates'),
                    icon: const Icon(Icons.add),
                    label: const Text('Şablondan Oluştur'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.apps.length,
            itemBuilder: (context, index) {
              final app = provider.apps[index];
              return AppCard(app: app);
            },
          );
        },
      ),
    );
  }
}
