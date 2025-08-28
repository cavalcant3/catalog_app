// lib/screens/checkout_payment_screen.dart
import 'package:flutter/material.dart';
import '../state/cart_scope.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  const CheckoutPaymentScreen({super.key});

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  String _method = 'Cartão de crédito';
  final _card = TextEditingController();

  @override
  void dispose() {
    _card.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final data = (ModalRoute.of(context)!.settings.arguments as Map?) ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (data.isNotEmpty) ...[
              Text(
                'Entrega para: ${data['name'] ?? ''}, ${data['street'] ?? ''} — ${data['city'] ?? ''} ${data['zip'] ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (data['shipping'] != null)
                Text('Frete: ${data['shipping']}'),
              const SizedBox(height: 12),
            ],
            // Resumo simples do pedido
            Text(
              'Total: R\$ ${cart.totalPrice.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),

            const Text('Forma de pagamento:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _method,
              items: const [
                DropdownMenuItem(
                  value: 'Cartão de crédito',
                  child: Text('Cartão de crédito'),
                ),
                DropdownMenuItem(value: 'PIX', child: Text('PIX')),
                DropdownMenuItem(value: 'Boleto', child: Text('Boleto')),
              ],
              onChanged: (v) => setState(() => _method = v!),
            ),
            const SizedBox(height: 12),
            if (_method == 'Cartão de crédito')
              TextFormField(
                controller: _card,
                decoration: const InputDecoration(
                  labelText: 'Número do cartão',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            const Spacer(),
            FilledButton.icon(
              onPressed: cart.items.isEmpty
                  ? null
                  : () {
                // Captura total antes de limpar o carrinho
                final total = cart.totalPrice;

                // Limpa carrinho e vai para a tela de processamento
                cart.clear();
                Navigator.of(context).pushReplacementNamed(
                  '/checkout/processing',
                  arguments: {
                    ...data,         // name/street/city/zip/shipping
                    'total': total,  // total do pedido
                    'method': _method,
                  },
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Finalizar pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
