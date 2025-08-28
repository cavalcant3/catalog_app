// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../state/cart_state.dart';

String formatBRL(double v) => 'R\$ ${v.toStringAsFixed(2)}';

class CartScreen extends StatelessWidget {
  final CartState cart;
  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Seu carrinho está vazio.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final it = cart.items[i];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
                title: Text(it.product.name),
                subtitle: Text(formatBRL(it.product.price)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Diminuir',
                      onPressed: () => cart.removeOne(it.product),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('${it.qty}'),
                    IconButton(
                      tooltip: 'Aumentar',
                      onPressed: () => cart.add(it.product),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    IconButton(
                      tooltip: 'Remover',
                      onPressed: () => cart.remove(it.product),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: AnimatedBuilder(
          animation: cart,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: ${formatBRL(cart.totalPrice)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                FilledButton(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () => Navigator.of(context).pushNamed('/checkout/address'),
                  child: const Text('Finalizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
