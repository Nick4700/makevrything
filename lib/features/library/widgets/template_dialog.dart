import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/html_file.dart';
import '../../../providers/library_provider.dart';

class TemplateDialog extends StatefulWidget {
  const TemplateDialog({super.key});

  @override
  State<TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<TemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  HtmlFile? _selectedTemplate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedTemplate != null) {
        context.read<LibraryProvider>().createFromTemplate(
              _selectedTemplate!,
              _nameController.text,
            );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final templates = context.watch<LibraryProvider>().templates;

    return AlertDialog(
      title: const Text('Şablondan Oluştur'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<HtmlFile>(
              value: _selectedTemplate,
              decoration: const InputDecoration(
                labelText: 'Şablon',
                border: OutlineInputBorder(),
              ),
              items: templates.map((template) {
                return DropdownMenuItem(
                  value: template,
                  child: Text(template.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTemplate = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Lütfen bir şablon seçin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Yeni Dosya Adı',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Dosya adı gerekli';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: templates.isEmpty ? null : _handleCreate,
          child: const Text('Oluştur'),
        ),
      ],
    );
  }
}
