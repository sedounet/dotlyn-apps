import 'package:flutter/material.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buttons')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Button Types',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {}, child: const Text('Elevated Button')),
          const SizedBox(height: 12),
          OutlinedButton(
              onPressed: () {}, child: const Text('Outlined Button')),
          const SizedBox(height: 12),
          TextButton(onPressed: () {}, child: const Text('Text Button')),
          const SizedBox(height: 32),
          Text('Button Sizes',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Small'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () {}, child: const Text('Medium (default)')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Large'),
          ),
        ],
      ),
    );
  }
}
