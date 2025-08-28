// lib/main.dart
import 'package:flutter/material.dart';

// Estado global do carrinho e escopo
import 'state/cart_state.dart';
import 'state/cart_scope.dart';

// DataSource híbrido (mock + API)
import 'data/products_hybrid_ds.dart';

// Telas
import 'screens/app_shell.dart';
import 'screens/login_screen.dart';
import 'screens/products_list_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/checkout_address_screen.dart';
import 'screens/checkout_shipping_screen.dart';
import 'screens/checkout_payment_screen.dart';
import 'screens/checkout_processing_screen.dart';

void main() {
  // Instâncias únicas para toda a aplicação
  final ds = ProductsHybridDataSource();
  final cart = CartState();

  runApp(
    // CartScope no TOPO: todas as rotas (incluindo checkout) têm acesso
    CartScope(
      cart: cart,
      child: CatalogApp(ds: ds, cart: cart),
    ),
  );
}

class CatalogApp extends StatelessWidget {
  final ProductsHybridDataSource ds;
  final CartState cart;
  const CatalogApp({super.key, required this.ds, required this.cart});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0061A8)),
        useMaterial3: true,
      ),
      // Mantém o login como primeira tela
      initialRoute: '/',
      routes: {
        // Login
        '/': (_) => const LoginScreen(),

        // App com abas (Home/Catálogo/Carrinho/Conta), usando DS híbrido
        '/app': (_) => AppShell(ds: ds, cart: cart),

        // CRUD (Admin)
        '/products': (_) => const ProductsListScreen(),
        '/product-form': (_) => const ProductFormScreen(),

        // Checkout
        '/checkout/address': (_) => const CheckoutAddressScreen(),
        '/checkout/shipping': (_) => const CheckoutShippingScreen(),
        '/checkout/payment': (_) => const CheckoutPaymentScreen(),
        '/checkout/processing': (_) => const CheckoutProcessingScreen(),
      },
    );
  }
}
