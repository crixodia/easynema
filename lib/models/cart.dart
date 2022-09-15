import 'package:json_annotation/json_annotation.dart';
import 'package:easynema/models/product.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart extends Product {
  int count = 0;
  Cart(String title, double price, String id, String description, String image, String category, this.count)
      : super(title, price, id, description, image, category);

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}
