import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocify/firebase/firestore.service.dart';
import '../firebase/auth.service.dart';
import '../models/user.details.model.dart';

/// ViewModel class for managing addresses associated with the current user.
class AddressesViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  List<AddressModel> _addresses = [];

  /// Getter for the list of addresses
  List<AddressModel> get addresses => _addresses;

  /// Retrieves all addresses associated with the current user from Firestore.
  /// Updates [_addresses] list with fetched addresses and notifies listeners.
  Future<void> getAllAddresses() async {
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
          _addresses = addressesList.map((address) {
            return AddressModel.fromJson(address as Map<String, dynamic>);
          }).toList();
          notifyListeners();
        }
      }
    } catch (error) {
      print("Failed to fetch addresses: $error");
    }
  }

  /// Adds a new address for the current user to Firestore.
  /// If the user has no existing addresses, creates a new document.
  /// Otherwise, updates the existing document with the new address.
  Future<void> addAddress(
      String addressName, String address, String city, String civic) async {
    final addressObject = AddressModel(
      name: addressName,
      address: address,
      city: city,
      civic: civic,
      selected: false,
    );

    try {
      final querySnapshot = await _firestoreService.queryCollection(
        collectionPath: "users_details",
        field: "uid",
        value: _authService.currentUser?.uid,
        operator: "==",
      );

      if (querySnapshot.docs.isEmpty) {
        await _firestoreService.addDocument(
          "users_details",
          UserDetails(
            uid: _authService.currentUser!.uid,
            addresses: [addressObject],
          ).toJson(),
        );
      } else {
        await _firestoreService.updateDocument(
          "users_details",
          querySnapshot.docs.first.id,
          {"addresses": FieldValue.arrayUnion([addressObject.toJson()])},
        );
      }

      getAllAddresses();

    } catch (error) {
      print("Failed to add address: $error");
    }
  }

  /// Deletes a specified address for the current user from Firestore.
  /// Removes the address from the user's document based on matching criteria.
  Future<void> deleteAddress(AddressModel address) async {
    try {
      final querySnapshot = await _firestoreService.queryCollection(
        collectionPath: "users_details",
        field: "uid",
        value: _authService.currentUser?.uid,
        operator: "==",
      );

      String docId = querySnapshot.docs.first.id;

      List<Map<String, dynamic>> addressesList =
      List<Map<String, dynamic>>.from(
          querySnapshot.docs.first['addresses']);

      addressesList.removeWhere((item) =>
      item['address'] == address.address &&
          item['city'] == address.city &&
          item['name'] == address.name &&
          item['civic'] == address.civic &&
          item['selected'] == address.selected);

      await _firestoreService.updateDocument(
        "users_details",
        docId,
        {"addresses": addressesList},
      );

      getAllAddresses();

    } catch (e) {
      print('Failed to remove address: $e');
    }
  }

  /// Sets a specified address as selected for the current user in Firestore.
  /// Updates the selected state of addresses based on user interaction.
  Future<void> setAddressSelected(AddressModel address) async {
    try {
      final querySnapshot = await _firestoreService.queryCollection(
        collectionPath: "users_details",
        field: "uid",
        value: _authService.currentUser?.uid,
        operator: "==",
      );

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        DocumentSnapshot userDetailsDoc =
        await _firestoreService.getDocumentById("users_details", docId);

        List<Map<String, dynamic>> addressesList =
        List<Map<String, dynamic>>.from(userDetailsDoc['addresses']);

        Map<String, dynamic> addressMap = address.toJson();

        for (var addressItem in addressesList) {
          if (addressItem['selected'] == true) {
            addressItem['selected'] = false;
          }
        }

        for (var addressItem in addressesList) {
          if (mapEquals(addressItem, addressMap)) {
            addressItem['selected'] = true;
          }
        }

        await _firestoreService.updateDocument(
            "users_details", docId, {'addresses': addressesList});

        getAllAddresses();
      }
    } catch (e) {
      print('Error setting address selected: $e');
    }
  }
}