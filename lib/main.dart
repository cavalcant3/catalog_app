import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/products_list_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/checkout_processing_screen.dart';
import 'data/products_mock_ds.dart';
import 'state/cart_state.dart';
import 'screens/app_shell.dart';
import 'screens/checkout_address_screen.dart';
import 'screens/checkout_shipping_screen.dart';
import 'screens/checkout_payment_screen.dart';
import 'data/products_hybrid_ds.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    // DataSource mock e estado do carrinho (para o app “grande”)
    final ds = ProductsHybridDataSource();
    final cart = CartState();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0061A8)),
        useMaterial3: true,
      ),
      // Se quiser começar direto no app mock, troque para: '/app'
      initialRoute: '/app',
      routes: {
        // Fluxo atual (login + CRUD real)
        '/': (_) => const LoginScreen(),
        '/products': (_) => const ProductsListScreen(),
        '/product-form': (_) => const ProductFormScreen(),

        // App grande (mock)
        '/app': (_) => AppShell(ds: ds, cart: cart),
        '/checkout/address': (_) => const CheckoutAddressScreen(),
        '/checkout/shipping': (_) => const CheckoutShippingScreen(),
        '/checkout/payment': (_) => const CheckoutPaymentScreen(),
        '/checkout/processing': (_) => const CheckoutProcessingScreen(),
      },
    );
  }
}
