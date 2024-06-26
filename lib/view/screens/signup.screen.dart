import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocify/res/colors/app.colors.dart';
import 'package:grocify/res/dimensions/app.dimensions.dart';
import 'package:grocify/view/screens/home.screen.dart';
import 'package:grocify/view/screens/signin.screen.dart';
import 'package:grocify/view_model/auth.view.model.dart';
import 'package:provider/provider.dart';


class SignUpScreen extends StatefulWidget {
  static const String id = "signup";

  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  late final AuthViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AuthViewModel(procedureType: "sign_up");
    viewModel.authStateChanges.listen((User? user) {
      if (user != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    });
  }

  final List<Color> colors = [
    AppColors.blueMedium,
    AppColors.blueDark,
  ];

  bool showPassword = false;
  bool showConfirmPassword = false;

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleShowConfirmPassword() {
    setState(() {
      showConfirmPassword = !showConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
        value: viewModel,
        child: Consumer<AuthViewModel>(
            builder: (context, viewModel, child) {
              return Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: colors,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Unisciti a Grocify',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 25),
                        child: SizedBox(
                            width: 325,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 160,
                                    child: TextField(
                                        controller: viewModel.nameController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Nome',
                                          hintText: 'Inserisci il tuo nome',
                                        )
                                    )
                                ),


                                SizedBox(
                                    width: 160,
                                    child: TextField(
                                        controller: viewModel.surnameController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Cognome',
                                          hintText: 'Inserisci il tuo cognome',
                                        )
                                    )
                                )
                              ],
                            )
                        ),
                      ),


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

                      Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: SizedBox(
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
                                      showPassword ? Icons.visibility : Icons
                                          .visibility_off, // Add this line
                                    ),
                                  ),
                                ),
                              )
                          )
                      ),

                      SizedBox(
                          width: 325,
                          child: TextField(
                            controller: viewModel.confirmPasswordController,
                            obscureText: !showConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Conferma password',
                              hintText: 'Reinserisci la password',
                              border: const OutlineInputBorder(),
                              suffixIcon: GestureDetector(
                                onTap: toggleShowConfirmPassword,
                                child: Icon(
                                  showConfirmPassword ? Icons.visibility : Icons
                                      .visibility_off, // Add this line
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
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: SizedBox(
                            width: 325,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: viewModel.areFieldsFilled ? () {
                                  viewModel.signUp();
                                } : null,
                                style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.blueDark)
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Registrati",
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
                        onPressed: () {
                          Navigator.pushNamed(context, SignInScreen.id);
                        },
                        child: const Text(
                            "Hai già un account? Accedi!"
                        ),
                      )

                    ],
                  )
              );
            }
        )
    );
  }
}
