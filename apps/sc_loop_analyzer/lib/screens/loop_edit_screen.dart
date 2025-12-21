import 'package:flutter/material.dart';

class LoopEditScreen extends StatelessWidget {
  const LoopEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle boucle')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Nom de la boucle'),
            ),
            const SizedBox(height: 16),
            Text('Étapes', style: Theme.of(context).textTheme.titleMedium),
            ...List.generate(
                3,
                (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Étape ${i + 1}'),
                      ),
                    )),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Unité de quantité (ex: sacs)'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'minage', child: Text('Minage')),
                DropdownMenuItem(value: 'salvage', child: Text('Salvage')),
              ],
              onChanged: (v) {},
              decoration: const InputDecoration(labelText: 'Type de gameplay'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
