import 'package:floor/floor.dart';
import 'product.dart';

@dao
abstract class ProductDao {
  @insert
  Future<void> insertProduct(Product product);

  @Query('SELECT * FROM Product WHERE userId = :userId')
  Future<List<Product>> getProducts(String userId);

  @Query('SELECT * FROM Product WHERE id = :productId AND userId = :userId')
  Future<List<Product>> getProductById(String productId, String userId);

  @Query('UPDATE Product SET units = units + :value WHERE id = :productId AND userId = :userId')
  Future<void> addValueToProductUnits(String productId, String userId, int value);

  @Query('DELETE FROM Product WHERE id = :productId AND userId = :userId')
  Future<void> deleteById(String productId, String userId);

  @Query('DELETE FROM Product WHERE userId = :userId')
  Future<void> deleteProductsList(String userId);
}