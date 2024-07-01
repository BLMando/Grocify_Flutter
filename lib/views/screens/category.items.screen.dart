import 'package:flutter/material.dart';
import 'package:grocify/models/product.model.dart';
import 'package:provider/provider.dart';
import '../../res/colors/app.colors.dart';
import '../../res/dimensions/app.dimensions.dart';
import '../../viewmodels/category.items.view.model.dart';

class CategoryItemsScreen extends StatelessWidget {
  static const String id = "category_items_screen";
  final String categoryId;

  const CategoryItemsScreen(this.categoryId, {super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryItemsViewModel viewModel = CategoryItemsViewModel();

    viewModel.initializeProductsList();

    return ChangeNotifierProvider<CategoryItemsViewModel>.value(
        value: viewModel,
        child: Consumer<CategoryItemsViewModel>(
            builder: (context, viewModel, child) {
              viewModel.getCategoryName(categoryId);
              viewModel.getProducts(categoryId);
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                      viewModel.categoryName,
                      style: const TextStyle(
                        fontSize: AppDimension.appBarText,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Handle back button press
                      Navigator.pop(context);
                    },
                  ),
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
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      if (viewModel.products.isNotEmpty)
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: viewModel.products.length,
                            itemBuilder: (context, index) {
                              return CategoryItemCard(
                                product: viewModel.products[index],
                              viewModel: viewModel,);
                            },
                          ),
                        )
                      else
                        const Expanded(
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              "Nessun prodotto presente in questa categoria",
                              style: TextStyle(
                                fontSize: AppDimension.mediumText,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
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

class CategoryItemCard extends StatefulWidget {
  final ProductModel product;
  final CategoryItemsViewModel viewModel;

  const CategoryItemCard({super.key, required this.product, required this.viewModel});

  @override
  CategoryItemState createState() => CategoryItemState();

}
class CategoryItemState extends State<CategoryItemCard>{

  late bool isAddingToCart;

  @override
  void initState() {
    super.initState();
    isAddingToCart = false;
  }

  void updateState() {
    setState(() {
      isAddingToCart = !isAddingToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
        elevation: AppDimension.mediumElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Flexible(
                flex: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.network(
                    widget.product.image,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                )
            ),

            Flexible(
              flex: 4,
              child: Text(
                widget.product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppDimension.defaultText,
                  color: Color(0xFF3f4145),
                ),
              )
            ),

            Flexible(
              flex: 4,
              child: widget.product.discount != 0.0 ?
              RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.product.price}€",
                          style: const TextStyle(
                            fontSize: AppDimension.smallText,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        TextSpan(
                          text: "${(widget.product.price * (100.0 - widget.product.discount) / 100.0).toStringAsFixed(1)}€",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "/${widget.product.quantity}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )

                  :
              Text(
                  textAlign: TextAlign.center,
                  "${widget.product.price}€/${widget.product.quantity}",
                  style: const TextStyle(
                    fontSize: AppDimension.smallText,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
              ),
            ),

            Flexible(
                flex: 5,
                child: ElevatedButton(
                  onPressed: () {
                    widget.viewModel.addToCart(widget.product);
                    /*if (!isAddingToCart) {
                      updateState();
                    }*/
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: isAddingToCart ? Colors.black : AppColors.blueMedium,
                    disabledForegroundColor: AppColors.blueLight.withOpacity(0.38),
                    disabledBackgroundColor: AppColors.blueLight.withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: isAddingToCart
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : const Text("Aggiungi"),
                ),
              )
          ],
        )
      )
    );
  }
}