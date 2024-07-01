import 'package:flutter/material.dart';
import 'package:grocify/models/category.model.dart';
import 'package:grocify/res/dimensions/app.dimensions.dart';
import 'package:grocify/viewmodels/catalog.view.model.dart';
import 'package:provider/provider.dart';
import 'category.items.screen.dart';

class CatalogScreen extends StatelessWidget{
  static const String id = "catalog_screen";

  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CatalogViewModel viewModel = CatalogViewModel();

    return ChangeNotifierProvider<CatalogViewModel>.value(
      value: viewModel,
      child: Consumer<CatalogViewModel>(
        builder: (context, viewModel, child) {
          viewModel.getSignedInUserName();
          viewModel.getCategories();

          return Scaffold(
            appBar: AppBar(
              shadowColor: Colors.black,
              elevation: AppDimension.mediumElevation,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              surfaceTintColor: Colors.white,
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 24),
                  children: [
                    const TextSpan(text: "Ciao ",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black)
                    ),
                    TextSpan(
                        text: viewModel.currentUserName,
                        style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black)
                    ),
                  ],
                ),
              ),
              leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.asset(
                      'assets/images/icon.png'
                  )
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Cerca per categoria',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimension.mediumText,
                        ),
                      ),
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 0.6,
                      height: 20
                    ),

                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: viewModel.categories.length, // Replace with uiState.value.categories.size
                        itemBuilder: (context, index) {
                          return CategoryCard(
                            category: CategoryModel(
                                id: viewModel.categories[index].id,
                                name: viewModel.categories[index].name,
                                image: viewModel.categories[index].image
                            ),
                            onCategoryClick: () {
                              Navigator.pushNamed(context, CategoryItemsScreen.id, arguments: viewModel.categories[index].id);
                            },
                          );
                        },
                      )
                    ),
                  ],
                ),
            )
          );
        }
      )
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onCategoryClick;

  const CategoryCard({super.key, required this.category, required this.onCategoryClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCategoryClick,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: AppDimension.cardElevation,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.network(
                      category.image!,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
              ),

              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    category.name!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: AppDimension.smallText,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}

