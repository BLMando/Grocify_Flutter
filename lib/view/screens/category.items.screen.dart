import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocify/models/product.model.dart';
import 'package:grocify/res/dimensions/app.dimensions.dart';
import 'package:provider/provider.dart';

import '../../res/colors/app.colors.dart';
import '../../view_model/category.items.view.model.dart';

class CategoryItemsScreen extends StatefulWidget{
  static const String id = "category_items_screen";

  final String categoryId;

  const CategoryItemsScreen(this.categoryId, {Key? key}) : super(key: key);

  @override
  _CategoryItemsScreenState createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {

  late final CategoryItemsViewModel viewModel;

  @override
  void initState(){
    super.initState();
    viewModel = CategoryItemsViewModel();
    viewModel.getCategoryName(widget.categoryId);
    viewModel.getProducts(widget.categoryId);
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryItemsViewModel>.value(
        value: viewModel,
        child: Consumer<CategoryItemsViewModel>(
            builder: (context, viewModel, child) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(viewModel.categoryName),
                  elevation: 6,
                  surfaceTintColor: Colors.white,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final category = viewModel.products[index];
                      return _productCard(category);
                    },
                  ),
                  ),
              );
            }
        )
    );
  }

  Widget _productCard(ProductModel product) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 3, // Adjust the flex values as needed
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Flexible(
              child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
              ),
          ),

          const SizedBox(height: 10),

          Flexible(
            child:
              product.discount != 0.0
                  ? RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${product.price.toStringAsFixed(2)}€",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: "${(product.price * (100.0 - product.discount) / 100.0).toStringAsFixed(2)}€",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "/${product.quantity}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
                  : RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${product.price.toStringAsFixed(2)}€",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "/${product.quantity}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ),

          const SizedBox(height: 10),

          Flexible(
              child: ElevatedButton(

                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.blueDark)
                ),
                onPressed: () {
                  print("Button pressed");
                },
                child: const Text(
                  "Aggiungi",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimension.defaultText
                  ),),
              ),
          )
        ],
      ),
    );
  }
}