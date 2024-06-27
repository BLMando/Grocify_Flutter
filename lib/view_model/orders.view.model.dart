import 'package:flutter/cupertino.dart';

import '../firebase/auth.service.dart';
import '../firebase/firestore.service.dart';
import '../models/order.model.dart';

class OrdersViewModel extends ChangeNotifier {

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Future<void> getAllOrders() async {
    try {
      final querySnapshot = await _firestoreService
          .queryCollection(
            collectionPath: "orders",
            field: "userId",
            value: _authService.currentUser?.uid,
            operator: "=="
          );

      _orders = querySnapshot.docs.map((document) {
        return OrderModel.fromJson(document.data() as Map<String, dynamic>);
      }).toList();

      notifyListeners();
    } catch (error) {
      print("Failed to fetch orders: $error");
    }
  }



}