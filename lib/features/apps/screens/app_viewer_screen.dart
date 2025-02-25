import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../../providers/app_provider.dart';
import '../../home/widgets/html_preview_widget.dart';

class AppViewerScreen extends StatelessWidget {
  final String appId;

  const AppViewerScreen({
    super.key,
    required this.appId,
  });

  @override
  Widget build(BuildContext context) {
    final app =
        context.watch<AppProvider>().apps.firstWhere((app) => app.id == appId);

    return AppScaffold(
      title: app.name,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Geri',
      ),
      showBottomNav: false,
      child: HtmlPreviewWidget(
        htmlContent: app.htmlContent,
        appId: app.id,
      ),
    );
  }
}
