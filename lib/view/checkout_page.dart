import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/stripe_api.dart';

class CheckoutPage extends StatefulWidget {
  final Stripe? stripe;
  const CheckoutPage({Key? key, required this.stripe}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: WebView(
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) => _controller = controller,
          onPageFinished: (String url) {
            if (url == initialUrl) {
              // Redirects controller to stripe.url
              _controller.loadUrl(widget.stripe!.checkoutUrl);
            }
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith(Stripe.successUrl)) {
              Navigator.of(context).pop('success');
            } else if (request.url.startsWith(Stripe.cancelUrl)) {
              Navigator.of(context).pop('cancel');
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  String get initialUrl =>
      'data:text/html;base64,${base64Encode(const Utf8Encoder().convert(kStripeHtmlPage))}';
}

const kStripeHtmlPage = '''
<!DOCTYPE html>
<html lang="en">
</html>
''';
