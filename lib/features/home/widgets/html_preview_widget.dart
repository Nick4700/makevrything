import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/app_provider.dart';
import 'package:go_router/go_router.dart';

class HtmlPreviewWidget extends StatefulWidget {
  final String htmlContent;
  final String? appId;

  const HtmlPreviewWidget({
    super.key,
    required this.htmlContent,
    this.appId,
  });

  @override
  State<HtmlPreviewWidget> createState() => _HtmlPreviewWidgetState();
}

class _HtmlPreviewWidgetState extends State<HtmlPreviewWidget> {
  late final WebViewController _controller;
  double _scale = 1.0;
  DeviceType _deviceType = DeviceType.mobile;
  bool _isFullScreen = false;
  bool _showControls = false;
  final _draggableKey = GlobalKey();
  Offset _settingsButtonPosition = const Offset(16, 16);
  Offset _fullscreenButtonPosition = const Offset(16, 16);

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(widget.htmlContent);
  }

  @override
  void didUpdateWidget(HtmlPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.htmlContent != oldWidget.htmlContent) {
      _controller.loadHtmlString(widget.htmlContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
            Positioned(
              left: _fullscreenButtonPosition.dx,
              top: _fullscreenButtonPosition.dy,
              child: Draggable(
                feedback: _buildFloatingButton(
                  icon: Icons.fullscreen_exit,
                  tooltip: 'Tam Ekrandan Çık',
                ),
                childWhenDragging: const SizedBox(),
                onDragEnd: (details) {
                  setState(() {
                    _fullscreenButtonPosition = details.offset;
                  });
                },
                child: _buildFloatingButton(
                  icon: Icons.fullscreen_exit,
                  tooltip: 'Tam Ekrandan Çık',
                  onPressed: () => setState(() => _isFullScreen = false),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Web önizleme
        Center(
          child: Container(
            width: _getScaledWidth(),
            height: _getScaledHeight(),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: WebViewWidget(
              controller: _controller,
            ),
          ),
        ),
        // Kayan butonlar
        Positioned(
          left: _settingsButtonPosition.dx,
          top: _settingsButtonPosition.dy,
          child: Column(
            children: [
              // Geri butonu
              if (widget.appId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildFloatingButton(
                    icon: Icons.arrow_back,
                    tooltip: 'Uygulamalara Dön',
                    onPressed: () => context.go('/apps'),
                  ),
                ),
              // Kaydet butonu
              if (widget.appId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildFloatingButton(
                    icon: Icons.save,
                    tooltip: 'Değişiklikleri Kaydet',
                    onPressed: () async {
                      try {
                        final html =
                            await _controller.runJavaScriptReturningResult(
                          'document.documentElement.outerHTML',
                        ) as String;
                        print(html);
                        final decodedHtml =
                            jsonDecode('$html'); // Çift tırnaklar ekleyin

                        final fullHtml = decodedHtml.toString();
                        print(fullHtml);
                        print("***");
                        print(html);
                        if (fullHtml != widget.htmlContent) {
                          Provider.of<AppProvider>(context, listen: false)
                              .updateAppHtml(widget.appId!, fullHtml);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Değişiklikler kaydedildi'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Kaydetme hatası: $e'),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ),
              // Ayarlar butonu
              Draggable(
                key: _draggableKey,
                feedback: _buildFloatingButton(
                  icon: Icons.settings,
                  tooltip: 'Ayarlar',
                ),
                childWhenDragging: const SizedBox(),
                onDragEnd: (details) {
                  setState(() {
                    _settingsButtonPosition = details.offset;
                  });
                },
                child: _buildFloatingButton(
                  icon: Icons.settings,
                  tooltip: 'Ayarlar',
                  onPressed: () {
                    setState(() => _showControls = !_showControls);
                  },
                ),
              ),
            ],
          ),
        ),
        // Kontrol paneli
        if (_showControls)
          Positioned(
            right: 16,
            top: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Başlık ve kapat butonu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Görünüm Ayarları'),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() => _showControls = false);
                          },
                          tooltip: 'Kapat',
                        ),
                      ],
                    ),
                    const Divider(),
                    // Cihaz seçimi
                    SegmentedButton<DeviceType>(
                      selected: {_deviceType},
                      onSelectionChanged: (value) {
                        setState(() => _deviceType = value.first);
                      },
                      segments: const [
                        ButtonSegment(
                          value: DeviceType.mobile,
                          icon: Icon(Icons.smartphone),
                          tooltip: 'Mobil',
                        ),
                        ButtonSegment(
                          value: DeviceType.tablet,
                          icon: Icon(Icons.tablet),
                          tooltip: 'Tablet',
                        ),
                        ButtonSegment(
                          value: DeviceType.desktop,
                          icon: Icon(Icons.desktop_windows),
                          tooltip: 'Masaüstü',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Zoom kontrolü
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _scale > 0.5
                              ? () => setState(() => _scale -= 0.1)
                              : null,
                          tooltip: 'Küçült',
                        ),
                        Text('${(_scale * 100).round()}%'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _scale < 2.0
                              ? () => setState(() => _scale += 0.1)
                              : null,
                          tooltip: 'Büyüt',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Diğer butonlar
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            setState(() {}); // WebView'i yenile
                          },
                          tooltip: 'Yenile',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Son buton olarak tam ekran
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _isFullScreen = true;
                          _showControls = false;
                        });
                      },
                      icon: const Icon(Icons.fullscreen),
                      label: const Text('Tam Ekran'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required String tooltip,
    VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: const CircleBorder(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          tooltip: tooltip,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  double _getDeviceWidth() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    switch (_deviceType) {
      case DeviceType.mobile:
        return isLandscape ? 667 : 375;
      case DeviceType.tablet:
        return isLandscape ? 1194 : 834;
      case DeviceType.desktop:
        return isLandscape ? 1920 : 1080;
    }
  }

  double _getDeviceHeight() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    switch (_deviceType) {
      case DeviceType.mobile:
        return isLandscape ? 375 : 667;
      case DeviceType.tablet:
        return isLandscape ? 834 : 1194;
      case DeviceType.desktop:
        return isLandscape ? 1080 : 1920;
    }
  }

  double _getScaledWidth() {
    final deviceWidth = _getDeviceWidth();
    final availableWidth = MediaQuery.of(context).size.width - 32;
    final scale = availableWidth / deviceWidth;
    return deviceWidth * (scale < 1 ? scale : 1) * _scale;
  }

  double _getScaledHeight() {
    final deviceHeight = _getDeviceHeight();
    final availableHeight = MediaQuery.of(context).size.height - 32;
    final scale = availableHeight / deviceHeight;
    return deviceHeight * (scale < 1 ? scale : 1) * _scale;
  }
}

enum DeviceType { mobile, tablet, desktop }
