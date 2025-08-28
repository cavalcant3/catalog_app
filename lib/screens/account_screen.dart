import 'package:flutter/material.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha conta')),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.person), title: Text('Matheus Dev'), subtitle: Text('matheus@email.com')),
          Divider(height: 1),
          ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Endereços')),
          ListTile(leading: Icon(Icons.history), title: Text('Meus pedidos')),
          ListTile(leading: Icon(Icons.settings_outlined), title: Text('Configurações')),
        ],
      ),
    );
  }
}