import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Statistiques', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Minage'),
            subtitle: Text('Sessions: 12 | Durée moy: 1h | Qté/h: 10'),
          ),
          const ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Salvage'),
            subtitle: Text('Sessions: 5 | Durée moy: 45min | Qté/h: 7'),
          ),
        ],
      ),
    );
  }
}
