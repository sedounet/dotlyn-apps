import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des sessions')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Historique', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Boucle')),
              DataColumn(label: Text('Durée')),
              DataColumn(label: Text('Quantité')),
              DataColumn(label: Text('Commentaire')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('21/12/2025')),
                DataCell(Text('Minage')),
                DataCell(Text('1h 12min')),
                DataCell(Text('12 sacs')),
                DataCell(Text('RAS')),
              ]),
              DataRow(cells: [
                DataCell(Text('20/12/2025')),
                DataCell(Text('Salvage')),
                DataCell(Text('54min')),
                DataCell(Text('8 unités')),
                DataCell(Text('Test')),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
