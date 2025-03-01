import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/chat_provider.dart';
import '../widgets/chat_input_widget.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/html_preview_widget.dart';
import '../../../core/services/health_service.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/ai_service.dart';
import '../widgets/code_editor_widget.dart';
import '../../../core/enums/view_mode.dart';

class HomeScreen extends StatefulWidget {
  final ViewMode viewMode;

  const HomeScreen({
    Key? key,
    this.viewMode = ViewMode.web,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HealthService _healthService;
  bool _isConnected = false;
  bool _showChat = true;

  @override
  void initState() {
    super.initState();
    _healthService = HealthService(AIService());
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    final isConnected = await _healthService.checkConnection();
    setState(() {
      _isConnected = isConnected;
    });

    if (!isConnected && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sunucuya bağlanılamadı!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showEditor(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: const CodeEditorWidget(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Everything'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _checkConnection,
            ),
          ],
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Sunucuya bağlanılamadı'),
              SizedBox(height: 8),
              Text('Lütfen bağlantınızı kontrol edin'),
            ],
          ),
        ),
      );
    }

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) => Scaffold(
        appBar: AppBar(
          leading: const CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.person_outline),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              const Text('everything'),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.library_books_outlined),
              onPressed: () => context.go('/library'),
              tooltip: 'Kütüphane',
            ),
            IconButton(
              icon: const Icon(Icons.code),
              onPressed: () => _showEditor(context),
              tooltip: 'HTML Düzenle',
            ),
          ],
        ),
        body: Column(
          children: [
            if (chatProvider.isLoading) const LinearProgressIndicator(),
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
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _showChat
                  ? Column(
                      children: [
                        Expanded(
                          child: chatProvider.messages.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_outlined,
                                        size: 48,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'HTML oluşturmaya başlayın',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: chatProvider.messages.length,
                                  itemBuilder: (context, index) {
                                    return ChatMessageWidget(
                                      message: chatProvider.messages[index],
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ChatInputWidget(
                            onSend: chatProvider.sendMessage,
                          ),
                        ),
                      ],
                    )
                  : HtmlPreviewWidget(
                      htmlContent: chatProvider.currentHtml,
                      viewMode: widget.viewMode,
                    ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(Icons.chat),
              label: 'Sohbet',
            ),
            NavigationDestination(
              icon: Icon(Icons.preview_outlined),
              selectedIcon: Icon(Icons.preview),
              label: 'Önizleme',
            ),
          ],
          selectedIndex: _showChat ? 0 : 1,
          onDestinationSelected: (index) {
            setState(() {
              _showChat = index == 0;
            });
          },
        ),
      ),
    );
  }
}
