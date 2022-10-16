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
  Future<List> getCartItems() async {
    var values = await SharedPreferences.getInstance();
    var cart = values.getString('cart');
    var response = await http.post(
      Uri.parse('$apiBaseUrl/store/carts/$cart'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      print("fetched cart data");
      var items = jsonDecode(response.body)["cart"]["items"];
      return items;
    } else {
      print("hmm");
    }
    throw json.decode(response.body);
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
                          return Center(
                            child: Text('${snapshot.error}'),
                          );
                        } else {
                          final items = snapshot.data as List<dynamic>;
                          return Flexible(
                              child: ListView(
                                  shrinkWrap: true,
                                  children: items.map((item) {
                                    return Text(
                                        "${item['title']} - ${item['quantity']}");
                                  }).toList()));
                        }
                    }
                  })
            ])));
  }
}
