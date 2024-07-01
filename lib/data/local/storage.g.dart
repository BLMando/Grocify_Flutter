// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CartDao? _cartDaoInstance;

  ProductDao? _productDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Cart` (`userId` TEXT NOT NULL, `totalPrice` REAL NOT NULL, PRIMARY KEY (`userId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Product` (`id` TEXT NOT NULL, `userId` TEXT NOT NULL, `name` TEXT NOT NULL, `priceKg` REAL NOT NULL, `price` REAL NOT NULL, `quantity` TEXT NOT NULL, `units` INTEGER NOT NULL, `image` TEXT NOT NULL, `discount` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CartDao get cartDao {
    return _cartDaoInstance ??= _$CartDao(database, changeListener);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }
}

class _$CartDao extends CartDao {
  _$CartDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _cartInsertionAdapter = InsertionAdapter(
            database,
            'Cart',
            (Cart item) => <String, Object?>{
                  'userId': item.userId,
                  'totalPrice': item.totalPrice
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Cart> _cartInsertionAdapter;

  @override
  Future<List<Cart>> getCart(String userId) async {
    return _queryAdapter.queryList('SELECT * FROM Cart WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Cart(
            userId: row['userId'] as String,
            totalPrice: row['totalPrice'] as double),
        arguments: [userId]);
  }

  @override
  Future<double?> getTotalPrice(String userId) async {
    return _queryAdapter.query('SELECT totalPrice FROM Cart WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<void> addValueToTotalPrice(
    String userId,
    double value,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Cart SET totalPrice = totalPrice + ?2 WHERE userId = ?1',
        arguments: [userId, value]);
  }

  @override
  Future<void> deleteCart(String userId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Cart WHERE userId = ?1',
        arguments: [userId]);
  }

  @override
  Future<void> insertCart(Cart cart) async {
    await _cartInsertionAdapter.insert(cart, OnConflictStrategy.replace);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productInsertionAdapter = InsertionAdapter(
            database,
            'Product',
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'name': item.name,
                  'priceKg': item.priceKg,
                  'price': item.price,
                  'quantity': item.quantity,
                  'units': item.units,
                  'image': item.image,
                  'discount': item.discount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Product> _productInsertionAdapter;

  @override
  Future<List<Product>> getProducts(String userId) async {
    return _queryAdapter.queryList('SELECT * FROM Product WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as String,
            userId: row['userId'] as String,
            name: row['name'] as String,
            priceKg: row['priceKg'] as double,
            price: row['price'] as double,
            quantity: row['quantity'] as String,
            units: row['units'] as int,
            image: row['image'] as String,
            discount: row['discount'] as double),
        arguments: [userId]);
  }

  @override
  Future<List<Product>> getProductById(
    String productId,
    String userId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Product WHERE id = ?1 AND userId = ?2',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as String,
            userId: row['userId'] as String,
            name: row['name'] as String,
            priceKg: row['priceKg'] as double,
            price: row['price'] as double,
            quantity: row['quantity'] as String,
            units: row['units'] as int,
            image: row['image'] as String,
            discount: row['discount'] as double),
        arguments: [productId, userId]);
  }

  @override
  Future<void> addValueToProductUnits(
    String productId,
    String userId,
    int value,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Product SET units = units + ?3 WHERE id = ?1 AND userId = ?2',
        arguments: [productId, userId, value]);
  }

  @override
  Future<void> deleteById(
    String productId,
    String userId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Product WHERE id = ?1 AND userId = ?2',
        arguments: [productId, userId]);
  }

  @override
  Future<void> deleteProductsList(String userId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Product WHERE userId = ?1',
        arguments: [userId]);
  }

  @override
  Future<void> insertProduct(Product product) async {
    await _productInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }
}
