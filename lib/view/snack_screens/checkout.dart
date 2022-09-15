import 'package:easynema/models/product.dart';
import 'package:easynema/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:easynema/components/custom_button.dart';
import 'package:easynema/components/list_card.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../controllers/stripe_api.dart';
import '../../models/invoice_model_snack.dart';
import '../checkout_page.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Product> products;
  final List<int> quantities;
  final UserModel userModel;

  const CheckoutScreen(
      {Key? key,
      required this.products,
      required this.quantities,
      required this.userModel})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() =>
      _CheckoutScreenState(products, quantities, userModel);
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<Product> products;
  List<int> quantities;
  UserModel userModel;

  _CheckoutScreenState(this.products, this.quantities, this.userModel) {
    products = products;
    quantities = quantities;
    userModel = userModel;
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (int i = 0; i < products.length; i++) {
      total += products[i].price * quantities[i];
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 30),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ListCard(
                product: products[index],
                cantidad: quantities[index],
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: CustomButton(
              text: "Pagar \$${total.toStringAsFixed(2)}",
              onPress: () async {
                if (products.isNotEmpty) {
                  Stripe? stripe = await Stripe.createCheckoutSession(
                      prices: products.map((product) => product.price).toList(),
                      productNames:
                          products.map((product) => product.title).toList(),
                      quantities: quantities);

                  // ignore: use_build_context_synchronously
                  final resultCheckout = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        stripe: stripe,
                      ),
                    ),
                  );

                  if (resultCheckout == 'success') {
                    // ignore: use_build_context_synchronously
                    InvoiceModelSnack ims = InvoiceModelSnack(
                        date: TimeOfDay.now().toString(),
                        productos: products,
                        cantidades: quantities,
                        total: total,
                        to: [userModel.email!],
                        qrData: """DATE: ${DateTime.now().toString()}
                            PRODUCTS: ${products.map((product) => product.title).toList().join(', ')}
                            PRICES: ${products.map((product) => product.price.toString()).toList().join(', ')}
                            QUATITIES: ${quantities.join(', ')}""");
                    ims.createInvoice();

                    Fluttertoast.showToast(
                        msg: "Pago exitoso",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Se ha cancelado la compra",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "No hay productos para comprar",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              loading: false,
            ),
          )
        ],
      ),
    );
  }
}
