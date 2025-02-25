import 'package:flutter/material.dart';
import '../../../providers/app_provider.dart';
import '../../home/widgets/html_preview_widget.dart';
import 'package:provider/provider.dart';

class AppViewScreen extends StatelessWidget {
  final String appId;

  const AppViewScreen({
    super.key,
    required this.appId,
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
          ),
        );
      },
    );
  }
}
