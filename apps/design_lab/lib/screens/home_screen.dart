import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'theme_screen.dart';
import 'buttons_screen.dart';
import 'inputs_screen.dart';
import 'cards_screen.dart';
import 'dialogs_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(themeProviderRiverpod);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dotlyn Design Lab'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProviderRiverpod).toggleTheme(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Design System Showcase',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Explore tous les composants Dotlyn',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          _MenuCard(
            title: 'Theme & Typography',
            description: 'Couleurs, fonts, styles de texte',
            icon: Icons.palette,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemeScreen()),
            ),
          ),
          _MenuCard(
            title: 'Buttons',
            description: 'Tous les types de boutons',
            icon: Icons.smart_button,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ButtonsScreen()),
            ),
          ),
          _MenuCard(
            title: 'Inputs',
            description: 'Champs de texte, formulaires',
            icon: Icons.input,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InputsScreen()),
            ),
          ),
          _MenuCard(
            title: 'Cards',
            description: 'Cartes et containers',
            icon: Icons.credit_card,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CardsScreen()),
            ),
          ),
          _MenuCard(
            title: 'Dialogs & Popups',
            description: 'DialogBox, Popup, ListView',
            icon: Icons.chat_bubble_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DialogsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: DotlynColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: DotlynColors.primary, size: 32),
              ),
              const SizedBox(width: 16),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(description, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
