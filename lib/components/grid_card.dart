import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easynema/models/product.dart';

import '../widgets/Widgets.dart';

class GridCard extends StatelessWidget {
  final int index;
  final void Function() onPress;
  final Product product;
  const GridCard(
      {Key? key,
      required this.product,
      required this.index,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: index % 2 == 0
          ? const EdgeInsets.only(left: 22)
          : const EdgeInsets.only(right: 22),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: onPress,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              Expanded(
                  flex: 7,
                  child: SizedBox(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextBrand(
                          text: product.title,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextBrand(
                          text: "\$${product.price.toStringAsFixed(2)}",
                          color: Colors.black,
                          textAlign: TextAlign.center,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ]),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
