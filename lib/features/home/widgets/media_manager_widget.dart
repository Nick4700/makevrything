import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/chat_provider.dart';
import 'dart:convert';

class MediaManagerWidget extends StatelessWidget {
  const MediaManagerWidget({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final imgTag =
          '<img src="data:image/png;base64,$base64Image" alt="Seçilen resim" style="max-width: 100%;">';

      context.read<ChatProvider>().insertHtmlElement(imgTag);
    }
  }

  Future<void> _embedVideo(BuildContext context) async {
    final url = await showDialog<String>(
      context: context,
      builder: (context) => VideoUrlDialog(),
    );

    if (url != null && url.isNotEmpty) {
      final videoTag = '''
      <iframe 
        width="560" 
        height="315" 
        src="$url" 
        frameborder="0" 
        allowfullscreen>
      </iframe>''';

      context.read<ChatProvider>().insertHtmlElement(videoTag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medya Ekle', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Resim Ekle'),
            onTap: () => _pickImage(context),
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Video Ekle'),
            onTap: () => _embedVideo(context),
          ),
        ],
      ),
    );
  }
}

class VideoUrlDialog extends StatelessWidget {
  final _controller = TextEditingController();

  VideoUrlDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Video URL'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'YouTube veya Vimeo URL',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
