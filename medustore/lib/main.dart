import 'package:flutter/material.dart';
import 'package:medustore/screens/cart_screen.dart';
import 'package:medustore/screens/checkout_screen.dart';
import 'package:medustore/screens/home_screen.dart';
import 'package:medustore/screens/loading_screen.dart';
import 'package:medustore/screens/login_screen.dart';
import 'package:medustore/screens/product_screen.dart';
import 'package:medustore/screens/register_screen.dart';
import 'package:medustore/screens/search_screen.dart';
import 'package:medustore/theme/theme_constants.dart';
import 'package:medustore/theme/theme_manager.dart';

void main() {
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medustore',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      initialRoute: '/loading',
      routes: {
        '/': (context) => const HomeScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/account': (context) => const LoginScreen(),
        '/product': (context) => const ProdcutScreen(),
        '/search': (context) => const SearchScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
      },
    );
  }
}
