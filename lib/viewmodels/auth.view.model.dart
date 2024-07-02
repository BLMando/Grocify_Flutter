import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../firebase/auth.service.dart';
import '../firebase/firestore.service.dart';
import '../models/user.model.dart';


/// ViewModel class for managing authentication state and user actions.
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final String procedureType;

  String _statusMessage = '';
  bool _areFieldsFilled = false;
  bool _hasPermissions = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  /// Constructor for [AuthViewModel].
  /// Initializes with the given [procedureType].
  /// Depending on procedure type (sign in or sign up), listen to relevant text field changes
  AuthViewModel({required this.procedureType}) {
    if (procedureType == "sign_in") {
      emailController.addListener(_checkFieldsSignIn);
      passwordController.addListener(_checkFieldsSignIn);
    } else {
      nameController.addListener(_checkFieldsSignUp);
      surnameController.addListener(_checkFieldsSignUp);
      emailController.addListener(_checkFieldsSignUp);
      passwordController.addListener(_checkFieldsSignUp);
      confirmPasswordController.addListener(_checkFieldsSignUp);
    }
  }

  /// Getter for the current user info.
  User? get currentUser => _authService.currentUser;

  /// Getter for the current status message.
  String get statusMessage => _statusMessage;

  /// Getter for checking if all required fields are filled.
  bool get areFieldsFilled => _areFieldsFilled;

  /// Getter for checking if the user has the required permissions.
  bool get hasPermissions => _hasPermissions;

  /// Listener function to check if sign-in text fields are not empty.
  void _checkFieldsSignIn() {
    _areFieldsFilled = emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    notifyListeners();
  }

  /// Listener function to check if sign-up text fields are not empty.
  void _checkFieldsSignUp() {
    _areFieldsFilled = nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
    notifyListeners();
  }

  /// Initiates the sign-in process.
  /// Sets loading state, attempts sign-in, checks permissions, handles exceptions,
  /// and updates status message and loading state accordingly.
  Future<void> signIn() async {
    try {
      await _authService.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (_authService.currentUser != null) {
        _hasPermissions = await checkForAuthPermissions(_authService.currentUser!.uid);
        if (!_hasPermissions) {
          _statusMessage = "App riservata ai clienti!";
        }else{
          _statusMessage = '';
        }
      }

    } on FirebaseAuthException catch (e) {
      _statusMessage = e.message.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Initiates the sign-up process.
  /// Sets loading state, attempts sign-up, handles exceptions,
  /// updates status message, adds user to Firestore on successful sign-up,
  /// and updates loading state accordingly.
  Future<void> signUp() async {
    try {
      User? user = await _authService.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user == null) {
        _statusMessage = 'Sign up failed';
      } else {
        UserModel newUser = UserModel(
          uid: _authService.currentUser?.uid,
          name: nameController.text,
          surname: surnameController.text,
          email: emailController.text,
          password: passwordController.text,
          profilePic: "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png",
          role: "user",
        );

        Map<String, dynamic> userMap = newUser.toJson();
        await _firestoreService.addDocument("users", userMap);
      }
    } on FirebaseAuthException catch (e) {
      _statusMessage = e.message.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _authService.signOut();
  }

  /// Checks if the user has the required permissions based on their role.
  /// This function queries the Firestore collection to check the role of the user
  /// with the given `userId`. If the user's role is "user", it returns `true`.
  /// Otherwise, it returns `false`.
  ///
  /// Parameters:
  /// - `userId`: The unique identifier of the user.
  Future<bool> checkForAuthPermissions(String userId) async {
    try {
      final querySnapshot = await _firestoreService.queryCollection(
          collectionPath: "users",
          field: "uid",
          value: userId,
          operator: "=="
      );

      if (querySnapshot.docs.isNotEmpty) {
        final userRole = querySnapshot.docs.first.get("role");
        return userRole == "user";
      } else {
        return false;
      }
    } catch (e) {
      print("Error in checkForAuthPermissions: $e");
      return false;
    }
  }

}