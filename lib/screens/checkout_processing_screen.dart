import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CheckoutProcessingScreen extends StatefulWidget {
  const CheckoutProcessingScreen({super.key});

  @override
  State<CheckoutProcessingScreen> createState() => _CheckoutProcessingScreenState();
}

class _CheckoutProcessingScreenState extends State<CheckoutProcessingScreen> {
  late final String orderId;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    orderId = '#${Random().nextInt(899999) + 100000}';
    // Redireciona em 2.5s (ou deixe só o botão)
    _timer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).popUntil((r) => r.settings.name == '/app');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final shipping = args['shipping'] ?? '—';
    final total = args['total'] != null ? (args['total'] as double) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Processando pedido')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 72, height: 72,
                child: CircularProgressIndicator(strokeWidth: 4),
              ),
              const SizedBox(height: 16),
              Text('Seu pedido está sendo processado…', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Pedido $orderId', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (total != null)
                Text('Total (mock): R\$ ${total.toStringAsFixed(2)}'),
              Text('Frete: $shipping'),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.settings.name == '/app'),
                child: const Text('Voltar para a Home agora'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}