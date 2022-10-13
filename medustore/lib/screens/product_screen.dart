import 'package:flutter/material.dart';
import 'package:medustore/theme/theme_constants.dart';

class ProdcutScreen extends StatelessWidget {
  const ProdcutScreen({super.key, this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    var item = arguments['item'];
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xFF592ee1), Color(0xFFb836d9)]),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                item.thumbnail ??
                    "https://deconova.eu/wp-content/uploads/2016/02/default-placeholder.png",
                fit: BoxFit.cover,
              ),
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Text(
                item.description,
              ),
              Container(
                  height: 80,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: primaryColor),
                    child: const Text('Add To Cart'),
                    onPressed: () {},
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
