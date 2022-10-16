import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medustore/theme/theme_constants.dart';
import 'package:http/http.dart' as http;
import 'package:medustore/utils/constants.dart';

class ProdcutScreen extends StatefulWidget {
  const ProdcutScreen({super.key, this.item});

  final dynamic item;

  @override
  State<ProdcutScreen> createState() => _ProdcutScreenState();
}

class _ProdcutScreenState extends State<ProdcutScreen> {
  int quantity = 1;

  void addToCart(var item) async {
    try {
      var response = await http.post(
          Uri.parse(
              '$apiBaseUrl/store/carts/cart_01GFE01THSWKXA264M4MC3GXDM/line-items'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "variant_id": item.variantId,
            "quantity": quantity,
          }));
      if (response.statusCode == 200) {
        print("loggedin");
        print(response.body);
      } else {
        print("oops");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    var item = arguments['item'];
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
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
              Image.network(
                item.thumbnail ??
                    "https://deconova.eu/wp-content/uploads/2016/02/default-placeholder.png",
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                item.description,
                style: const TextStyle(color: Color.fromARGB(170, 0, 0, 0)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "Quantity: ",
                    textAlign: TextAlign.left,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                  ),
                  Text(quantity.toString()),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (quantity < 99) quantity++;
                      });
                    },
                  ),
                ],
              ),
              Container(
                  height: 80,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: primaryColor),
                    child: const Text('Add To Cart'),
                    onPressed: () {
                      addToCart(item);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
