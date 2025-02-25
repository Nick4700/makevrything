import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/library_provider.dart';
import '../widgets/html_file_card.dart';
import '../screens/edit_file_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kütüphane'),
      ),
      body: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, _) {
          if (libraryProvider.files.isEmpty) {
            return const Center(
              child: Text('Henüz kaydedilmiş dosya yok'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: libraryProvider.files.length,
            itemBuilder: (context, index) {
              final file = libraryProvider.files[index];
              return HtmlFileCard(
                file: file,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditFileScreen(file: file),
                    ),
                  );
                },
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Dosyayı Sil'),
                      content: const Text(
                        'Bu dosyayı silmek istediğinize emin misiniz?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('İptal'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<LibraryProvider>().deleteFile(file.id);
                            Navigator.pop(context);
                          },
                          child: const Text('Sil'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditFileScreen(
                file: null, // Yeni dosya oluştur
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
