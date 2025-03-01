import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/live_site.dart';
import '../../../providers/live_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class LiveSiteCard extends StatelessWidget {
  final LiveSite site;

  const LiveSiteCard({
    super.key,
    required this.site,
  });

  Future<void> _launchUrl(BuildContext context) async {
    try {
      final url = Uri.parse(site.url);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw Exception('URL açılamıyor');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Site açılırken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _launchUrl(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      site.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: () => _launchUrl(context),
                    tooltip: 'Siteyi aç',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Yayından Kaldır'),
                          content: const Text(
                              'Bu siteyi yayından kaldırmak istediğinize emin misiniz?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('İptal'),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<LiveProvider>()
                                    .unpublishSite(site.id);
                                Navigator.pop(context);
                              },
                              child: const Text('Kaldır'),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: 'Yayından kaldır',
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Yayın tarihi: ${timeago.format(site.createdAt, locale: 'tr')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'URL: ${site.url}',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
