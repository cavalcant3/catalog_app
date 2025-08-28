import '../models/product.dart';


abstract class ProductsDataSource {
  Future<List<Product>> list({String? q, String? category});
  Future<Product> getById(String id);
  Future<List<String>> categories();
}