import 'package:flutter/material.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme & Typography')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Couleurs', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ColorChip('Primary', DotlynColors.primary),
              _ColorChip('Secondary', DotlynColors.secondary),
              _ColorChip('Accent', DotlynColors.accent),
              _ColorChip('Success', DotlynColors.success),
              _ColorChip('Warning', DotlynColors.warning),
              _ColorChip('Error', DotlynColors.error),
            ],
          ),
          const SizedBox(height: 32),
          Text('Typographie',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text('Display Large (Satoshi)',
              style: Theme.of(context).textTheme.displayLarge),
          Text('Headline Medium (Satoshi)',
              style: Theme.of(context).textTheme.headlineMedium),
          Text('Title Large (Jakarta)',
              style: Theme.of(context).textTheme.titleLarge),
          Text('Body Large (Jakarta)',
              style: Theme.of(context).textTheme.bodyLarge),
          Text('Label Medium (Jakarta)',
              style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorChip(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
