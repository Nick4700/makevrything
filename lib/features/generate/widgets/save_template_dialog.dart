import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/template.dart';
import '../../../providers/template_provider.dart';
import '../../shared/widgets/loading_overlay.dart';

class SaveTemplateDialog extends StatefulWidget {
  final String htmlContent;

  const SaveTemplateDialog({
    super.key,
    required this.htmlContent,
  });

  @override
  State<SaveTemplateDialog> createState() => _SaveTemplateDialogState();
}

class _SaveTemplateDialogState extends State<SaveTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();

      final template = Template(
        id: DateTime.now().toString(),
        name: name,
        htmlContent: widget.htmlContent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await context.read<TemplateProvider>().addTemplate(template);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Şablon kaydedildi')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Şablon kaydedilemedi: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TemplateProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Şablon kaydediliyor...',
      child: AlertDialog(
        title: const Text('Şablon Olarak Kaydet'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Şablon Adı',
              border: OutlineInputBorder(),
              hintText: 'Örnek: Ana Sayfa',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Şablon adı gerekli';
              }
              return null;
            },
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
        ),
        actions: [
          TextButton(
            onPressed: isLoading ? null : () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: isLoading ? null : _handleSave,
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
