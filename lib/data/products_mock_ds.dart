import 'dart:math';
import '../models/product.dart';
import 'products_data_source.dart';


class ProductsMockDataSource implements ProductsDataSource {
  final _rnd = Random(42);


  final List<String> _categories = const [
    'Eletrônicos',
    'Acessórios',
    'Casa & Cozinha',
    'Escritório',
    'Games',
  ];


  late final List<Product> _items = List.generate(40, (i) {
    final cat = _categories[i % _categories.length];
    final price = 29.9 + (i * 7.35) % 450;
    return Product(
      id: 'mock-$i',
      name: 'Produto $i',
      description: 'Categoria: $cat — Um produto incrível número $i com recursos de demonstração.',
      price: double.parse(price.toStringAsFixed(2)),
    );
  });


  @override
  Future<List<Product>> list({String? q, String? category}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    Iterable<Product> out = _items;
    if (category != null && category.isNotEmpty) {
      out = out.where((p) => (p.description ?? '').contains('Categoria: $category'));
    }
    if (q != null && q.trim().isNotEmpty) {
      final term = q.toLowerCase();
      out = out.where((p) => p.name.toLowerCase().contains(term) || (p.description ?? '').toLowerCase().contains(term));
    }
    return out.toList(growable: false);
  }


  @override
  Future<Product> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 120));
    return _items.firstWhere((e) => e.id == id);
  }


  @override
  Future<List<String>> categories() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return _categories;
  }
}