import 'dart:convert';

import 'package:http/http.dart' as http;

const String apiKey =
    'sk_test_51LbVoBJrseIV1MmSYSVZBXU1m9h5';

class Stripe {
  final String checkoutSessionId;
  final String checkoutUrl;

  static String baseUrl = 'https://api.stripe.com//v1/checkout/sessions';
  static String cancelUrl = 'https://www.cancel.com';
  static String successUrl = 'https://www.success.com';

  Stripe(this.checkoutSessionId, this.checkoutUrl);

  static Future<Stripe?> createCheckoutSession(
      {required List<String> productNames,
      required List<double> prices,
      required List<int> quantities}) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $apiKey',
    };

    var request = http.Request('POST', Uri.parse(baseUrl));

    Map<String, String> temp = {
      'cancel_url': cancelUrl,
      'success_url': successUrl,
    };
    for (int i = 0; i < productNames.length; i++) {
      temp.addAll({'line_items[$i][price_data][currency]': 'usd'});
      temp.addAll(
          {'line_items[$i][price_data][product_data][name]': productNames[i]});
      temp.addAll({
        'line_items[$i][price_data][unit_amount]':
            (prices[i] * 100).toInt().toString()
      });
      temp.addAll({'line_items[$i][quantity]': quantities[i].toString()});
    }
    temp.addAll({'mode': 'payment', 'payment_method_types[0]': 'card'});

    request.bodyFields = temp;

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return Stripe.fromJson(
          json.decode(await response.stream.bytesToString()));
    }
    return null;
  }

  factory Stripe.fromJson(Map<String, dynamic> json) {
    return Stripe(json['id'], json['url']);
  }

  static Future<String?> retrieveStatus(String sessionId) async {
    // complete, open, expired
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $apiKey'
    };
    var request = http.Request('GET', Uri.parse('$baseUrl/$sessionId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())['status'];
    }
    return null;
  }

  // Just in Case we need to cancel the checkout session
  void expireSession() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $apiKey'
    };
    var request =
        http.Request('POST', Uri.parse('$baseUrl/$checkoutSessionId/expire'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
