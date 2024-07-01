import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocify/views/screens/home.screen.dart';
import 'package:grocify/views/screens/signin.screen.dart';
import 'package:grocify/viewmodels/auth.view.model.dart';

/// This Widget checks if the user is already signed-in using the authStateChange of the AuthService.
/// If is signed-in it will redirect to the Home page, otherwise Login page
class AuthStreamHandler extends StatelessWidget {

  const AuthStreamHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = AuthViewModel(procedureType: '');

    return StreamBuilder<User?>(
      stream: authViewModel.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user == null ? const SignInScreen() : const HomeScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}