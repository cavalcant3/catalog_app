// lib/screens/app_shell.dart
import 'package:flutter/material.dart';

import 'package:catalog_app/data/products_data_source.dart';
import 'package:catalog_app/state/cart_state.dart';
import 'package:catalog_app/state/cart_scope.dart';

import 'package:catalog_app/screens/home_screen.dart' as home;
import 'package:catalog_app/screens/catalog_screen.dart' as catalog;
import 'package:catalog_app/screens/cart_screen.dart' as cart;
import 'package:catalog_app/screens/account_screen.dart' as account;

class AppShell extends StatefulWidget {
  final ProductsDataSource ds;
  final CartState cart;
  const AppShell({super.key, required this.ds, required this.cart});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      home.HomeScreen(ds: widget.ds),
      catalog.CatalogScreen(ds: widget.ds),
      cart.CartScreen(cart: widget.cart),
      const account.AccountScreen(),
    ];

    return CartScope(
      cart: widget.cart,
      child: Scaffold(
        body: pages[_index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront),
              label: 'Catálogo',
            ),
            NavigationDestination(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: AnimatedBuilder(
                      animation: widget.cart,
                      builder: (_, __) => _Badge(count: widget.cart.totalItems),
                    ),
                  ),
                ],
              ),
              selectedIcon: const Icon(Icons.shopping_cart),
              label: 'Carrinho',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Conta',
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }
}
