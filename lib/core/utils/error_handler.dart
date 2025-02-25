import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: action ??
            SnackBarAction(
              label: 'Tamam',
              textColor: Theme.of(context).colorScheme.onError,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }

  static String _localizeError(String message) {
    // API hatalarını Türkçeleştir
    switch (message) {
      case 'Network connection failed':
        return 'İnternet bağlantısı başarısız';
      case 'Request timeout':
        return 'İstek zaman aşımına uğradı';
      case 'Server error':
        return 'Sunucu hatası';
      case 'Invalid response':
        return 'Geçersiz yanıt';
      default:
        return message;
    }
  }

  static void handleError(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    final message = getErrorMessage(error);
    showError(
      context,
      message,
      action: onRetry != null
          ? SnackBarAction(
              label: 'Tekrar Dene',
              onPressed: onRetry,
              textColor: Theme.of(context).colorScheme.onError,
            )
          : null,
    );
  }
}
