import 'package:flutter/material.dart';
import 'package:easynema/components/grid_card.dart';
import 'package:easynema/components/loader.dart';
import 'package:easynema/models/product.dart';
import 'package:easynema/view/snack_screens/product.dart';
import 'package:easynema/helpers/firestore.dart';

class HomeScreen extends StatefulWidget {
  final dynamic changer;
  const HomeScreen({Key? key, required this.changer}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Product>>? products;

  @override
  void initState() {
    super.initState();
    products = FirestoreUtil.getProducts([]);
  }

  @override
  Widget build(BuildContext context) {
    onCardPress(Product product) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductScreen(
                    product: product,
                    changer: widget.changer,
                  )));
    }

    return FutureBuilder<List<Product>>(
        future: products,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return GridView.builder(
                itemCount: snapshot.data?.length,
                padding: const EdgeInsets.symmetric(vertical: 30),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 30),
                itemBuilder: (BuildContext context, int index) {
                  return GridCard(
                      product: snapshot.data![index],
                      index: index,
                      onPress: () {
                        onCardPress(snapshot.data![index]);
                      });
                });
          } else {
            return const Center(child: Loader());
          }
        });
  }
}
