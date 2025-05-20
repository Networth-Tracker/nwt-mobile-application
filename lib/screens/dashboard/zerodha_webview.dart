import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/utils/logger.dart';

class ZerodhaWebView extends StatefulWidget {
  final String url;
  final String title;

  const ZerodhaWebView({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<ZerodhaWebView> createState() => _ZerodhaWebViewState();
}

class _ZerodhaWebViewState extends State<ZerodhaWebView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  double progress = 0;
  bool isLoading = true;
  String currentUrl = '';
  
  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: AppColors.lightPrimary,
      ),
      onRefresh: () async {
        if (webViewController != null) {
          webViewController!.reload();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(Uri.decodeFull(widget.url))),
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              javaScriptEnabled: true,
              cacheEnabled: true,
              useHybridComposition: true, // Use hybrid composition for better stability
              allowsInlineMediaPlayback: true,
              verticalScrollBarEnabled: true,
              horizontalScrollBarEnabled: true,
              transparentBackground: true,
              supportZoom: true,
              userAgent: 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36',
            ),
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) {
              webViewController = controller;
              AppLogger.info('ZerodhaWebView - WebView created');
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
                currentUrl = url.toString();
              });
              AppLogger.info('ZerodhaWebView - Load started: $url');
            },
            onLoadStop: (controller, url) async {
              pullToRefreshController?.endRefreshing();
              setState(() {
                isLoading = false;
                currentUrl = url.toString();
              });
              AppLogger.info('ZerodhaWebView - Load stopped: $url');
              
              // Check if page loaded successfully
              String contentCheckScript = """
                (function() {
                  return {
                    title: document.title,
                    bodyContent: document.body ? document.body.innerHTML.length : 0,
                    hasForm: document.forms.length > 0
                  };
                })();
              """;
              var result = await controller.evaluateJavascript(source: contentCheckScript);
              AppLogger.info('ZerodhaWebView - Page content check: $result');
            },
            onLoadError: (controller, url, code, message) {
              pullToRefreshController?.endRefreshing();
              setState(() {
                isLoading = false;
              });
              AppLogger.error('ZerodhaWebView - Load error: $code, $message');
              
              Get.snackbar(
                'Error',
                'Failed to load page: $message',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.1),
                colorText: Colors.red,
              );
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url;
              AppLogger.info('ZerodhaWebView - Navigation to: $uri');
              
              // Handle redirects to your app's callback URL
              if (uri.toString().contains('lab.networthtracker.in/api/v1/zerodha/redirection')) {
                AppLogger.info('ZerodhaWebView - Detected redirection callback');
                // Here you can handle the callback, extract tokens, etc.
                // For now, just log it
              }
              
              return NavigationActionPolicy.ALLOW;
            },
            onConsoleMessage: (controller, consoleMessage) {
              AppLogger.info('ZerodhaWebView - Console: ${consoleMessage.message}');
            },
          ),
          if (isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress > 0 ? progress : null,
                    color: AppColors.lightPrimary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Loading... ${(progress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}