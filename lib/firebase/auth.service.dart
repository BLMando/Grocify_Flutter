import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return userCredential.user;
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}