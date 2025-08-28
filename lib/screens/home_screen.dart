import 'package:flutter/material.dart';
import '../data/products_data_source.dart';
import '../models/product.dart';
import '../state/cart_scope.dart';
import 'product_detail_screen.dart';

String formatBRL(double v) => 'R\$ ${v.toStringAsFixed(2)}';

class HomeScreen extends StatelessWidget {
  final ProductsDataSource ds;
  const HomeScreen({super.key, required this.ds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loja — Home')),
      body: FutureBuilder<List<Product>>(
        future: ds.list(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erro: ${snap.error}'));
          }
          final items = snap.data ?? const <Product>[];
          if (items.isEmpty) {
            return const Center(child: Text('Sem produtos (mock).'));
          }
          final highlights = items.take(5).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeroBanner(onShop: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: highlights.first),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Text('Destaques', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: highlights.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) => _ProductCard(p: highlights[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final VoidCallback onShop;
  const _HeroBanner({required this.onShop});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(.15),
            Theme.of(context).colorScheme.secondary.withOpacity(.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bem-vindo! 👋', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                const Text('Confira nossos destaques e promoções mockadas.'),
                const SizedBox(height: 12),
                FilledButton(onPressed: onShop, child: const Text('Ver produto')),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product p;
  const _ProductCard({required this.p});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.image, size: 48)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              p.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              formatBRL(p.price),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                IconButton(
                  tooltip: 'Remover 1',
                  onPressed: () => CartScope.of(context).removeOne(p),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                IconButton(
                  tooltip: 'Adicionar 1',
                  onPressed: () => CartScope.of(context).add(p),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
