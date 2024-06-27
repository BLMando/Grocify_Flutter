import 'package:flutter/material.dart';
import 'package:grocify/res/colors/app.colors.dart';
import 'package:grocify/utils/utils.dart';
import 'package:grocify/view/screens/track.order.screen.dart';
import 'package:provider/provider.dart';
import '../../models/order.model.dart';
import '../../view_model/orders.view.model.dart';

class OrdersScreen extends StatelessWidget {
  static const String id = "orders_screen";

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersViewModel viewModel = OrdersViewModel();

    return ChangeNotifierProvider<OrdersViewModel>.value(
        value: viewModel,
        child: Consumer<OrdersViewModel>(
            builder: (context, viewModel, child) {

              viewModel.getAllOrders();

              List<OrderModel> currentOrder = viewModel.orders.where((
                  order) => order.status != "concluso").toList();

              List<OrderModel> pastOrders = viewModel.orders.where((
                  order) => order.status == "concluso").toList();

              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Storico degli ordini",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ordine corrente",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      if (currentOrder.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Nessun ordine in corso",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )
                      else
                        OrderCard(
                          order: currentOrder[0],
                          iconState: Icons.departure_board,
                          actualOrder: true
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        "Ordini passati",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      if (pastOrders.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Nessun ordine effettuato",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: pastOrders.length,
                            itemBuilder: (context, index) {
                              return OrderCard(
                                viewModel: viewModel,
                                order: pastOrders[index],
                                iconState: Icons.done,
                                actualOrder: false
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }
}

class OrderCard extends StatelessWidget {
    final OrdersViewModel? viewModel;
    final OrderModel order;
    final IconData iconState;
    final bool actualOrder;

    const OrderCard({
        super.key,
        this.viewModel,
        required this.order,
        required this.iconState,
        required this.actualOrder
    });

  @override
  Widget build(BuildContext context) {

    Color spotColor = actualOrder ? Colors.blueAccent : Colors.black;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: spotColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ordine ${order.orderId}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),

                Text("Data: ${order.date}"),

                const SizedBox(height: 5),

                Text("Totale: ${order.totalPrice}€"),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.blueMedium),
                    borderRadius: const BorderRadius.all(Radius.circular(30))
                  ),
                  child: Row(
                    children: [
                      Icon(iconState),
                      const SizedBox(width: 5),
                      Text(Utils.capitalizeFirstLetter(order.status)),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                if(actualOrder)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.blueMedium),
                        borderRadius: const BorderRadius.all(Radius.circular(30))
                    ),
                    child:
                      GestureDetector(
                      onTap: () {
                          _goToTrackOrder(context,order.orderId);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.local_shipping),
                          SizedBox(width: 5),
                          Text("Traccia l'ordine"),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


void _goToTrackOrder(BuildContext context, String orderId) {
  Navigator.pushNamed(context, TrackOrderScreen.id, arguments: orderId);
}

