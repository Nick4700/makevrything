import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/live_provider.dart';
import '../../../providers/chat_provider.dart';

class PublishDialog extends StatefulWidget {
  const PublishDialog({super.key});

  @override
  State<PublishDialog> createState() => _PublishDialogState();
}

class _PublishDialogState extends State<PublishDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handlePublish() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final content = context.read<ChatProvider>().currentHtml;

      context.read<LiveProvider>().publishSite(name, content);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Siteyi Yayınla'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Site Adı',
            hintText: 'Örnek: Kişisel Blog',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Site adı gerekli';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _handlePublish,
          child: const Text('Yayınla'),
        ),
      ],
    );
  }
}
