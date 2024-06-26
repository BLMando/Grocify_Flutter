import 'package:flutter/cupertino.dart';
import 'package:grocify/models/product.model.dart';

import '../firebase/firestore.service.dart';

class CategoryItemsViewModel extends ChangeNotifier {

  String _categoryName = '';
  String get categoryName => _categoryName;

  final List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  Future<void> getCategoryName(String categoryId) async {
    try {
      final documentSnapshot = await FirestoreService()
          .getDocumentById('categories', categoryId);

      _categoryName = documentSnapshot.get("nome");

    } catch (e) {
      print("Error fetching category data: $e");
    } finally{
      notifyListeners();
    }
  }

  Future<void> getProducts(String categoryId) async {
    try{
      final querySnapshot = await FirestoreService().queryCollection(
          collectionPath: 'prodotti',
          field: 'categoria',
          value: categoryId,
          operator: '=='
      );

      for (var document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        Map<String, dynamic> productMap;

        if(data.containsKey('sconto')){
          productMap = {
            'id': document.id,
            'nome': document.get("nome") as String,
            'prezzo_al_kg': document.get("prezzo_al_kg"),
            'prezzo_unitario': document.get("prezzo_unitario"),
            'quantita': document.get("quantita"),
            'immagine': document.get("immagine") as String,
            'sconto': document.get("sconto") != null ? document.get("sconto") as String : '',
          };
        }else{
          productMap = {
            'id': document.id,
            'nome': document.get("nome") as String,
            'prezzo_al_kg': document.get("prezzo_al_kg"),
            'prezzo_unitario': document.get("prezzo_unitario"),
            'quantita': document.get("quantita"),
            'immagine': document.get("immagine") as String,
          };
        }
        ProductModel product = ProductModel.fromJson(productMap);
        _products.add(product);
      }

      notifyListeners();
    }catch(e){
      print("Error fetching products: $e");
    }
  }

}