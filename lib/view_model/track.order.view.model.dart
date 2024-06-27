import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:grocify/firebase/firestore.service.dart';
import 'package:grocify/models/order.model.dart';

class TrackOrderViewModel extends ChangeNotifier{

  final FirestoreService _firestoreService = FirestoreService();

  OrderModel _order = OrderModel(
    orderId: '',
    cart: [],
    userId: '',
    status: '',
    destination: '',
    totalPrice: 0.0,
    type: '',
    date: '',
    time: '',
    driverId: ''
  );
  OrderModel get order => _order;

  String _driverName = '';
  String get driverName => _driverName;

  Future<void> getDriverName(String orderId) async {
    try{
      final ordersSnapshot = await _firestoreService.queryCollection(
        collectionPath: "orders",
        field: "orderId",
        value: orderId,
        operator: "=="
      );

      String driverId = ordersSnapshot.docs[0].get('driverId');

      final userSnapshot = await _firestoreService.queryCollection(
          collectionPath: "users",
          field: "uid",
          value: driverId,
          operator: "=="
      );

      String driverName = userSnapshot.docs[0].get('name');
      String driverSurname = userSnapshot.docs[0].get('surname');

      _driverName = '$driverName $driverSurname';

      notifyListeners();
    }catch(e){
      print("Error fetching driver name: $e");
    }
  }

  Future<void> getCurrentOrder(String orderId) async {
    try{
      final orderSnapshot = await _firestoreService.queryCollection(
          collectionPath: "orders",
          field: "orderId",
          value: orderId,
          operator: "=="
      );

      _order = OrderModel.fromJson(orderSnapshot.docs[0].data() as Map<String, dynamic>);
      notifyListeners();

    }catch(e){
      print("Error fetching order data: $e");
    }
  }


}