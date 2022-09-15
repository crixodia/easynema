// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      json['title'] as String,
      (json['price'] as num).toDouble(),
      json['id'] as String,
      json['description'] as String,
      json['image'] as String,
      json['category'] as String? ?? '',
      json['count'] as int,
    );
