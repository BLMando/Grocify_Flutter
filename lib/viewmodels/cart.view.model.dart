import 'package:flutter/cupertino.dart';

import '../firebase/auth.service.dart';
import '../firebase/firestore.service.dart';
import '../models/product.model.dart';
import '../models/user.details.model.dart';


class CartViewModel extends ChangeNotifier{

  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  List<ProductModel> _productsList = [];
  double _totalPrice  = 0.00;
  String _orderId = "";
  bool _buttonAvailable = true;

  List<ProductModel> get productsList => _productsList;
  double get totalPrice => _totalPrice;
  String get orderId => _orderId;
  bool get buttonAvailable => _buttonAvailable;

  Future<void> checkForAddressSelected() async{
      try{
        final querySnapshot = await _firestoreService.queryCollection(
            collectionPath: "users_details",
            field: "uid",
            value: _authService.currentUser?.uid,
            operator: "=="
        );

        if(querySnapshot.docs.isEmpty) {
          _buttonAvailable = false;
        }else{
          var document = querySnapshot.docs.first;
          var addressesList = document["addresses"] as List<dynamic>;
          if (addressesList.isNotEmpty) {
            bool hasSelectedAddress = addressesList.any((address) => AddressModel.fromJson(address).selected);
            _buttonAvailable = hasSelectedAddress;
          }else{
            _buttonAvailable = false;
          }
        }
        notifyListeners();
      }catch(e){
        print("Error fetching address data: $e");
      }
  }

}