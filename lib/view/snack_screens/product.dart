import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easynema/components/custom_button.dart';
import 'package:easynema/models/product.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widgets/Widgets.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  final dynamic changer;
  const ProductScreen({Key? key, required this.product, required this.changer})
      : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff21242C),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.product.image,
                        ),
                      ),
                      Positioned(
                        top: 35,
                        right: 35,
                        child: Container(
                          decoration: const ShapeDecoration(
                            color: Colors.amber,
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headlineLarge!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 22),
                            child: TextBrand(
                              text: widget.product.title,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                TextBrand(
                                  text: "Precio: \$${widget.product.price}",
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextBrand(
                              text: "Descripción",
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: TextBrand(
                              text: widget.product.description,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: "Añadir a carro de compra",
                            onPress: () => {
                              // Flutter toast show
                              Fluttertoast.showToast(
                                msg: "Producto añadido al carro de compra",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              ),
                              widget.changer(widget.product),
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                top: 5,
                left: 2,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
