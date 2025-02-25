import 'package:flutter/material.dart';
import '../../../core/models/chat_message.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool compact; // Kompakt görünüm için

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.compact = false, // Varsayılan olarak normal görünüm
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return ListTile(
        leading: Icon(
          message.isUser ? Icons.person_outline : Icons.smart_toy_outlined,
          color: message.isUser
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          message.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          timeago.format(message.timestamp, locale: 'tr'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: message.isUser
                ? Colors.transparent
                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              message.isUser ? Icons.person_outline : Icons.smart_toy_outlined,
              color: message.isUser
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.isUser ? 'Sen' : 'AI',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
