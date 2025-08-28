import 'package:flutter/material.dart';


class CheckoutShippingScreen extends StatefulWidget {
  const CheckoutShippingScreen({super.key});
  @override
  State<CheckoutShippingScreen> createState() => _CheckoutShippingScreenState();
}


class _CheckoutShippingScreenState extends State<CheckoutShippingScreen> {
  String _method = 'PAC (5-8 dias)';


  @override
  Widget build(BuildContext context) {
    final addr = (ModalRoute.of(context)!.settings.arguments as Map?) ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Frete')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Entrega para:'),
            Text('${addr['name']}, ${addr['street']}, ${addr['city']} — ${addr['zip']}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Text('Selecione o método de envio:'),
            const SizedBox(height: 8),
            RadioListTile(
              title: const Text('PAC (5-8 dias) — R\$ 19,90'),
              value: 'PAC (5-8 dias)',
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v as String),
            ),
            RadioListTile(
              title: const Text('Sedex (2-3 dias) — R\$ 34,90'),
              value: 'Sedex (2-3 dias)',
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v as String),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamed('/checkout/payment', arguments: {
                ...addr,
                'shipping': _method,
              }),
              child: const Text('Continuar'),
            )
          ],
        ),
      ),
    );
  }
}