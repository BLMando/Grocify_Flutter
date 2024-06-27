import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../view_model/track.order.view.model.dart';

class TrackOrderScreen extends StatelessWidget {
  static const String id = "track_screen";
  final String orderId;

  const TrackOrderScreen(this.orderId, {super.key});

  @override
  Widget build(BuildContext context) {

    final TrackOrderViewModel viewModel = TrackOrderViewModel();

    return ChangeNotifierProvider<TrackOrderViewModel>.value(
        value: viewModel,
        child: Consumer<TrackOrderViewModel>(
        builder: (context, viewModel, child) {
          viewModel.getCurrentOrder(orderId);

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Stato dell\'ordine',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body:
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'N° $orderId',
                            style: const TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),

                      TrackingState(
                        icon: Icons.local_shipping,
                        text: 'Ordine in corso di elaborazione',
                        subText:
                        'Ordine effettuato in data ${viewModel.order.date} alle ore ${viewModel.order.time}.',
                        active: true,
                      ),

                      TrackingState(
                        icon: Icons.access_time_filled,
                        text: 'In preparazione',
                        subText: viewModel.order.status == "in attesa" ? "" :
                        'Stiamo preparando la tua spesa. ${DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now())}',
                        active: viewModel.order.status == "in preparazione" || viewModel.order.status == "in consegna" || viewModel.order.status == "consegnato",
                      ),

                      TrackingState(
                        icon: Icons.map,
                        text: 'In consegna',
                        subText: viewModel.order.status != "in consegna" && viewModel.order.status != "consegnato" ? "" :
                        'La tua spesa è in arrivo con un nostro driver. ${DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now())}',
                        active: viewModel.order.status == "in consegna" || viewModel.order.status == "consegnato",
                      ),

                      TrackingState(
                        icon: Icons.check_circle,
                        text: 'Consegnato',
                        subText: viewModel.order.status != "consegnato" ? "" :
                        'La tua spesa è stata consegnata, apri il QR Code in basso. ${DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now())}',
                        active: viewModel.order.status == "consegnato",
                      ),

                      viewModel.order.status == "consegnato" ?
                        QRCodeInfo(orderId,viewModel) : const SizedBox(height: 50)
                    ],
                  ),
                ),
              )
          );
        }
      )
    );
  }
}

class QRCodeInfo extends StatelessWidget {
  final String orderId;
  final TrackOrderViewModel viewModel;

  const QRCodeInfo(this.orderId, this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {

    viewModel.getDriverName(orderId);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Divider(
                    color: Colors.blue,
                    thickness: 5,
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Il tuo driver:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        viewModel.driverName,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Numero di prodotti:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "${viewModel.order.cart.length}", // Replace with actual number of products
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Prezzo totale:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${viewModel.order.totalPrice}€', // Replace with actual total price
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 20,
                  ),
                  const Text(
                    'Fai scansionare il QR CODE al driver dopo aver ricevuto la spesa',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child:  QrImageView(
                      data: orderId,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_circle_up, color: Colors.blue),
          SizedBox(width: 5),
          Text(
            'Swipe up per aprire QR Code',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

class TrackingState extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subText;
  final bool active;

  const TrackingState({super.key,
    required this.icon,
    required this.text,
    required this.subText,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: active ? Colors.blue : Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}