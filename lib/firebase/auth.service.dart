import 'package:firebase_auth/firebase_auth.dart';

/// A service class for interacting with FirebaseAuth.
/// Provides methods to handle the auth logic.
class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Getter for the currentUser data
  User? get currentUser => _firebaseAuth.currentUser;

  /// Getter for the Stream that manage the user's authentication state in real-time (logged-in or logged-out)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Signs in a user with the provided email and password.
  /// Returns a [User] object if the sign-in was successful, otherwise null.
  /// Throws a [FirebaseAuthException] if the sign-in fails.
  /// Parameters:
  /// - `email`: The email address of the user.
  /// - `password`: The password of the user.
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


  /// Creates a new user with the provided email and password.
  /// Returns a [User] object if the account creation was successful, otherwise null.
  /// Throws a [FirebaseAuthException] if the account creation fails.
  /// Parameters:
  /// - `email`: The email address of the user.
  /// - `password`: The password of the user.
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

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}