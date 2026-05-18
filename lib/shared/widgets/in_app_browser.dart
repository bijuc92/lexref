import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/theme/app_colors.dart';
import 'offline_banner.dart';

class InAppBrowser extends ConsumerStatefulWidget {
  final String url;
  final String title;

  const InAppBrowser({super.key, required this.url, required this.title});

  @override
  ConsumerState<InAppBrowser> createState() => _InAppBrowserState();
}

class _InAppBrowserState extends ConsumerState<InAppBrowser> {
  late final WebViewController _controller;
  bool _isLoading = true;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => setState(() => _loadingProgress = p),
        onPageStarted: (_) => setState(() => _isLoading = true),
        onPageFinished: (_) => setState(() => _isLoading = false),
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Open in browser',
            onPressed: () async {
              final uri = Uri.parse(widget.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
        bottom: _isLoading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _loadingProgress < 100 ? _loadingProgress / 100 : null,
                  backgroundColor: Colors.transparent,
                  color: AppColors.primary,
                ),
              )
            : null,
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: WebViewWidget(
              controller: _controller,
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
    );
  }
}
