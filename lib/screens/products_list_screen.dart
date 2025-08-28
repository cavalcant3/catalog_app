// lib/screens/products_list_screen.dart
import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models/product.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  // Se for rodar no Chrome, prefira HTTP em dev:
  final _api = ApiClient.auto(useHttps: false);
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Product>> _load() async {
    // Opcional: checar saúde da API (não bloqueia a lista)
    try {
      await _api.health();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('API não acessível: $e')),
        );
      }
    }
    return _api.listProducts();
  }

  Future<void> _refresh() async {
    final next = _load(); // roda fora do setState
    setState(() {
      _future = next; // atualiza o estado de forma síncrona
    });
    await next; // espera fora do setState
  }

  Future<void> _openForm({Product? product}) async {
    final changed = await Navigator.of(context)
        .pushNamed('/product-form', arguments: product) as bool?;
    if (changed == true) {
      await _refresh();
    }
  }

  // Agora retorna bool para integrar com o Dismissible
  Future<bool> _delete(Product p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Tem certeza que deseja excluir "${p.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (ok != true) return false;

    try {
      await _api.deleteProduct(p.id!);
      if (!mounted) return true;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Excluído.')));
      await _refresh();
      return true; // permite ao Dismissible remover da UI
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: $e')),
        );
      }
      return false; // mantém o item na UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo — Produtos'),
        actions: [
          IconButton(
            tooltip: 'Voltar à loja',
            icon: const Icon(Icons.storefront),
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil('/app', (r) => false),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Product>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }
            final items = snapshot.data ?? const <Product>[];
            if (items.isEmpty) {
              return const Center(child: Text('Nenhum produto encontrado.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = items[index];
                return Dismissible(
                  key: ValueKey(p.id ?? index),
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) => _delete(p),
                  child: ListTile(
                    title: Text(p.name),
                    subtitle: Text(p.description ?? '—'),
                    trailing: Text('R\$ ${p.price.toStringAsFixed(2)}'),
                    onTap: () => _openForm(product: p),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
