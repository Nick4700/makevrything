import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../../providers/app_provider.dart';
import '../../home/widgets/html_preview_widget.dart';
import '../../../core/enums/view_mode.dart';

class AppViewerScreen extends StatefulWidget {
  final String appId;
  final ViewMode viewMode;

  const AppViewerScreen({
    Key? key,
    required this.appId,
    this.viewMode = ViewMode.web,
  }) : super(key: key);

  @override
  State<AppViewerScreen> createState() => _AppViewerScreenState();
}

class _AppViewerScreenState extends State<AppViewerScreen> {
  final _previewKey = GlobalKey<HtmlPreviewWidgetState>();
  
  void _showPublishDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String appName = '';
        bool isPublic = false;
        
        return AlertDialog(
          title: const Text('Uygulamayı Yayınla'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Uygulama Adı',
                  hintText: 'Uygulamanızın adını girin',
                ),
                onChanged: (value) => appName = value,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Herkese Açık'),
                subtitle: const Text('Başkaları bu uygulamayı düzenleyebilir'),
                value: isPublic,
                onChanged: (value) => setState(() => isPublic = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () async {
                if (appName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen bir uygulama adı girin'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                
                try {
                  final html = await _previewKey.currentState?.getCurrentHtml();
                  if (html != null) {
                    await Provider.of<AppProvider>(context, listen: false)
                        .publishApp(widget.appId, appName, html, isPublic);
                        
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Uygulama başarıyla yayınlandı'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Yayınlama hatası: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: const Text('Yayınla'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final app =
        context.watch<AppProvider>().apps.firstWhere((app) => app.id == widget.appId);

    return AppScaffold(
      title: app.name,
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            _previewKey.currentState?.saveHtml();
          },
          tooltip: 'Kaydet',
        ),
        IconButton(
          icon: const Icon(Icons.publish),
          onPressed: _showPublishDialog,
          tooltip: 'Yayınla',
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Geri',
      ),
      showBottomNav: false,
      child: HtmlPreviewWidget(
        key: _previewKey,
        htmlContent: app.htmlContent,
        appId: app.id,
        viewMode: widget.viewMode,
      ),
    );
  }
}
