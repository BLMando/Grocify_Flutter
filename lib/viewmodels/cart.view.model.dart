import 'package:flutter/cupertino.dart';
import 'package:grocify/models/order.model.dart';

import '../data/local/cart.dart';
import '../data/local/product.dart';
import '../data/local/storage.dart';
import '../firebase/auth.service.dart';
import '../firebase/firestore.service.dart';
import '../models/user.details.model.dart';
import 'package:intl/intl.dart';


class CartViewModel extends ChangeNotifier{

  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  List<Product> _productsList = [];
  double _totalPrice  = 0.00;
  late AddressModel _addressSelected;
  bool _flagOrder = true;
  bool _flagSelectedAddress = false;
  String _orderId = "";

  List<Product> get productsList => _productsList;
  double get totalPrice => _totalPrice;
  bool get flagOrder => _flagOrder;
  bool get flagSelectedAddress => _flagSelectedAddress;
  String get orderId => _orderId;

  Future<void> initializeProductsList() async {
    final userId = _authService.currentUser!.uid;

    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final productDao = database.productDao;
    final cartDao = database.cartDao;

    final products = await productDao.getProducts(userId);
    final cartDb = await cartDao.getCart(userId);

    if (cartDb.isEmpty) {
      final cart = Cart(
        userId: userId,
        totalPrice: 1.50,
      );
      await cartDao.insertCart(cart);
      _totalPrice =  1.50;
    } else {
      _totalPrice =  cartDb[0].totalPrice;
    }
   _productsList = products;
    notifyListeners();
  }


  Future<void> addValueToProductUnits(Product product, int value) async {
    if(value < 0){
      if (product.units > 1){
        final userId = _authService.currentUser!.uid;

        final database = await $FloorAppDatabase.databaseBuilder('app_database.db')
            .build();
        final productDao = database.productDao;
        final cartDao = database.cartDao;

        final price = value * (product.price * (100.0 - product.discount) / 100.0);
        await cartDao.addValueToTotalPrice(userId, price);
        _totalPrice = _totalPrice + price;

        await productDao.addValueToProductUnits(product.id, userId, value);

        final index = getIndexById(product.id);
        if (index != -1) {
          _productsList = List.from(_productsList);
          _productsList[index] = _productsList[index].copyWith(
            units: _productsList[index].units + value,
          );
        }

        notifyListeners();
      }
    }
    else{
      final userId = _authService.currentUser!.uid;

      final database = await $FloorAppDatabase.databaseBuilder('app_database.db')
          .build();
      final productDao = database.productDao;
      final cartDao = database.cartDao;

      final price = value * (product.price * (100.0 - product.discount) / 100.0);
      await cartDao.addValueToTotalPrice(userId, price);
      _totalPrice = _totalPrice + price;

      await productDao.addValueToProductUnits(product.id, userId, value);

      final index = getIndexById(product.id);
      if (index != -1) {
        _productsList = List.from(_productsList);
        _productsList[index] = _productsList[index].copyWith(
          units: _productsList[index].units + value,
        );
      }
      notifyListeners();
    }
  }

  Future<void> removeFromCart(Product product) async {
    final userId = _authService.currentUser!.uid;

    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final productDao = database.productDao;
    final cartDao = database.cartDao;

    final productToRemove = _productsList.firstWhere((p) => p.id == product.id);

    await productDao.deleteById(product.id, userId);
    _productsList.remove(productToRemove);

    final priceReduction = product.units * (product.price * (100.0 - product.discount) / 100.0);
    await cartDao.addValueToTotalPrice(userId, -priceReduction);
    _totalPrice -= priceReduction;
    notifyListeners();
    }

  Future<void> getSelectedAddress() async {
    List<AddressModel> addresses;

    try {
      final querySnapshot = await _firestoreService.queryCollection(
        collectionPath: "users_details",
        field: "uid",
        value: _authService.currentUser?.uid,
        operator: "==",
      );

      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        var addressesList = document["addresses"] as List<dynamic>;
        if (addressesList.isNotEmpty) {
          addresses = addressesList.map((address) {
            return AddressModel.fromJson(address as Map<String, dynamic>);
          }).toList();

          _addressSelected = addresses.firstWhere((address) => address.selected);

          _flagSelectedAddress = addresses.any((address) => address.selected);
        }
      }
    } catch (error) {
      print("Failed to fetch addresses: $error");
    }
  }

  Future<void> checkOrders() async {
    List<OrderModel> orders = [];

    try {
      final querySnapshot = await _firestoreService.queryCollection(
        collectionPath: "orders",
        field: "userId",
        value: _authService.currentUser?.uid,
        operator: "==",
      );

      if (querySnapshot.docs.isNotEmpty) {
        orders = querySnapshot.docs.map((document) {
          return OrderModel.fromJson(document.data() as Map<String, dynamic>);
        }).toList();

        _flagOrder = orders.any((order) => order.status != 'concluso');
      }
    } catch (error) {
      print("Failed to fetch orders: $error");
    }
  }


  Future<void> createNewOrder() async {
    final userId = _authService.currentUser!.uid;

    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final productDao = database.productDao;
    final cartDao    = database.cartDao;

    var products = await productDao.getProducts(userId);
    var lightProducts = <Map<String, dynamic>>[];

    for (var product in products) {
      var productData = {
        'id': product.id,
        'name': product.name,
        'units': product.units,
        'image': product.image,
        'quantity': product.quantity
      };
      lightProducts.add(productData);
    }

    var formatter = DateFormat('dd/MM/yyyy HH:mm');
    var localDate = DateTime.now();
    var dateTime = formatter.format(localDate).split(' ');

    var roundedTotalPrice = _totalPrice.toStringAsFixed(2);

    await checkOrders();
    await getSelectedAddress();


    if(_flagOrder == false){
      if(_flagSelectedAddress){
        final newOrder = OrderModel(
          orderId: '',
          cart: lightProducts,
          userId: userId,
          status: 'in attesa',
          destination:
          '${_addressSelected.city}, ${_addressSelected.address} ${_addressSelected.civic}',
          totalPrice: double.parse(roundedTotalPrice),
          type: 'online',
          date: dateTime[0],
          time: dateTime[1],
          driverId: ""
        );
        await addOrder(newOrder);
        cartDao.deleteCart(userId);
        productDao.deleteProductsList(userId);
        _totalPrice = 0;
        _productsList = [];
      }
    }
    notifyListeners();
  }


  Future<void> addOrder(OrderModel order) async {
    try {
        var document = await _firestoreService.addDocument(
          "orders",
          order.toJson(),
        );

        int hash = document.id.hashCode < 0 ? document.id.hashCode : -document.id.hashCode;

        _orderId = hash.toString().replaceAll("-", "#");

        await _firestoreService.updateDocument(
          "orders",
          document.id,
          {'orderId': _orderId},
        );
    }
    catch (error) {
      print("Failed to add order: $error");
    }
  }



  int getUnitsById(String id) {
    final index = _productsList.indexWhere((product) => product.id == id);

    return _productsList[index].units;
  }

  int getIndexById(String id) {
    return _productsList.indexWhere((product) => product.id == id);
  }
}