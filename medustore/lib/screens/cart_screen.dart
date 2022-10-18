import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medustore/theme/theme_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? cartId;
  dynamic items;
  Future<List> getCartItems() async {
    try {
      var values = await SharedPreferences.getInstance();
      cartId = values.getString('cart');
      var response = await http.post(
        Uri.parse('$apiBaseUrl/store/carts/$cartId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        items = jsonDecode(response.body)["cart"]["items"];
      }
      return items;
    } catch (e) {
      return items;
    }
  }

  void updateCartItem(String cartId, String productId, int quantity) async {
    if (quantity <= 0) return;
    try {
      var response = await http.post(
        Uri.parse('$apiBaseUrl/store/carts/$cartId/line-items/$productId'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {"quantity": quantity},
        ),
      );
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Cart"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: medusaGradient,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FutureBuilder(
                  future: getCartItems(),
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
                          return const Center(
                            child:
                                Text('Something went wrong. Please try again.'),
                          );
                        } else {
                          final items = snapshot.data as List<dynamic>;
                          return Flexible(
                              child: ListView(
                                  shrinkWrap: true,
                                  children: items.map((item) {
                                    return Card(
                                      elevation: 1.0,
                                      child: ListTile(
                                        leading: Image(
                                          height: 80,
                                          width: 80,
                                          image: NetworkImage(
                                            item["thumbnail"],
                                          ),
                                        ),
                                        title: Text(
                                          item["title"],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle,
                                                color: primaryColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  updateCartItem(
                                                      cartId!,
                                                      item["id"],
                                                      item["quantity"] - 1);
                                                });
                                              },
                                            ),
                                            Text(item["quantity"].toString()),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add_circle,
                                                color: primaryColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  updateCartItem(
                                                      cartId!,
                                                      item["id"],
                                                      item["quantity"] + 1);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          '\$${item["total"]}',
                                        ),
                                      ),
                                    );
                                  }).toList()));
                        }
                    }
                  })
            ])));
  }
}
