import 'package:flutter/cupertino.dart';
import 'package:grocify/firebase/auth.service.dart';
import '../firebase/firestore.service.dart';
import '../models/category.model.dart';
import '../models/user.model.dart';

/// ViewModel class for managing the catalog page where all the food categories are shown
class CatalogViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  String _currentUserName = '';
  String get currentUserName => _currentUserName;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  /// Fetches and sets the currently signed-in user's name.
  /// Retrieves user data from Firestore based on current user's UID,
  /// updates [_currentUserName] and notifies listeners.
  Future<void> getSignedInUserName() async {
    final currentUser = _authService.currentUser?.uid;

    try {
      final querySnapshot = await _firestoreService.queryCollection(
        collectionPath: "users",
        field: "uid",
        value: currentUser.toString(),
        operator: "==",
      );

      for (var document in querySnapshot.docs) {
        UserModel user = UserModel.fromJson(document.data() as Map<String, dynamic>);
        _currentUserName = user.name!;
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  /// Fetches and sets the list of categories from Firestore.
  /// Retrieves category data from Firestore collection "categories",
  /// updates [_categories] list and notifies listeners.
  Future<void> getCategories() async {
    try {
      final querySnapshot = await _firestoreService.getCollection("categories");

      _categories = querySnapshot.docs.map((document) {
        return CategoryModel(
          id: document.id,
          name: document.get("nome") as String,
          image: document.get("immagine") as String,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }
}