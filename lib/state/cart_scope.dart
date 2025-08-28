// lib/state/cart_scope.dart
import 'package:flutter/widgets.dart';
import 'cart_state.dart';

class CartScope extends InheritedNotifier<CartState> {
  const CartScope({
    super.key,
    required CartState cart,
    required Widget child,
  }) : super(notifier: cart, child: child);

  /// Observa o carrinho e RECONSTRÓI widgets dependentes quando ele muda.
  static CartState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope.of() não encontrado no contexto');
    return scope!.notifier!;
  }

  /// Lê o carrinho SEM criar dependência (não reconstrói automaticamente).
  /// Útil dentro de callbacks como onPressed/onTap.
  static CartState read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<CartScope>();
    assert(element != null, 'CartScope.read() não encontrado no contexto');
    final scope = element!.widget as CartScope;
    return scope.notifier!;
  }
}
