import 'package:floor/floor.dart';

@entity
class Product {
  @primaryKey
  final String id;
  @primaryKey
  final String userId;
  final String name;
  final double priceKg;
  final double price;
  final String quantity;
  late final int units;
  final String image;
  final double discount;

  Product({
    required this.id,
    required this.userId,
    required this.name,
    required this.priceKg,
    required this.price,
    required this.quantity,
    this.units = 1,
    required this.image,
    this.discount = 0.0,
  });

  Product copyWith({
    String? id,
    String? userId,
    String? name,
    double? priceKg,
    double? price,
    String? quantity,
    int? units,
    String? image,
    double? discount,
  }) {
    return Product(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      priceKg: priceKg ?? this.priceKg,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      units: units ?? this.units,
      image: image ?? this.image,
      discount: discount ?? this.discount,
    );
  }
}