import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:provider/provider.dart';
import '../../../providers/chat_provider.dart';

class CodeEditorWidget extends StatefulWidget {
  const CodeEditorWidget({super.key});

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late final CodeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CodeController(
      text: context.read<ChatProvider>().formattedHtml,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.format_align_left),
              onPressed: () {
                // HTML formatla
                final formatted = _controller.text.replaceAll('><', '>\n<');
                _controller.text = formatted;
              },
              tooltip: 'Formatla',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                context.read<ChatProvider>().updateHtml(_controller.text);
                Navigator.pop(context);
              },
              tooltip: 'Kaydet',
            ),
          ],
        ),
        Expanded(
          child: CodeField(
            controller: _controller,
            textStyle: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }
}
