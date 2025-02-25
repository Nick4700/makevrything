import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/loading_overlay.dart';
import '../../../providers/chat_provider.dart';
import '../../home/widgets/chat_input_widget.dart';
import '../../home/widgets/chat_message_widget.dart';
import '../widgets/save_template_dialog.dart';
import '../../home/widgets/html_preview_widget.dart';
import 'package:flutter/services.dart'; // Clipboard için
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Görünüm modları
enum ViewMode { web, chat, code } // Web ve chat ayrı modlar olarak eklendi

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  ViewMode _currentMode = ViewMode.web;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'HTML Üret',
      actions: [
        // Web görünümü butonu
        IconButton(
          icon: const Icon(Icons.web),
          onPressed: () {
            setState(() => _currentMode = ViewMode.web);
          },
          tooltip: 'Web Görünümü',
          color: _currentMode == ViewMode.web
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        // Sohbet butonu
        IconButton(
          icon: const Icon(Icons.chat_outlined),
          onPressed: () {
            setState(() => _currentMode = ViewMode.chat);
          },
          tooltip: 'Sohbet',
          color: _currentMode == ViewMode.chat
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        // Kod görüntüleme butonu
        IconButton(
          icon: const Icon(Icons.code),
          onPressed: () {
            setState(() => _currentMode = ViewMode.code);
          },
          tooltip: 'HTML Kodu',
          color: _currentMode == ViewMode.code
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        // Kaydetme butonu
        IconButton(
          icon: const Icon(Icons.save_outlined),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SaveTemplateDialog(
                htmlContent: context.read<ChatProvider>().currentHtml,
              ),
            );
          },
          tooltip: 'Şablon Olarak Kaydet',
        ),
      ],
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) => LoadingOverlay(
          isLoading: chatProvider.isLoading,
          message: 'HTML oluşturuluyor...',
          child: Column(
            children: [
              if (chatProvider.error != null)
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chatProvider.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: chatProvider.clearError,
                        tooltip: 'Kapat',
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _buildContent(chatProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ChatProvider chatProvider) {
    switch (_currentMode) {
      case ViewMode.web:
        return HtmlPreviewWidget(
          htmlContent: chatProvider.formattedHtml,
        );

      case ViewMode.chat:
        return Stack(
          children: [
            chatProvider.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'HTML oluşturmaya başlayın',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: chatProvider.messages.length,
                      itemBuilder: (context, index) {
                        return ChatMessageWidget(
                          message: chatProvider.messages[index],
                        );
                      },
                    ),
                  ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: ChatInputWidget(
                  onSend: chatProvider.sendMessage,
                ),
              ),
            ),
          ],
        );

      case ViewMode.code:
        return _buildCodeView(chatProvider);
    }
  }

  Widget _buildCodeView(ChatProvider chatProvider) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              chatProvider.formattedHtml,
              style: const TextStyle(
                fontFamily: 'monospace',
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
                    ClipboardData(text: chatProvider.formattedHtml),
                  );
                  if (mounted) {
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
                    await file.writeAsString(chatProvider.formattedHtml);

                    await Share.shareXFiles(
                      [XFile(file.path)],
                      text: 'HTML Sayfası',
                    );
                  } catch (e) {
                    if (mounted) {
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
}
