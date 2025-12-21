import 'package:flutter/material.dart';

class ProfileManagementScreen extends StatelessWidget {
  const ProfileManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boucles (workflows)')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Boucles existantes', style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
                tooltip: 'Ajouter une boucle',
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.repeat),
            title: const Text('Boucle Minage'),
            subtitle: const Text('Étapes: Départ, Extraction, Retour'),
            trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          ),
          ListTile(
            leading: const Icon(Icons.repeat),
            title: const Text('Boucle Salvage'),
            subtitle: const Text('Étapes: Départ, Récupération, Vente'),
            trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
