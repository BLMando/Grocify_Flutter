import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dao/product.dao.dart';
import 'entity/cart.dart';
import 'dao/cart.dao.dart';
import 'entity/product.dart';

part 'storage.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Cart, Product])
abstract class AppDatabase extends FloorDatabase {
  CartDao    get cartDao;
  ProductDao get productDao;
}