import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/html_file.dart';
import '../../../providers/library_provider.dart';
import '../../home/widgets/html_preview_widget.dart';
import '../../../core/enums/view_mode.dart';

class EditFileScreen extends StatefulWidget {
  final HtmlFile? file;
  final ViewMode viewMode;

  const EditFileScreen({
    super.key,
    this.file,
    this.viewMode = ViewMode.web,
  });

  @override
  State<EditFileScreen> createState() => _EditFileScreenState();
}

class _EditFileScreenState extends State<EditFileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _contentController;
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.file?.name ?? '');
    _contentController =
        TextEditingController(text: widget.file?.content ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveFile() {
    final name = _nameController.text.trim();
    final content = _contentController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dosya adı gerekli')),
      );
      return;
    }

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İçerik boş olamaz')),
      );
      return;
    }

    final file = HtmlFile(
      id: widget.file?.id ?? DateTime.now().toString(),
      name: name,
      content: content,
      createdAt: widget.file?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      isTemplate: widget.file?.isTemplate ?? false,
    );

    if (widget.file != null) {
      context.read<LibraryProvider>().updateFile(file);
    } else {
      context.read<LibraryProvider>().addFile(file);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file != null ? 'Dosyayı Düzenle' : 'Yeni Dosya'),
        actions: [
          IconButton(
            icon: Icon(_isPreviewMode ? Icons.edit : Icons.preview),
            onPressed: () {
              setState(() {
                _isPreviewMode = !_isPreviewMode;
              });
            },
            tooltip: _isPreviewMode ? 'Düzenle' : 'Önizle',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveFile,
            tooltip: 'Kaydet',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Dosya Adı',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isPreviewMode
                ? HtmlPreviewWidget(
                    htmlContent: _contentController.text,
                    viewMode: widget.viewMode,
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        labelText: 'HTML İçeriği',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
