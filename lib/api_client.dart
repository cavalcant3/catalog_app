import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import 'models/product.dart';

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
    host == 'localhost' || host == '10.0.2.2';
    return client;
  }
}

class ApiClient {
  ApiClient._(this.baseUrl) {
    assert(() {
      if (!kIsWeb) {
        HttpOverrides.global = _DevHttpOverrides();
      }
      return true;
    }());
  }

  final Uri baseUrl;


  factory ApiClient.auto({bool useHttps = false}) {
    if (kIsWeb) {
      final scheme = useHttps ? 'https' : 'http';
      return ApiClient._(Uri.parse('$scheme://localhost:8080'));
    }

    String host = 'localhost';
    if (Platform.isAndroid) host = '10.0.2.2';
    final scheme = useHttps ? 'https' : 'http';
    return ApiClient._(Uri.parse('$scheme://$host:8080'));
  }

  Uri _u(String path) => baseUrl.replace(path: path, queryParameters: null);

  Future<Map<String, dynamic>> health() async {
    final res = await http.get(_u('/products/health'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException('Health check failed: ${res.statusCode} ${res.body}');
  }

  Future<List<Product>> listProducts() async {
    var url = _u('/products');


    if (kIsWeb) {
      final qp = Map<String, String>.from(url.queryParameters);
      qp['_'] = DateTime.now().millisecondsSinceEpoch.toString();
      url = url.replace(queryParameters: qp);
    }

    final res = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Cache-Control': 'no-cache',
      },
    );
    if (res.statusCode != 200) {
      throw HttpException('GET /products failed: ${res.statusCode} ${res.body}');
    }
    final data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProduct(String id) async {
    final res = await http.get(_u('/products/$id'));
    if (res.statusCode != 200) {
      throw HttpException('GET /products/$id failed: ${res.statusCode}');
    }
    return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Product> createProduct(Product p) async {
    final res = await http.post(
      _u('/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw HttpException(
          'POST /products failed: ${res.statusCode} ${res.body}');
    }
    return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Product> updateProduct(Product p) async {
    if (p.id == null) throw ArgumentError('updateProduct requires id');
    final res = await http.put(
      _u('/products/${p.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode != 200) {
      throw HttpException(
          'PUT /products/${p.id} failed: ${res.statusCode} ${res.body}');
    }
    return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteProduct(String id) async {
    final res = await http.delete(_u('/products/$id'));
    // Aceita 200, 202, 204, etc.
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw HttpException(
          'DELETE /products/$id failed: ${res.statusCode} ${res.body}');
    }
  }
}
