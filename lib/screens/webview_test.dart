import 'package:flutter/material.dart';
import 'package:nwt_app/screens/example/inappwebview.dart';

class WebViewTestScreen extends StatefulWidget {
  const WebViewTestScreen({super.key});

  @override
  State<WebViewTestScreen> createState() => _WebViewTestScreenState();
}

class _WebViewTestScreenState extends State<WebViewTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: InAppWebViewExample(
          url: 'https://pub.dev/packages/flutter_inappwebview/example',
          title: 'Flutter InAppWebView Example',
        ),
      ),
    );
  }
}