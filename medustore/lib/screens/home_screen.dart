import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medustore/models/product.dart';
import 'package:medustore/screens/cart_screen.dart';
import 'package:medustore/screens/login_screen.dart';
import 'package:medustore/theme/theme_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medustore/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Product> products = [];

  Future<List> httpGetData({link}) async {
    var url = Uri.parse(link);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      products = body["products"].map<Product>(Product.fromJson).toList();
      return products;
    }
    throw json.decode(response.body)['error']['message'];
  }

  void search({required searchQuery}) {
    Navigator.pushNamed(
      context,
      '/search',
      arguments: {
        "products": products,
        "searchQuery": searchQuery,
      },
    );
  }

  void _onItemTapped(int index) async {
    var prefs = await SharedPreferences.getInstance();
    var cartId = prefs.getString('cart');

    if (index == 1 && (cartId == null || cartId.isEmpty)) {
      index++;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text("Medustore"),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: medusaGradient,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Search",
                        filled: true,
                        fillColor: const Color.fromARGB(179, 255, 255, 255),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            width: 1,
                            color: primaryColor,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          color: primaryColor,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              search(searchQuery: _searchController.text);
                            }
                          },
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Search Query';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Latest Products",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: httpGetData(
                      link: '$apiBaseUrl/store/products',
                    ),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('${snapshot.error}'),
                            );
                          } else {
                            final items = snapshot.data as List<dynamic>;
                            return Flexible(
                              child: ListView(shrinkWrap: true, children: [
                                Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 15.0,
                                    runSpacing: 15.0,
                                    children: items.map((item) {
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
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              elevation: 1,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    height: 110,
                                                    child: CachedNetworkImage(
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  progress) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                      imageUrl: item
                                                              .thumbnail ??
                                                          "https://deconova.eu/wp-content/uploads/2016/02/default-placeholder.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(item.title),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ]),
                            );
                          }
                      }
                    })
              ],
            ),
          ),
        ),
        const CartScreen(),
        const LoginScreen(),
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
