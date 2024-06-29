import 'package:flutter/cupertino.dart';
import 'package:grocify/models/user.model.dart';
import '../firebase/auth.service.dart';
import '../firebase/firestore.service.dart';

/// ViewModel class for managing user profile information.
class ProfileViewModel extends ChangeNotifier {

   final AuthService _authService = AuthService();

   UserModel _user = UserModel(
      uid: '',
      name: '',
      surname: '',
      email: '',
      profilePic: '',
   );

   /// Getter to retrieve the current signed-in user's information.
   UserModel get user => _user;

   /// Fetches and sets the signed-in user's profile information.
   /// Retrieves user data from Firestore based on current user's UID,
   /// updates [_user] with fetched data, and notifies listeners.
   Future<void> getSignedInUser() async {
      try {
         final querySnapshot = await FirestoreService().queryCollection(
            collectionPath: "users",
            field: "uid",
            value: _authService.currentUser!.uid,
            operator: "==",
         );

         if (querySnapshot.docs.isNotEmpty) {
            _user = UserModel(
               uid: querySnapshot.docs.first.get("uid") as String,
               name: querySnapshot.docs.first.get("name") as String,
               surname: querySnapshot.docs.first.get("surname") as String,
               email: querySnapshot.docs.first.get("email") as String,
               profilePic: querySnapshot.docs.first.get("profilePic") as String,
            );
         }

         notifyListeners();

      } catch (e) {
         print("Error fetching user data: $e");
      }
   }

   /// Signs out the current user.
   void signOut() {
      _authService.signOut();
   }
}