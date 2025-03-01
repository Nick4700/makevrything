import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../providers/app_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/enums/view_mode.dart';

class HtmlPreviewWidget extends StatefulWidget {
  final String htmlContent;
  final String? appId;
  final ViewMode viewMode;

  const HtmlPreviewWidget({
    super.key,
    required this.htmlContent,
    this.appId,
    required this.viewMode,
  });

  @override
  State<HtmlPreviewWidget> createState() => HtmlPreviewWidgetState();
}

class HtmlPreviewWidgetState extends State<HtmlPreviewWidget> {
  late final WebViewController _controller;
  late final TextEditingController _codeController;
  String _lastSavedCode = '';

  @override
  void initState() {
    super.initState();
    _lastSavedCode = widget.htmlContent;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(widget.htmlContent);
    _codeController = TextEditingController(text: widget.htmlContent)
      ..addListener(_onCodeChanged);
  }

  void _onCodeChanged() {
    // Çok sık çağrılmasını engellemek için debounce ekleyelim
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.loadHtmlString(_codeController.text);
      }
    });
  }

  @override
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HtmlPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.htmlContent != oldWidget.htmlContent) {
      _lastSavedCode = widget.htmlContent;
      _controller.loadHtmlString(widget.htmlContent);
      _codeController.text = widget.htmlContent;
    }
  }

  // Dışarıdan HTML içeriğini almak için metod
  Future<String> getCurrentHtml() async {
    if (widget.viewMode == ViewMode.code) {
      return _codeController.text;
    } else {
      final html = await _controller.runJavaScriptReturningResult(
        'document.documentElement.outerHTML',
      ) as String;
      final decodedHtml = jsonDecode('$html');
      return decodedHtml.toString();
    }
  }

  // HTML'i kaydetmek için metod
  Future<void> saveHtml() async {
    try {
      final currentHtml = await getCurrentHtml();
      
      if (currentHtml != _lastSavedCode && widget.appId != null) {
        Provider.of<AppProvider>(context, listen: false)
            .updateAppHtml(widget.appId!, currentHtml);

        setState(() {
          _lastSavedCode = currentHtml;
          _codeController.text = currentHtml;
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Değişiklikler kaydedildi'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kaydetme hatası: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kod görünümü için
    if (widget.viewMode == ViewMode.code) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _codeController,
                  maxLines: null,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: _codeController.text),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('HTML kopyalandı'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Kopyala'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () async {
                    try {
                      final directory = await getTemporaryDirectory();
                      final file = File('${directory.path}/page.html');
                      await file.writeAsString(_codeController.text);

                      await Share.shareXFiles(
                        [XFile(file.path)],
                        text: 'HTML Sayfası',
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dışa aktarma hatası: $e'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('İndir'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Web görünümü için
    return Stack(
      children: [
        Positioned.fill(
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      ],
    );
  }
}
