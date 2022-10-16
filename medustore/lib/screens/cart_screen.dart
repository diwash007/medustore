import 'package:flutter/material.dart';
import 'package:medustore/theme/theme_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  void test() async {
    var values = await SharedPreferences.getInstance();
    var cart = values.getString('cart');
    print(cart);
  }

  @override
  Widget build(BuildContext context) {
    test();
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
                    children: []))));
  }
}
