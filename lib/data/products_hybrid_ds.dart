import '../models/product.dart';
import '../api_client.dart';
import 'products_data_source.dart';
import 'products_mock_ds.dart';

class ProductsHybridDataSource implements ProductsDataSource {
  final ProductsMockDataSource mock;
  final ApiClient api;

  ProductsHybridDataSource({
    ProductsMockDataSource? mock,
    ApiClient? api,
  })  : mock = mock ?? ProductsMockDataSource(),
        api = api ?? ApiClient.auto(useHttps: false);

  @override
  Future<List<Product>> list({String? q, String? category}) async {
    // 1) mock (com filtros de categoria/busca)
    final mockList = await mock.list(q: q, category: category);

    // 2) http (sem categorias; filtra só por busca)
    List<Product> httpList = [];
    try {
      httpList = await api.listProducts();
    } catch (_) {
      // backend pode não estar rodando – tudo bem, seguimos só com mock
    }
    Iterable<Product> httpFiltered = httpList;
    if (q != null && q.trim().isNotEmpty) {
      final term = q.toLowerCase();
      httpFiltered = httpList.where((p) =>
      p.name.toLowerCase().contains(term) ||
          (p.description ?? '').toLowerCase().contains(term));
    }

    // 3) merge (HTTP sobrescreve mock se id bater)
    final map = <String?, Product>{};
    for (final p in mockList) map[p.id] = p;
    for (final p in httpFiltered) map[p.id] = p;

    return map.values.toList(growable: false);
  }

  @override
  Future<Product> getById(String id) async {
    try {
      return await api.getProduct(id);
    } catch (_) {
      // se não achar no backend, tenta no mock
      return mock.getById(id);
    }
  }

  @override
  Future<List<String>> categories() => mock.categories();
}