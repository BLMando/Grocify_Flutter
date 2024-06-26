import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../firebase/auth.service.dart';
import '../firebase/firestore.service.dart';
import '../models/user.model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final String procedureType;

  String _statusMessage = '';
  bool _isLoading = false;
  bool _areFieldsFilled = false;

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  String get statusMessage => _statusMessage;
  bool get isLoading => _isLoading;
  bool get areFieldsFilled => _areFieldsFilled;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  AuthViewModel({required this.procedureType}){
    if(procedureType == "sign_in"){
      emailController.addListener(_checkFieldsSignIn);
      passwordController.addListener(_checkFieldsSignIn);
    }else{
      nameController.addListener(_checkFieldsSignUp);
      surnameController.addListener(_checkFieldsSignUp);
      emailController.addListener(_checkFieldsSignUp);
      passwordController.addListener(_checkFieldsSignUp);
      confirmPasswordController.addListener(_checkFieldsSignUp);
    }

  }

  void _checkFieldsSignIn() {
    _areFieldsFilled =
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    notifyListeners();
  }

  void _checkFieldsSignUp() {
    _areFieldsFilled =
        nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
    notifyListeners();
  }

  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = await _authService.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
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

  Future<void> signUp() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = await _authService.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      if (user == null) {
        _statusMessage = 'Sign up failed';
      }else{
        UserModel user = UserModel(
          uid: _authService.currentUser?.uid,
          name: nameController.text,
          surname: surnameController.text,
          email: emailController.text,
          password: passwordController.text,
          profilePic: "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png",
          role: "user",
        );

        Map<String, dynamic> userMap = user.toJson();
        await FirestoreService().addDocument("users", userMap);
      }
    } on FirebaseAuthException catch (_, e) {
      _statusMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}