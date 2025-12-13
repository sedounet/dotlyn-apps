import 'package:flutter/material.dart';

class AddTransactionSheet extends StatelessWidget {
  const AddTransactionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Montant'),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField(
            items: const [
              DropdownMenuItem(value: 'Catégorie 1', child: Text('Catégorie 1')),
              DropdownMenuItem(value: 'Catégorie 2', child: Text('Catégorie 2')),
            ],
            onChanged: (value) {},
            decoration: const InputDecoration(labelText: 'Catégorie'),
          ),
          DropdownButtonFormField(
            items: const [
              DropdownMenuItem(value: 'Bénéficiaire 1', child: Text('Bénéficiaire 1')),
              DropdownMenuItem(value: 'Bénéficiaire 2', child: Text('Bénéficiaire 2')),
            ],
            onChanged: (value) {},
            decoration: const InputDecoration(labelText: 'Bénéficiaire'),
          ),
          TextField(decoration: const InputDecoration(labelText: 'Note')),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  title: const Text('Validé'),
                  value: 'validated',
                  groupValue: 'status',
                  onChanged: (value) {},
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: const Text('En attente'),
                  value: 'pending',
                  groupValue: 'status',
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {}, // TODO: Add save functionality
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
