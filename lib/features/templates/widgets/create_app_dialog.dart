import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/app.dart';
import '../../../providers/app_provider.dart';
import '../../shared/widgets/loading_overlay.dart';
import '../../../core/utils/error_handler.dart';

class CreateAppDialog extends StatefulWidget {
  final String templateId;
  final String htmlContent;

  const CreateAppDialog({
    super.key,
    required this.templateId,
    required this.htmlContent,
  });

  @override
  State<CreateAppDialog> createState() => _CreateAppDialogState();
}

class _CreateAppDialogState extends State<CreateAppDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();

      final app = App(
        id: DateTime.now().toString(),
        name: name,
        htmlContent: widget.htmlContent,
        templateId: widget.templateId,
        createdAt: DateTime.now(),
      );

      try {
        await context.read<AppProvider>().addApp(app);
        if (mounted) {
          Navigator.pop(context);
          ErrorHandler.showSuccess(context, 'Uygulama başarıyla oluşturuldu');
        }
      } catch (e) {
        if (mounted) {
          ErrorHandler.handleError(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Uygulama oluşturuluyor...',
      child: AlertDialog(
        title: const Text('Uygulama Oluştur'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Uygulama Adı',
              border: OutlineInputBorder(),
              hintText: 'Örnek: Kişisel Blog',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Uygulama adı gerekli';
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
            onPressed: isLoading ? null : _handleCreate,
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
  }
}
