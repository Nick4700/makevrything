import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/live_provider.dart';
import '../widgets/live_site_card.dart';
import '../widgets/publish_dialog.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Siteler'),
      ),
      body: Consumer<LiveProvider>(
        builder: (context, liveProvider, _) {
          if (liveProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (liveProvider.error != null) {
            return Center(
              child: Text(
                liveProvider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (liveProvider.sites.isEmpty) {
            return const Center(
              child: Text('Henüz yayında site yok'),
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
            itemCount: liveProvider.sites.length,
            itemBuilder: (context, index) {
              final site = liveProvider.sites[index];
              return LiveSiteCard(site: site);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const PublishDialog(),
          );
        },
        child: const Icon(Icons.publish),
      ),
    );
  }
}
