import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/template.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../features/templates/widgets/create_app_dialog.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/template_provider.dart';

class TemplateCard extends StatelessWidget {
  final Template template;

  const TemplateCard({
    super.key,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      template.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      'Son güncelleme: ${timeago.format(template.updatedAt, locale: 'tr')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Çalışma Alanına Taşı'),
                    onTap: () {
                      Navigator.pop(context); // Bottom sheet'i kapat
                      Provider.of<ChatProvider>(context, listen: false)
                          .loadTemplate(template);
                      context.go('/generate'); // Generate sayfasına git
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.apps_outlined),
                    title: const Text('Uygulama Oluştur'),
                    onTap: () {
                      Navigator.pop(context); // Bottom sheet'i kapat
                      showDialog(
                        context: context,
                        builder: (context) => CreateAppDialog(
                          templateId: template.id,
                          htmlContent: template.htmlContent,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      'Sil',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Bottom sheet'i kapat
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Şablonu Sil'),
                          content: Text(
                            '${template.name} şablonunu silmek istediğinize emin misiniz?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('İptal'),
                            ),
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Provider.of<TemplateProvider>(context,
                                        listen: false)
                                    .deleteTemplate(template.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Şablon silindi'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                              child: const Text('Sil'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                template.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Son güncelleme: ${timeago.format(template.updatedAt, locale: 'tr')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
