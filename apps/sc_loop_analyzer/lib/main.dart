import 'package:flutter/material.dart';
import 'package:dotlyn_core/dotlyn_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderScope, ConsumerWidget, WidgetRef, Consumer, ConsumerStatefulWidget, ConsumerState;
import 'models/gameplay_type.dart';
import 'models/ship.dart';
import 'providers/providers.dart';
import 'services/database_service.dart';
import 'screens/loops_screen_new.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: SCLoopAnalyzerApp()));
}

class SCLoopAnalyzerApp extends ConsumerWidget {
  const SCLoopAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'SC Loop Analyzer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE36C2D),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Plus Jakarta Sans',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE36C2D),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Plus Jakarta Sans',
      ),
      themeMode: ThemeMode.system,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const TrackingScreen(),
      const LoopsScreen(),
      const HistoryScreen(),
      const StatsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SC Loop Analyzer'),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.timer), label: 'Tracking'),
          NavigationDestination(icon: Icon(Icons.repeat), label: 'Boucles'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historique'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }
}

// --- Écrans vides/proto ---

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  final _quantityController = TextEditingController();
  final _commentsController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = ref.watch(profileProviderRiverpod);
    final sessionProvider = ref.watch(sessionProviderRiverpod);

    final activeProfile = sessionProvider.activeProfile;
    final isComplete = sessionProvider.isSessionComplete;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          if (activeProfile == null)
            Column(
              children: [
                Text('Sélectionnez une boucle', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                if (profileProvider.profiles.isEmpty)
                  const Text('Aucune boucle disponible. Créez-en une dans l\'onglet Boucles.')
                else
                  ...profileProvider.profiles.map((profile) => ListTile(
                        title: Text(profile.name),
                        subtitle: Text('${profile.steps.length} étapes'),
                        onTap: () {
                          sessionProvider.startSession(profile);
                        },
                      )),
              ],
            )
          else
            Column(
              children: [
                Text('Session: ${activeProfile.name}',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                if (!isComplete)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: Text(sessionProvider.currentStepName),
                    onPressed: () {
                      sessionProvider.recordStep();
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(220, 56)),
                  )
                else
                  const Text('Toutes les étapes enregistrées',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sessionProvider.currentTimestamps.length,
                  itemBuilder: (context, i) {
                    final entry = sessionProvider.currentTimestamps[i];
                    return ListTile(
                      leading: const Icon(Icons.check),
                      title: Text(
                          '${entry.step} - ${entry.time.hour}:${entry.time.minute}:${entry.time.second}'),
                    );
                  },
                ),
                if (isComplete) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantité'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _commentsController,
                    decoration: const InputDecoration(labelText: 'Commentaire'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final quantity = int.tryParse(_quantityController.text) ?? 0;
                      await sessionProvider.saveSession(quantity, _commentsController.text);
                      _quantityController.clear();
                      _commentsController.clear();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Session enregistrée !')),
                        );
                      }
                    },
                    child: const Text('Terminer & Enregistrer'),
                  ),
                ],
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    sessionProvider.resetSession();
                    _quantityController.clear();
                    _commentsController.clear();
                  },
                  child: const Text('Annuler la session'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class GameplayTypesScreen extends StatelessWidget {
  const GameplayTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.category), text: 'Gameplay'),
              Tab(icon: Icon(Icons.rocket_launch), text: 'Vaisseaux'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _GameplayTypesTab(),
            _ShipsTab(),
          ],
        ),
      ),
    );
  }
}

class _GameplayTypesTab extends StatelessWidget {
  const _GameplayTypesTab();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final provider = ref.watch(gameplayTypeProviderRiverpod);
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Types de gameplay', style: Theme.of(context).textTheme.headlineSmall),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddGameplayTypeDialog(context, provider),
                  tooltip: 'Ajouter un type',
                ),
              ],
            ),
            const Divider(),
            if (provider.types.isEmpty)
              const Center(child: Text('Aucun type de gameplay.'))
            else
              ...provider.types.map((type) => ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(type.name),
                    subtitle:
                        Text(type.description.isNotEmpty ? type.description : 'Pas de description'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(
                        context,
                        'Supprimer ${type.name} ?',
                        () => provider.deleteType(type.id),
                      ),
                    ),
                  )),
          ],
        );
      },
    );
  }

  Future<void> _showAddGameplayTypeDialog(
      BuildContext context, GameplayTypeProvider provider) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau type de gameplay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom (ex: Salvage)')),
            const SizedBox(height: 8),
            TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await provider.addType(GameplayType(
                  id: 0,
                  name: nameController.text,
                  description: descController.text,
                  loopIds: [],
                ));
                if (context.mounted) Navigator.pop(context, true);
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}

