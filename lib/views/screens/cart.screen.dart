
import 'package:flutter/material.dart';
import 'package:grocify/res/colors/app.colors.dart';
import 'package:grocify/res/dimensions/app.dimensions.dart';
import 'package:grocify/views/screens/order.success.screen.dart';
import 'package:provider/provider.dart';
import '../../data/local/product.dart';
import '../../viewmodels/cart.view.model.dart';

class CartScreen extends StatelessWidget{
  static const String id = "cart_screen";

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartViewModel viewModel = CartViewModel();

    viewModel.initializeProductsList();

    return ChangeNotifierProvider<CartViewModel>.value(
        value: viewModel,
        child: Consumer<CartViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Il tuo carrello",
                  style: TextStyle(
                    fontSize: AppDimension.appBarText,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                shadowColor: Colors.black,
                surfaceTintColor: Colors.white,
                elevation: AppDimension.highElevation,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (viewModel.productsList.isEmpty)
                      const Center(
                        child: Text(
                          "Nessun prodotto nel carrello",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppDimension.mediumText,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Prodotti aggiunti al carrello",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppDimension.mediumText,
                              ),
                            ),
                            const Divider(
                              color: AppColors.lightGrey,
                              thickness: 0.6,
                              height: 25,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: viewModel.productsList.length,
                                itemBuilder: (context, index) {
                                  final product = viewModel.productsList[index];
                                  return CartItem(
                                    product: product,
                                    viewModel: viewModel
                                  );
                                },
                              ),
                            ),
                            if (viewModel.totalPrice > 1.5)
                              CheckoutBox(
                                title: "Riepilogo ordine",
                                subtotal: "${(viewModel.totalPrice - 1.50).toStringAsFixed(2)}€",
                                shipping: "1.50€",
                                total: "${viewModel.totalPrice.toStringAsFixed(2)}€",
                                buttonText: "Checkout",
                                onCheckoutClick: () async {
                                  await viewModel.createNewOrder();
                                  if (context.mounted) {
                                    if (!viewModel.flagSelectedAddress) {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => const CheckoutDialog(
                                          description: "Impossibile procedere: non hai alcun indirizzo di spedizione selezionato!",
                                        ),
                                      );
                                    } else if (viewModel.flagOrder) {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => const CheckoutDialog(
                                          description: "Impossibile procedere: hai attualmente un ordine in corso!",
                                        ),
                                      );
                                    } else {
                                      Navigator.pushNamed(context, OrderSuccessScreen.id, arguments: viewModel.orderId);
                                    }
                                  }
                                },
                              ),
                          ],
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

class CheckoutDialog extends StatelessWidget {

  final String description;

  const CheckoutDialog({super.key, required this.description});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text(
          "Informazioni",
          style : TextStyle(
            fontWeight : FontWeight.bold,
            fontSize : 20,
          ),
          textAlign : TextAlign.center,
      ),
      content:  SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

              const Padding(
                padding: EdgeInsets.only(top: 35),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.blueMedium,
                  size: 70
                )
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Text(
                    description,
                    textAlign : TextAlign.center,
                    style: const TextStyle(
                      fontSize : 15,
                    ),
                )
              )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text(
            "Ho capito",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}

class CheckoutBox extends StatelessWidget {
  final String title;
  final String subtotal;
  final String shipping;
  final String total;
  final String buttonText;
  final VoidCallback onCheckoutClick;

  const CheckoutBox({
    super.key,
    required this.title,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.buttonText,
    required this.onCheckoutClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightGrey,
      elevation: AppDimension.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Totale parziale"),
                Text(subtotal),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Spedizione"),
                Text(shipping),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Totale",
                  style: TextStyle(
                    fontSize: AppDimension.mediumText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  total,
                  style: const TextStyle(
                    fontSize: AppDimension.mediumText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onCheckoutClick,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final Product product;
  final CartViewModel viewModel;

  const CartItem({
    super.key,
    required this.product,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: AppDimension.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  product.image,
                  width: 60,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.blueMedium),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimension.smallText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (product.price != 0.0)
                      if (product.discount != 0.0)
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${product.price.toStringAsFixed(2)}€",
                                style: const TextStyle(
                                  fontSize: AppDimension.verySmallText,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),

                              TextSpan(
                                text: "${(product.price * (100.0 - product.discount) / 100.0).toStringAsFixed(2)}€",
                                style: const TextStyle(
                                  fontSize: AppDimension.smallText,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "/${product.quantity}",
                                style: const TextStyle(
                                  fontSize: AppDimension.verySmallText,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${product.price}€",
                                style: const TextStyle(
                                  fontSize: AppDimension.smallText,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "/${product.quantity}",
                                style: const TextStyle(
                                  fontSize: AppDimension.verySmallText,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                    else
                      Text(
                        "Units x ${product.quantity}",
                        style: const TextStyle(
                          fontSize: AppDimension.smallText,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                ItemsQuantitySelector(
                  product: product,
                  viewModel: viewModel,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    viewModel.removeFromCart(product);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsQuantitySelector extends StatefulWidget {
  final Product product;
  final CartViewModel viewModel;

  const ItemsQuantitySelector({
    super.key,
    required this.product,
    required this.viewModel,
  });

  @override
  ItemsQuantitySelectorState createState() => ItemsQuantitySelectorState();
}

class ItemsQuantitySelectorState extends State<ItemsQuantitySelector> {
  late int state;

  @override
  void initState() {
    super.initState();
    state = widget.product.units;
  }

  Future<void> updateUnits(int delta) async {
      await widget.viewModel.addValueToProductUnits(widget.product, delta);

      setState(() {
        state = widget.viewModel.getUnitsById(widget.product.id);
      });
  }

  @override
  Widget build(BuildContext context) {
    return
      Card(
      color: Colors.white,
      elevation: AppDimension.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (state > 1) {
                updateUnits(-1);
              }
            },
            icon: const Icon(Icons.remove, size: 18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              '${widget.product.units}',
              style: const TextStyle(fontSize: AppDimension.smallText),
            ),
          ),
          IconButton(
            onPressed: () {
                updateUnits(1);
            },
            icon: const Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );

  }
}