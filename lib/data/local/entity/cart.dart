import 'package:floor/floor.dart';

@entity
class Cart {
  @primaryKey
  final String userId;
  final double totalPrice;

  Cart({
    required this.userId,
    required this.totalPrice,
  });
}