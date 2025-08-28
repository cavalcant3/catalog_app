// lib/state/cart_state.dart
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({required this.product, this.qty = 1});
}

class CartState extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void add(Product p, {int qty = 1}) {
    if (qty <= 0) return;
    final i = _items.indexWhere((e) => e.product.id == p.id);
    if (i >= 0) {
      _items[i].qty += qty;
    } else {
      _items.add(CartItem(product: p, qty: qty));
    }
    notifyListeners();
  }

  void setQty(Product p, int qty) {
    final i = _items.indexWhere((e) => e.product.id == p.id);
    if (i < 0) return;
    if (qty <= 0) {
      _items.removeAt(i);
    } else {
      _items[i].qty = qty;
    }
    notifyListeners();
  }

  void removeOne(Product p) {
    final i = _items.indexWhere((e) => e.product.id == p.id);
    if (i >= 0) {
      _items[i].qty -= 1;
      if (_items[i].qty <= 0) _items.removeAt(i);
      notifyListeners();
    }
  }

  void remove(Product p) {
    _items.removeWhere((e) => e.product.id == p.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get totalItems => _items.fold(0, (acc, e) => acc + e.qty);

  double get totalPrice =>
      _items.fold(0.0, (acc, e) => acc + (e.product.price * e.qty));
}
