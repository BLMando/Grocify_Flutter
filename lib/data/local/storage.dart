import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'cart.dart';
import 'cart.dao.dart';
import 'product.dart';
import 'product.dao.dart';

part 'storage.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Cart, Product])
abstract class AppDatabase extends FloorDatabase {
  CartDao    get cartDao;
  ProductDao get productDao;
}