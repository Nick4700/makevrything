import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/library_provider.dart';
import '../../../providers/chat_provider.dart';

class SaveFileDialog extends StatefulWidget {
  const SaveFileDialog({super.key});

  @override
  State<SaveFileDialog> createState() => _SaveFileDialogState();
}

class _SaveFileDialogState extends State<SaveFileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final content = context.read<ChatProvider>().currentHtml;

      context.read<LibraryProvider>().saveCurrentHtml(name, content);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('HTML Dosyasını Kaydet'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Dosya Adı',
            hintText: 'Örnek: Ana Sayfa',
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Dosya adı gerekli';
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
          onPressed: _handleSave,
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
