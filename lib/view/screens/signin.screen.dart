import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocify/res/colors/app.colors.dart';
import 'package:grocify/res/dimensions/app.dimensions.dart';
import 'package:grocify/view/screens/home.screen.dart';
import 'package:grocify/view/screens/signup.screen.dart';
import 'package:provider/provider.dart';
import '../../view_model/auth.view.model.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "signin";

  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{

  late final AuthViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AuthViewModel(procedureType: "sign_in");
    viewModel.authStateChanges.listen((User? user) {
      if (user != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    });
  }

  bool showPassword = false;

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider<AuthViewModel>.value(
          value: viewModel,
          child: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) {
              return Scaffold(
                body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        const Image(
                          image: AssetImage('assets/images/icon.png'),
                          width: 200,
                          height: 200,
                        ),

                        const Text.rich(
                            TextSpan(
                                text: "Benvenuto su ",
                                style: TextStyle(
                                  fontSize: AppDimension.bigText,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Grocify",
                                      style: TextStyle(
                                          color: AppColors.blueLight,
                                          fontSize: AppDimension.bigText,
                                          fontWeight: FontWeight.w700,
                                          shadows:[
                                            Shadow(
                                                color: Colors.black,
                                                offset: Offset(2, 2),
                                                blurRadius: 2
                                            )
                                          ],
                                          letterSpacing: 2
                                      )
                                  )
                                ]
                            )
                        ),

                        const SizedBox(height: 20),

                        const Text(
                            "Accedi al tuo account",
                            style: TextStyle(
                                fontSize: AppDimension.defaultText,
                                fontWeight: FontWeight.w400,
                                color:Color(0xFF030303)
                            )
                        ),

                        const SizedBox(height: 20),

                        Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: SizedBox(
                                width: 325,
                                child: TextField(
                                    controller: viewModel.emailController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email',
                                      hintText: 'Inserisci la tua email',
                                    )
                                )
                            )
                        ),


                        SizedBox(
                            width: 325,
                            child: TextField(
                              controller: viewModel.passwordController,
                              obscureText: !showPassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Inserisci la tua password',
                                border: const OutlineInputBorder(),
                                suffixIcon: GestureDetector(
                                  onTap: toggleShowPassword,
                                  child: Icon(
                                    showPassword ? Icons.visibility : Icons.visibility_off, // Add this line
                                  ),
                                ),
                              ),
                            )
                        ),

                        Padding(
                            padding: viewModel.statusMessage != '' ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
                            child: Text(
                              viewModel.statusMessage != '' ? viewModel.statusMessage : '',
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: AppDimension.smallText
                              ),
                              textAlign: TextAlign.center,
                            )
                        ),

                        Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 30),
                            child: SizedBox(
                              width: 325,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: viewModel.areFieldsFilled ? () {
                                    viewModel.signIn();
                                  } : null,
                                  style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(AppColors.blueDark)
                                  ),
                                  child: const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "Accedi",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppDimension.defaultText
                                        ),
                                      )
                                  )
                              ),
                            )
                        ),

                        TextButton(
                          onPressed: (){
                            Navigator.pushNamed(context, SignUpScreen.id);
                          },
                          child: const Text(
                              "Non hai un account? Registrati ora!"
                          ),
                        )
                      ],
                    )
                ),
              );
          }
          )
      );
    }
}

