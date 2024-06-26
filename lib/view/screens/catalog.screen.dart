import 'package:flutter/material.dart';
import 'package:grocify/firebase/auth.service.dart';
import 'package:grocify/models/category.model.dart';
import 'package:grocify/view_model/catalog.view.model.dart';
import 'package:provider/provider.dart';

import 'category.items.screen.dart';

class CatalogScreen extends StatefulWidget{
  static const String id = "catalog_screen";

  const CatalogScreen({Key? key}) : super(key: key);

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {

  late final CatalogViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CatalogViewModel();
    viewModel.getSignedInUserName();
    viewModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CatalogViewModel>.value(
        value: viewModel,
        child: Consumer<CatalogViewModel>(
            builder: (context, viewModel, child) {
              return Scaffold(
                appBar: AppBar(
                    elevation: 6,
                    surfaceTintColor: Colors.white,
                    title: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 24),
                        children: [
                          const TextSpan(text: "Ciao ",
                              style: TextStyle(fontWeight: FontWeight.w300,
                                  color: Colors.black)),
                          TextSpan(text: viewModel.currentUserName, style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                        ],
                      ),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap: AuthService().signOut,
                        child: Image.asset(
                            'assets/images/icon.png')
                      )
                    ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      const Text(
                        "Cerca per categoria",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.6,
                        height: 30,
                        endIndent: 10,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.categories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final category = viewModel.categories[index];
                          return _categoryCard(category);
                        },
                      ),
                    ],
                  ),
                ),

              );
            }
        )
    );
  }

  Widget _categoryCard(CategoryModel category){
    return GestureDetector(
      onTap: () {
        _goToDetailScreen(context, category.id!);
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 2, // Adjust the flex values as needed
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  category.image!,
                  fit: BoxFit.fitWidth,
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
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  category.name!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _goToDetailScreen(BuildContext context, String categoryId) {
    Navigator.pushNamed(context, CategoryItemsScreen.id, arguments: categoryId);
  }
}
