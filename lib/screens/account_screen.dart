// lib/screens/account_screen.dart
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha conta')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Matheus Dev'),
            subtitle: Text('matheus@email.com'),
          ),
          const Divider(height: 1),

          // Itens de conta (mock)
          const ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Endereços'),
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text('Meus pedidos'),
          ),
          const ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Configurações'),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text('Admin', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Admin (Produtos)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed('/products'),
          ),
        ],
      ),
    );
  }
}
