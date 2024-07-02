import 'package:flutter/material.dart';
import 'package:grocify/res/dimensions/app.dimensions.dart';
import 'package:grocify/views/screens/home.screen.dart';
import 'package:grocify/views/screens/track.order.screen.dart';

import '../../res/colors/app.colors.dart';

class OrderSuccessScreen extends StatelessWidget{

  static const String id = "order_success_screen";
  final String orderId;

  const OrderSuccessScreen(this.orderId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Perfetto!",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/icon.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "Il tuo ordine è stato effettuato con successo!",
                style: TextStyle(
                  fontSize: AppDimension.bigText,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, HomeScreen.id),
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(AppColors.blueDark),
                        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        )),
                    ),
                    child: const Text(
                      "Ritorna al catalogo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimension.smallText
                      ),
                    )
                  ),

                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, TrackOrderScreen.id, arguments: orderId),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      side: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    child: const Text(
                      "Monitora l'ordine",
                      style: TextStyle(
                        fontSize: AppDimension.smallText,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}