import 'package:flutter/material.dart';
import 'package:medustore/models/product.dart';
import 'package:medustore/theme/theme_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> returnSearchResult(List<Product> products, String searchQuery) {
    List<Product> searchResult;
    if (products.isEmpty) return [];

    searchResult = products
        .where((product) =>
            product.title!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return searchResult;
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    List<Product> products = arguments["products"];
    String searchQuery = arguments["searchQuery"];
    return Scaffold(
      appBar: AppBar(
        title: Text(searchQuery),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: medusaGradient,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView(shrinkWrap: true, children: [
            Wrap(
                alignment: WrapAlignment.center,
                spacing: 15.0,
                runSpacing: 15.0,
                children: returnSearchResult(products, searchQuery).isNotEmpty
                    ? returnSearchResult(products, searchQuery).map((item) {
                        return Column(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product',
                                arguments: {'item': item},
                              );
                            },
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 1,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 110,
                                      child: Image.network(
                                        item.thumbnail ??
                                            "https://deconova.eu/wp-content/uploads/2016/02/default-placeholder.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(item.title!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]);
                      }).toList()
                    : [
                        const Text(
                          "No items found",
                        ),
                      ]),
          ]),
        ),
      ),
    );
  }
}
