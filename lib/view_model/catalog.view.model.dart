import 'package:flutter/cupertino.dart';
import 'package:grocify/firebase/auth.service.dart';
import '../firebase/firestore.service.dart';
import '../models/category.model.dart';
import '../models/user.model.dart';

class CatalogViewModel extends ChangeNotifier {

  String _currentUserName = '';
  String get currentUserName => _currentUserName;

  final List<CategoryModel> _categories =[];
  List<CategoryModel> get categories => _categories;

  Future<void> getSignedInUserName() async {
    final currentUser = AuthService().currentUser?.uid;

    try {
      final querySnapshot = await FirestoreService()
          .queryCollection(collectionPath: "users", field: "uid", value: currentUser.toString(), operator: "==");

      for (var document in querySnapshot.docs) {
        UserModel user = UserModel.fromJson(document.data() as Map<String, dynamic>);
        _currentUserName = user.name!;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally{
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    try{
      final querySnapshot = await FirestoreService().getCollection("categories");

      _categories.addAll(querySnapshot.docs.map((document) {
        return CategoryModel(
          id: document.id,
          name: document.get("nome") as String,
          image: document.get("immagine") as String,
        );
      }).toList());

      notifyListeners();
    }catch(e){
      print("Error fetching categories: $e");
    }
  }
}