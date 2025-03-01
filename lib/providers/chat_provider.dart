import 'package:flutter/material.dart';
import '../core/models/chat_message.dart';
import '../core/services/ai_service.dart';
import '../core/utils/error_handler.dart';
import '../core/models/template.dart';

class ChatProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  final List<ChatMessage> _messages = [];
  String _currentHtml = '<h1>Hoş Geldiniz</h1>';
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  String get currentHtml => _currentHtml;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    notifyListeners();

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final messages = _messages
          .map((msg) => {
                'content': msg.content,
                'isUser': msg.isUser,
              })
          .toList();

      final html = await _aiService.generateHtmlResponse(messages);
      _currentHtml = html;
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _currentHtml = '<h1>Hoş Geldiniz</h1>';
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void loadHtmlFile(String content) {
    _currentHtml = content;
    _messages.clear();
    notifyListeners();
  }

  void updateHtml(String newHtml) {
    _currentHtml = newHtml;
    notifyListeners();
  }

  void clearHtml() {
    _currentHtml = '<h1>Hoş Geldiniz</h1>';
    notifyListeners();
  }

  String get formattedHtml {
    if (!_currentHtml.contains('<body>')) {
      return '''
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Everything</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    $_currentHtml
</body>
</html>''';
    }
    return _currentHtml;
  }

  void loadTemplate(Template template) {
    _currentHtml = template.htmlContent;
    _messages.add(
      ChatMessage(
        id: DateTime.now().toString(),
        content: 'Şablon yüklendi: ${template.name}',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
