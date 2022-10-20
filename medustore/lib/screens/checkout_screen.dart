import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medustore/theme/theme_constants.dart';
import 'package:medustore/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum PaymentMethod { cod, card }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  dynamic cart;
  PaymentMethod paymentMethod = PaymentMethod.cod;

  Future<Map<String, dynamic>> getCart() async {
    try {
      var values = await SharedPreferences.getInstance();
      var cartId = values.getString('cart');
      var response = await http.post(
        Uri.parse('$apiBaseUrl/store/carts/$cartId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        cart = jsonDecode(response.body)["cart"];
      }
      return cart;
    } catch (e) {
      return cart;
    }
  }

  Future<void> addShippingAddress() async {
    try {
      var values = await SharedPreferences.getInstance();
      var cartId = values.getString('cart');
      var response = await http.post(
        Uri.parse('$apiBaseUrl/store/carts/$cartId'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "shipping_address": {
              "company": "abc",
              "first_name": "abc",
              "last_name": "abc",
              "address_1": "abc",
              "city": "abc"
            }
          },
        ),
      );
      print(response.body);
      if (response.statusCode == 200) {}
    } catch (e) {
      print(".............");
    }
  }

  Future<void> initializePaymentSession() async {
    try {
      var values = await SharedPreferences.getInstance();
      var cartId = values.getString('cart');
      var response = await http.post(
        Uri.parse('$apiBaseUrl/store/carts/$cartId/payment-sessions'),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200) {}
    } catch (e) {}
  }

  Future<void> selectPaymentSession() async {
    try {
      var values = await SharedPreferences.getInstance();
      var cartId = values.getString('cart');
      var response = await http.post(
          Uri.parse('$apiBaseUrl/store/carts/$cartId/payment-session'),
          headers: {
            "Content-Type": "application/json"
          },
          body: {
            "provider_id": "stripe",
          });
      print(response.body);
      if (response.statusCode == 200) {}
    } catch (e) {}
  }

  Future<String> getPaymentOption() async {
    String shippingId = "";
    try {
      var response =
          await http.get(Uri.parse('$apiBaseUrl/store/shipping-options'));
      if (response.statusCode == 200) {
        shippingId = jsonDecode(response.body)["shipping_options"][0]["id"];
        print(shippingId);
      }
      return shippingId;
    } catch (e) {
      return shippingId;
    }
  }

  Future<void> addShippingMethod(String optionId) async {
    try {
      var values = await SharedPreferences.getInstance();
      var cartId = values.getString('cart');
      var response = await http.post(
          Uri.parse('$apiBaseUrl/store/carts/$cartId/shippinng-methods'),
          headers: {
            "Content-Type": "application/json"
          },
          body: {
            "option_id": optionId,
          });
      print(response.body);
      if (response.statusCode == 200) {}
    } catch (e) {}
  }

  Future<void> placeOrder() async {
    try {
      var values = await SharedPreferences.getInstance();
      var cartId = values.getString('cart');
      var response = await http.post(
        Uri.parse('$apiBaseUrl/store/carts/$cartId/complete'),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200) {
        print("Hjello");
      }
    } catch (e) {
      print(e);
      return cart;
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
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
                future: getCart(),
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
                        var cart = snapshot.data as Map<String, dynamic>;
                        List items = cart["items"];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: items.map(
                                (item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${item["title"]} x ${item["quantity"]}"),
                                        Text("\$${item["total"]}"),
                                      ],
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
                                "Total: \$${cart["total"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(),
                            Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Select Payment Method:',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: PaymentMethod.cod,
                                      groupValue: paymentMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          paymentMethod =
                                              value as PaymentMethod;
                                        });
                                      },
                                    ),
                                    const Text('Cash on Delivery'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: PaymentMethod.card,
                                      groupValue: paymentMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          paymentMethod =
                                              value as PaymentMethod;
                                        });
                                      },
                                    ),
                                    const Text('Card'),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(),
                            paymentMethod == PaymentMethod.cod
                                ? Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Billing Information:'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                labelText: 'Address',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Address field is required";
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                labelText: 'Phone Number',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Phone Number is required";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: primaryColor),
                                child: const Text('Place Order'),
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    await addShippingAddress();
                                    String shippingOptionId =
                                        await getPaymentOption();
                                    await initializePaymentSession();
                                    await selectPaymentSession();
                                    await addShippingMethod(shippingOptionId);
                                    await placeOrder();
                                  }
                                },
                              ),
                            ),
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


















//  ListTile(
//                                       leading: Image.network(
//                                         item["thumbnail"],
//                                         fit: BoxFit.cover,
//                                       ),
//                                       title: Text(
//                                         item["title"],
//                                       ),
//                                       subtitle: Row(
//                                         children: [
//                                           IconButton(
//                                             icon: const Icon(
//                                               Icons.remove_circle,
//                                               color: primaryColor,
//                                             ),
//                                             onPressed: () {},
//                                           ),
//                                           Text(item["quantity"].toString()),
//                                           IconButton(
//                                             icon: const Icon(
//                                               Icons.add_circle,
//                                               color: primaryColor,
//                                             ),
//                                             onPressed: () {},
//                                           ),
//                                         ],
//                                       ),
//                                       trailing: Text(
//                                         '\$${item["total"]}',
//                                       ),
//                                     ),