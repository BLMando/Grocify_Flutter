import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../firebase/auth.service.dart';
import '../firebase/firestore.service.dart';
import '../models/user.model.dart';


/// ViewModel class for managing authentication state and user actions.
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final String procedureType;

  String _statusMessage = '';
  bool _isLoading = false;
  bool _areFieldsFilled = false;

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

  /// Getter for authentication state changes.
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  /// Getter for the current status message.
  String get statusMessage => _statusMessage;

  /// Getter for checking if data is currently loading.
  bool get isLoading => _isLoading;

  /// Getter for checking if all required fields are filled.
  bool get areFieldsFilled => _areFieldsFilled;

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
  /// Sets loading state, attempts sign-in, handles exceptions,
  /// and updates status message and loading state accordingly.
  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = await _authService.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user == null) {
        _statusMessage = 'Sign in failed';
      }
    } on FirebaseAuthException catch (_, e) {
      _statusMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initiates the sign-up process.
  /// Sets loading state, attempts sign-up, handles exceptions,
  /// updates status message, adds user to Firestore on successful sign-up,
  /// and updates loading state accordingly.
  Future<void> signUp() async {
    _isLoading = true;
    notifyListeners();

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
        await FirestoreService().addDocument("users", userMap);
      }
    } on FirebaseAuthException catch (_, e) {
      _statusMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _authService.signOut();
  }
}