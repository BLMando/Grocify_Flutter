import 'package:flutter/material.dart';
import 'package:grocify/res/dimensions/app.dimensions.dart';
import 'package:grocify/view/screens/catalog.screen.dart';
import 'package:grocify/view/screens/track.order.screen.dart';
import 'package:provider/provider.dart';
import '../../view_model/order.success.view.model.dart';

class OrderSuccessScreen extends StatelessWidget{

  static const String id = "order_success_screen";

  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderSuccessViewModel viewModel = OrderSuccessViewModel();

    return ChangeNotifierProvider<OrderSuccessViewModel>.value(
        value: viewModel,
        child: Consumer<OrderSuccessViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Perfetto!",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/icon.png', // Make sure the image path is correct
                        height: 160,
                        width: 160,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Il tuo ordine è stato effettuato con successo!",
                        style: TextStyle(
                          fontSize: AppDimension.bigText,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, CatalogScreen.id),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                            child: const Text("Ritorna al catalogo"),
                          ),

                          OutlinedButton(
                            onPressed: () => Navigator.pushNamed(context, TrackOrderScreen.id),
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
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            );
          }
        )
    );
  }
}