class _ShipsTab extends StatelessWidget {
  const _ShipsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final provider = ref.watch(shipProviderRiverpod);
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vaisseaux', style: Theme.of(context).textTheme.headlineSmall),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddShipDialog(context, provider),
                  tooltip: 'Ajouter un vaisseau',
                ),
              ],
            ),
            const Divider(),
            if (provider.ships.isEmpty)
              const Center(child: Text('Aucun vaisseau.'))
            else
              ...provider.ships.map((ship) => ListTile(
                    leading: const Icon(Icons.rocket_launch),
                    title: Text(ship.name),
                    subtitle: Text(ship.type.isNotEmpty ? ship.type : 'Pas de type'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(
                        context,
                        'Supprimer ${ship.name} ?',
                        () => provider.deleteShip(ship.id),
                      ),
                    ),
                  )),
          ],
        );
      },
    );
  }

  Future<void> _showAddShipDialog(BuildContext context, ShipProvider provider) async {
    final nameController = TextEditingController();
    final typeController = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau vaisseau'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom (ex: Vulture)')),
            const SizedBox(height: 8),
            TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Type (ex: Salvage)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await provider.addShip(Ship(
                  id: 0,
                  name: nameController.text,
                  type: typeController.text,
                  notes: '',
                ));
                if (context.mounted) Navigator.pop(context, true);
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}

Future<void> _confirmDelete(BuildContext context, String message, VoidCallback onConfirm) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmation'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    onConfirm();
  }
}

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(sessionProviderRiverpod);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.sessions.isEmpty) {
      return const Center(child: Text('Aucune session enregistrée'));
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Historique des sessions', style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () => _resetHistory(context, provider),
                tooltip: 'Reset historique',
              ),
            ],
          ),
          const Divider(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Boucle')),
                DataColumn(label: Text('Durée')),
                DataColumn(label: Text('Quantité')),
                DataColumn(label: Text('Commentaire')),
                DataColumn(label: Text('Actions')),
              ],
              rows: provider.sessions.map((session) {
                return DataRow(cells: [
                  DataCell(Text(
                      '${session.startTime.day}/${session.startTime.month}/${session.startTime.year}')),
                  DataCell(Text(session.profileName)),
                  DataCell(Text('${session.totalDuration.toStringAsFixed(0)} min')),
                  DataCell(Text('${session.quantity}')),
                  DataCell(Text(session.comments)),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete, size: 18),
                    onPressed: () => _confirmDeleteSession(context, provider, session.id),
                  )),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteSession(
      BuildContext context, SessionProvider provider, int sessionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la session'),
        content: const Text('Voulez-vous vraiment supprimer cette session ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseService().deleteSession(sessionId);
      await provider.loadSessions();
    }
  }

  Future<void> _resetHistory(BuildContext context, SessionProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset historique'),
        content: const Text('Supprimer toutes les sessions ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer tout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = await DatabaseService().database;
      await db.delete('sessions');
      await provider.loadSessions();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historique réinitialisé')),
        );
      }
    }
  }
}

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionProvider = ref.watch(sessionProviderRiverpod);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Statistiques', style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () => _resetStats(context, sessionProvider),
                tooltip: 'Reset stats',
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 40),
          const Center(
            child: Column(
              children: [
                Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Statistiques à venir',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Les statistiques seront calculées à partir de vos sessions',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resetStats(BuildContext context, SessionProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset statistiques'),
        content: const Text('Supprimer toutes les sessions pour réinitialiser les stats ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer tout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = await DatabaseService().database;
      await db.delete('sessions');
      await provider.loadSessions();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Statistiques réinitialisées')),
        );
      }
    }
  }
}
