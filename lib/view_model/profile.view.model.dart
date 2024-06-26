import 'package:flutter/cupertino.dart';
import 'package:grocify/models/user.model.dart';

import '../firebase/auth.service.dart';
import '../firebase/firestore.service.dart';

class ProfileViewModel extends ChangeNotifier {

   final AuthService _authService = AuthService();

   UserModel _user = UserModel(
       uid: '',
       name: '',
       surname: '',
       email: '',
       profilePic: ''
   );
   UserModel get user => _user;

   Future<void> getSignedInUser() async {
      try {
         final querySnapshot = await FirestoreService()
         .queryCollection(
             collectionPath: "users",
             field: "uid",
             value: _authService.currentUser!.uid,
             operator: "=="
         );

         print(querySnapshot.docs);

         _user = UserModel(
            uid: querySnapshot.docs.first.get("uid") as String,
            name: querySnapshot.docs.first.get("name") as String,
            surname: querySnapshot.docs.first.get("surname") as String,
            email: querySnapshot.docs.first.get("email") as String,
            profilePic: querySnapshot.docs.first.get("profilePic") as String,
         );

      } catch (e) {
         print("Error fetching user data: $e");
      } finally{
         notifyListeners();
      }
   }


}