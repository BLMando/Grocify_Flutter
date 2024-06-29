import 'package:flutter/cupertino.dart';
import 'package:grocify/models/product.model.dart';

import '../firebase/firestore.service.dart';

/// ViewModel class for managing products related to a specific category.
class CategoryItemsViewModel extends ChangeNotifier {

  String _categoryName = '';
  String get categoryName => _categoryName;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  /// Fetches and sets the name of the category identified by [categoryId].
  /// Retrieves category data from Firestore based on [categoryId],
  /// updates [_categoryName] and notifies listeners.
  Future<void> getCategoryName(String categoryId) async {
    try {
      final documentSnapshot = await FirestoreService()
          .getDocumentById('categories', categoryId);

      _categoryName = documentSnapshot.get("nome");

      notifyListeners();
    } catch (e) {
      print("Error fetching category data: $e");
    }
  }

  /// Fetches and sets the list of products belonging to the category identified by [categoryId].
  /// Retrieves product data from Firestore based on [categoryId],
  /// populates [_products] with instances of [ProductModel] created from retrieved data,
  /// handles different product structures (with or without discount), and notifies listeners.
  Future<void> getProducts(String categoryId) async {
    try {
      final querySnapshot = await FirestoreService().queryCollection(
          collectionPath: 'prodotti',
          field: 'categoria',
          value: categoryId,
          operator: '=='
      );

      _products = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        Map<String, dynamic> productMap = {
          'id': document.id,
          'nome': data['nome'] as String,
          'prezzo_al_kg': data['prezzo_al_kg'],
          'prezzo_unitario': data['prezzo_unitario'],
          'quantita': data['quantita'],
          'immagine': data['immagine'] as String,
          if (data.containsKey('sconto')) 'sconto': data['sconto'] as String,
        };
        return ProductModel.fromJson(productMap);
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching products: $e");
    }
  }
}