import 'package:floor/floor.dart';
import 'cart.dart';

@dao
abstract class CartDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCart(Cart cart);

  @Query('SELECT * FROM Cart WHERE userId = :userId')
  Future<List<Cart>> getCart(String userId);

  @Query('SELECT totalPrice FROM Cart WHERE userId = :userId')
  Future<double?> getTotalPrice(String userId);

  @Query('UPDATE Cart SET totalPrice = totalPrice + :value WHERE userId = :userId')
  Future<void> addValueToTotalPrice(String userId, double value);

  @Query('DELETE FROM Cart WHERE userId = :userId')
  Future<void> deleteCart(String userId);
}