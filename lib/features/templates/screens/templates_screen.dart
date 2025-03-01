import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../../providers/template_provider.dart';
import '../widgets/template_card.dart';
import '../../../providers/chat_provider.dart';
import '../../generate/widgets/save_template_dialog.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Şablonlar',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SaveTemplateDialog(
                htmlContent: context.read<ChatProvider>().currentHtml,
              ),
            );
          },
          tooltip: 'Yeni Şablon',
        ),
      ],
      child: Consumer<TemplateProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz şablon yok',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SaveTemplateDialog(
                          htmlContent: context.read<ChatProvider>().currentHtml,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Şablon Oluştur'),
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
            itemCount: provider.templates.length,
            itemBuilder: (context, index) {
              final template = provider.templates[index];
              return TemplateCard(template: template);
            },
          );
        },
      ),
    );
  }
}
