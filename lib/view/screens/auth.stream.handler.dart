import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocify/view/screens/home.screen.dart';
import 'package:grocify/view/screens/signin.screen.dart';
import 'package:grocify/view/shared/loading.widget.dart';
import 'package:grocify/view_model/auth.view.model.dart';

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
          body: Center(child: LoadingWidget()),
        );
      },
    );
  }
}