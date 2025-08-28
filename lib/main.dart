import 'package:flutter/material.dart';


import 'screens/login_screen.dart';
import 'screens/products_list_screen.dart';
import 'screens/product_form_screen.dart';


void main() {
  runApp(const CatalogApp());
}


class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0061A8)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/products': (_) => const ProductsListScreen(),
        '/product-form': (_) => const ProductFormScreen(),
      },
    );
  }
}