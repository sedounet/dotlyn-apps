import 'package:flutter/material.dart';

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('DialogBox'),
        content: const Text('Ceci est un exemple de DialogBox.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Popup (Bottom Sheet)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Ceci est un exemple de popup modal.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialogs & Popups')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () => _showDialog(context),
              child: const Text('Afficher DialogBox'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showPopup(context),
              child: const Text('Afficher Popup'),
            ),
            const SizedBox(height: 32),
            const Text('ListView Exemple', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...List.generate(
                10,
                (i) => Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.list),
                          title: Text('Item ${i + 1}'),
                          subtitle: const Text('Description de l’item'),
                          trailing: IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () => _showDialog(context),
                          ),
                        ),
                        if (i < 9) const Divider(),
                      ],
                    )),
          ],
        ),
      ),
    );
  }
}
