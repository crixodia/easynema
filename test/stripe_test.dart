import 'package:flutter_test/flutter_test.dart';

import 'package:easynema/controllers/stripe_api.dart';

void main() {
  List<Stripe> checkoutSessionIds = [];
  test('Testing Stripe createCheckoutSession (2)', () async {
    const List<String> productNames = ['Product 1', 'Product 2'];
    const List<double> prices = [1.5, 2.5];
    const List<int> quantities = [1, 2];
    Stripe? stripe = await Stripe.createCheckoutSession(
        productNames: productNames, prices: prices, quantities: quantities);
    checkoutSessionIds.add(stripe!);
    expect(stripe.checkoutSessionId, isNotNull);
    expect(stripe.checkoutUrl, isNotNull);
  });

  test('Testing Stripe createCheckoutSession (1)', () async {
    const List<String> productNames = ['Product 1'];
    const List<double> prices = [1.5];
    const List<int> quantities = [1];
    Stripe? stripe = await Stripe.createCheckoutSession(
        productNames: productNames, prices: prices, quantities: quantities);
    checkoutSessionIds.add(stripe!);
    expect(stripe.checkoutSessionId, isNotNull);
    expect(stripe.checkoutUrl, isNotNull);
  });

  test('Testing Stripe status (open)', () async {
    for (Stripe stripe in checkoutSessionIds) {
      String? status = await Stripe.retrieveStatus(stripe.checkoutSessionId);
      expect(status, equals('open'));
    }
  });

  test('Testing Stripe status (complete)', () async {
    expect(
        await Stripe.retrieveStatus(
            'cs_test_a145ljl7iyCSilEP1IBvmajbi1pgvGiODi8D5gOh892G00fmn966D2JBV7'),
        equals('complete'));
    expect(await Stripe.retrieveStatus('holamundoxduwu'), isNull);
  });

  test('Testing Stripe status (expired)', () async {
    expect(
        await Stripe.retrieveStatus(
            'cs_test_a1XXjXHiV6uwEviu58qN1ZIFVSkziHzkQtWKxADDABkUjbmsfH33p5xlCJ'),
        equals('expired'));
    expect(await Stripe.retrieveStatus('holamundoxd'), isNull);
  });
}
