// lib/data/products_hybrid_ds.dart
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
    // 1) HTTP (backend) — sempre considerar no resultado
    List<Product> httpList = [];
    try {
      httpList = await api.listProducts();
    } catch (_) {
      // backend pode estar fora — ok, seguimos só com mock
    }
    Iterable<Product> httpFiltered = httpList;
    if (q != null && q.trim().isNotEmpty) {
      final term = q.toLowerCase();
      httpFiltered = httpList.where((p) =>
      p.name.toLowerCase().contains(term) ||
          (p.description ?? '').toLowerCase().contains(term));
    }

    // 2) Mock — pode filtrar por categoria e/ou busca
    final mockList = await mock.list(q: q, category: category);

    // 3) Merge: HTTP primeiro; mock só entra se ID ainda não existe
    final byId = <String?, Product>{};
    for (final p in httpFiltered) {
      byId[p.id] = p;
    }
    for (final p in mockList) {
      byId.putIfAbsent(p.id, () => p);
    }

    final out = byId.values.toList();

    // 4) Ordena: itens do backend primeiro, mocks depois
    out.sort((a, b) {
      int ra = (a.id?.startsWith('mock-') ?? false) ? 1 : 0;
      int rb = (b.id?.startsWith('mock-') ?? false) ? 1 : 0;
      return ra - rb;
    });

    return out;
  }

  @override
  Future<Product> getById(String id) async {
    try {
      return await api.getProduct(id);
    } catch (_) {
      return mock.getById(id);
    }
  }

  @override
  Future<List<String>> categories() => mock.categories();
}
