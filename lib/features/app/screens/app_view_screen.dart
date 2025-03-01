import 'package:flutter/material.dart';
import '../../../providers/app_provider.dart';
import '../../home/widgets/html_preview_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/enums/view_mode.dart';

class AppViewScreen extends StatelessWidget {
  final String appId;
  final ViewMode viewMode;

  const AppViewScreen({
    super.key,
    required this.appId,
    this.viewMode = ViewMode.web,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final app = provider.apps.firstWhere((a) => a.id == appId);

        return Scaffold(
          appBar: AppBar(
            title: Text(app.name),
            centerTitle: true,
          ),
          body: HtmlPreviewWidget(
            htmlContent: app.htmlContent,
            viewMode: viewMode,
          ),
        );
      },
    );
  }
}
