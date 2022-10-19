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
  dynamic cart;

  Future<List> getCartItems() async {
    try {
      var values = await SharedPreferences.getInstance();
      cartId = values.getString('cart');
      var response = await http.post(
        Uri.parse('$apiBaseUrl/store/carts/$cartId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        cart = jsonDecode(response.body)["cart"];
        items = cart["items"];
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: items.map(
                                (item) {
                                  return Card(
                                    elevation: 1.0,
                                    child: ListTile(
                                      leading: Image.network(
                                        item["thumbnail"],
                                        fit: BoxFit.cover,
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
                                },
                              ).toList(),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Total:\t\$${cart["total"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                                height: 80,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(50),
                                      backgroundColor: primaryColor),
                                  child: const Text('Checkout'),
                                  onPressed: () {},
                                ))
                          ],
                        );
                      }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
