import 'package:flutter/material.dart';
import 'package:grocify/res/colors/app.colors.dart';
import 'package:grocify/res/dimensions/app.dimensions.dart';
import 'package:grocify/views/screens/home.screen.dart';
import 'package:grocify/views/screens/signup.screen.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth.view.model.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "signin_screen";

  const SignInScreen({super.key});

  @override
  SignInScreenState createState() =>SignInScreenState();
}

class SignInScreenState extends State<SignInScreen>{

  late final AuthViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AuthViewModel(procedureType: "sign_in");
    /// checks if there is a signed-in user.
    /// if true does a redirect to the home screen.
    if(viewModel.currentUser != null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, HomeScreen.id);
      });
    }
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
          builder: (context, viewModel, child){

            /// if the user has the role of normal user it can login.
            if (viewModel.hasPermissions && viewModel.statusMessage.isEmpty){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, HomeScreen.id);
              });
            }

            return Scaffold(
              resizeToAvoidBottomInset: false, // Prevent resizing of the Scaffold
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.minHeight,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Image(
                                image: AssetImage('assets/images/icon.png'),
                                width: 150,
                                height: 150,
                              ),

                              const Text.rich(
                                TextSpan(
                                  text: "Benvenuto su ",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Grocify",
                                      style: TextStyle(
                                        color: AppColors.blueLight,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(2, 2),
                                            blurRadius: 2,
                                          )
                                        ],
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Accedi al tuo account",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF030303),
                                ),
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
                                    ),
                                  ),
                                ),
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
                                        showPassword ? Icons.visibility : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (viewModel.statusMessage.isNotEmpty) Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  viewModel.statusMessage,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: AppDimension.smallText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 30),
                                child: SizedBox(
                                  width: 325,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: viewModel.areFieldsFilled ? () {
                                      viewModel.signIn();
                                    } : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blueDark,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "Accedi",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, SignUpScreen.id);
                                },
                                child: const Text("Non hai un account? Registrati ora!"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
      )
    );
  }
}

