import 'package:flutter/material.dart';
import 'package:grocify/view/screens/addresses.screen.dart';
import 'package:grocify/view/screens/auth.stream.handler.dart';
import 'package:grocify/view/screens/catalog.screen.dart';
import 'package:grocify/view/screens/category.items.screen.dart';
import 'package:grocify/view/screens/home.screen.dart';
import 'package:grocify/view/screens/order.success.screen.dart';
import 'package:grocify/view/screens/orders.screen.dart';
import 'package:grocify/view/screens/signin.screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grocify/view/screens/signup.screen.dart';
import 'package:grocify/view/screens/track.order.screen.dart';
import 'firebase/firebase_options.dart';


/// Entry point of the application.
Future<void> main() async {
  /// Ensure that Flutter binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase with default options for the current platform.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Run the GrocifyApp widget as the root of the application.
  runApp(const GrocifyApp());
}

/// Root widget of the Grocify application.
class GrocifyApp extends StatelessWidget {
  const GrocifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Build the MaterialApp widget with the necessary configurations.
    return MaterialApp(
      title: 'Grocify',
      theme: ThemeData(useMaterial3: true),
      home: const AuthStreamHandler(), // Set AuthStreamHandler as the initial route
      debugShowCheckedModeBanner: false,
      routes: {
        // Define named routes for navigation
        SignInScreen.id: (context) => const SignInScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        CatalogScreen.id: (context) => const CatalogScreen(),
        CategoryItemsScreen.id: (context) => CategoryItemsScreen(ModalRoute.of(context)?.settings.arguments as String),
        AddressesScreen.id: (context) => const AddressesScreen(),
        OrdersScreen.id: (context) => const OrdersScreen(),
        TrackOrderScreen.id: (context) => TrackOrderScreen(ModalRoute.of(context)?.settings.arguments as String),
        OrderSuccessScreen.id: (context) => const OrderSuccessScreen()
      },
    );
  }
}