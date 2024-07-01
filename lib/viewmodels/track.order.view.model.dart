import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:grocify/firebase/firestore.service.dart';
import 'package:grocify/models/order.model.dart';

/// ViewModel class for tracking orders and fetching associated data.
class TrackOrderViewModel extends ChangeNotifier {

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
    driverId: '',
  );

  /// Getter to retrieve the current order being tracked.
  OrderModel get order => _order;

  String _driverName = '';

  /// Getter to retrieve the name of the driver associated with the current order.
  String get driverName => _driverName;

  String _orderStatus = '';
  StreamSubscription<String>? _orderStatusSubscription;
  bool isStatusChanged = false; // Flag to track if status changed to "concluso"
  String get orderStatus => _orderStatus;

  /// Fetches and sets the name of the driver associated with the given order ID.
  /// Retrieves driver information from Firestore based on the driver's UID,
  /// updates [_driverName] with the concatenated driver's name and surname,
  /// and notifies listeners.
  Future<void> getDriverName(String orderId) async {
    try {
      final ordersSnapshot = await _firestoreService.queryCollection(
        collectionPath: "orders",
        field: "orderId",
        value: orderId,
        operator: "==",
      );

      String driverId = ordersSnapshot.docs[0].get('driverId');

      final userSnapshot = await _firestoreService.queryCollection(
        collectionPath: "users",
        field: "uid",
        value: driverId,
        operator: "==",
      );

      String driverName = userSnapshot.docs[0].get('name');
      String driverSurname = userSnapshot.docs[0].get('surname');

      _driverName = '$driverName $driverSurname';

      notifyListeners();
    } catch (e) {
      print("Error fetching driver name: $e");
    }
  }

  /// Fetches and sets the current order details based on the given order ID.
  /// Retrieves order data from Firestore based on the order ID,
  /// updates [_order] with the fetched data, and notifies listeners.
  Future<void> getCurrentOrder(String orderId) async {
    try {
      final orderSnapshot = await _firestoreService.queryCollection(
        collectionPath: "orders",
        field: "orderId",
        value: orderId,
        operator: "==",
      );

      _order = OrderModel.fromJson(orderSnapshot.docs[0].data() as Map<String, dynamic>);
      notifyListeners();

    } catch (e) {
      print("Error fetching order data: $e");
    }
  }


  /// This function listens to changes in the 'status' field of a specific document in the 'orders' collection.
  /// It sets up a listener that updates the _orderStatus property and notifies listeners of the ViewModel.
  /// Then the listener is being eliminated
  void listenToOrderStatus(String orderId) {
    _orderStatusSubscription?.cancel();

    _orderStatusSubscription = _firestoreService.setUpFieldListener("orders", orderId, "orderId", "status").listen((status) {
      if (status == "concluso") {
        _orderStatus = status;
        isStatusChanged = true; // Set flag to true when status changes to "concluso"
        notifyListeners();
        cancelOrderStatusListener();
      }
    });
  }

  void cancelOrderStatusListener() {
    _orderStatusSubscription?.cancel();
    _orderStatusSubscription = null;
  }

  /// Cancels listener even if the ViewModel is destroyed
  @override
  void dispose() {
    cancelOrderStatusListener();
    super.dispose();
  }

  void resetStatusFlag(){
    isStatusChanged = false; // Reset flag
  }
}