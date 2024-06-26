import 'package:flutter/material.dart';
import 'package:grocify/view/screens/auth.stream.handler.dart';
import 'package:grocify/view/screens/category.items.screen.dart';
import 'package:grocify/view/screens/home.screen.dart';
import 'package:grocify/view/screens/signin.screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grocify/view/screens/signup.screen.dart';
import 'firebase/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GrocifyApp());
}

class GrocifyApp extends StatelessWidget{
  const GrocifyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Grocify',
     theme: ThemeData(useMaterial3: true),
     home: const AuthStreamHandler(),
     debugShowCheckedModeBanner: false,
     routes: {
       SignInScreen.id: (context) => const SignInScreen(),
       SignUpScreen.id: (context) => const SignUpScreen(),
       HomeScreen.id: (context) => const HomeScreen(),
       CategoryItemsScreen.id: (context) => CategoryItemsScreen(ModalRoute.of(context)?.settings.arguments as String),
     },
   );
  }
}
