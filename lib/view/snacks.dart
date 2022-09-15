import 'package:easynema/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:easynema/view/snack_screens/checkout.dart';
import 'package:easynema/view/snack_screens/home.dart';

import '../models/product.dart';

class Snacks extends StatefulWidget {
  final String title;
  final UserModel userModel;

  const Snacks({Key? key, required this.title, required this.userModel})
      : super(key: key);

  @override
  State<Snacks> createState() => _SnacksState(userModel);
}

class _SnacksState extends State<Snacks> {
  UserModel userModel;
  _SnacksState(this.userModel) {
    userModel = userModel;
  }

  Map<Product, int>? productQuantities = {};
  CheckoutScreen cs = CheckoutScreen(
    products: const [],
    quantities: const [],
    userModel: UserModel(),
  );

  void addProduct(Product product) {
    setState(() {
      if (!productQuantities!.containsKey(product)) {
        productQuantities![product] = 1;
      } else {
        productQuantities![product] = productQuantities![product]! + 1;
      }

      cs = CheckoutScreen(
        products: productQuantities!.keys.toList(),
        quantities: productQuantities!.values.toList(),
        userModel: userModel,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xff21242C),
        appBar: AppBar(
          title: const Text("Easynema Snacks"),
          elevation: 0,
          backgroundColor: const Color(0xff21242C),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xff21242C),
          ),
          child: const TabBar(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              indicatorColor: Colors.amber,
              tabs: [
                Tab(icon: Icon(Icons.add_business)),
                Tab(icon: Icon(Icons.shopping_cart)),
              ]),
        ),
        body: TabBarView(
          children: [
            HomeScreen(changer: addProduct),
            cs,
          ],
        ),
      ),
    );
  }
}
