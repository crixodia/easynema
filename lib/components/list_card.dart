import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/Widgets.dart';

class ListCard extends StatelessWidget {
  final int cantidad;
  final Product product;
  const ListCard({Key? key, required this.cantidad, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                flex: 6,
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: TextBrand(
                            text: product.title,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: TextBrand(
                            text: "Cantidad: $cantidad", fontSize: 14),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: TextBrand(
                            text:
                                "\$${(product.price * cantidad).toStringAsFixed(2)}",
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
