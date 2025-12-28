import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Map<String, int>? _dbStats;
  List<String>? _integrityIssues;
  bool _isLoading = false;

  Future<void> _refreshStats() async {
    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);
    final stats = await db.getDatabaseStats();
    final issues = await db.checkIntegrity();
    setState(() {
      _dbStats = stats;
      _integrityIssues = issues;
      _isLoading = false;
    });
  }

  Future<void> _resetDatabase({bool includeFakeData = true}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Confirmation'),
        content: Text(
          includeFakeData
              ? 'Supprimer toutes les données et réinsérer les données initiales + données de test ?'
              : 'Supprimer toutes les données et réinsérer uniquement les catégories par défaut ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      final db = ref.read(databaseProvider);
      await db.resetToDefaultData(includeFakeData: includeFakeData);
      await _refreshStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Base de données réinitialisée')),
        );
      }
    }
  }

  Future<void> _seedFakeData() async {
    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);
    await db.seedFakeData();
    await _refreshStats();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Données de test ajoutées')));
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStats,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Database stats
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'État de la base de données',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        if (_dbStats != null) ...[
                          _StatRow('Comptes', _dbStats!['accounts']!),
                          _StatRow('Catégories', _dbStats!['categories']!),
                          _StatRow(
                            'Bénéficiaires',
                            _dbStats!['beneficiaries']!,
                          ),
                          _StatRow('Transactions', _dbStats!['transactions']!),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Integrity check
                if (_integrityIssues != null) ...[
                  Card(
                    color: _integrityIssues!.isEmpty
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _integrityIssues!.isEmpty
                                    ? Icons.check_circle
                                    : Icons.warning,
                                color: _integrityIssues!.isEmpty
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _integrityIssues!.isEmpty
                                    ? 'Intégrité OK'
                                    : '${_integrityIssues!.length} problème(s) détecté(s)',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          if (_integrityIssues!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            ..._integrityIssues!.map(
                              (issue) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $issue',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Debug actions (only in debug mode)
                if (kDebugMode) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Actions de développement',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '⚠️ Ces actions sont disponibles uniquement en mode debug',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _seedFakeData,
                              icon: const Icon(Icons.science),
                              label: const Text('Ajouter données de test'),
                            ),
                          ),
                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _resetDatabase(includeFakeData: true),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset DB (avec données test)'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _resetDatabase(includeFakeData: false),
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('Reset DB (vide)'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // General settings
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paramètres généraux',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _DarkModeToggle(),
                        const SizedBox(height: 16),
                        _HideBalanceToggle(),
                        const SizedBox(height: 16),
                        _LocaleSelector(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _DarkModeToggle extends ConsumerWidget {
  const _DarkModeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsync = ref.watch(
      appSettingProvider(AppSettingsRepository.darkModeKey),
    );

    return settingAsync.when(
      data: (value) {
        final isDark = value == 'true';
        return ListTile(
          title: const Text('Mode sombre'),
          trailing: Switch(
            value: isDark,
            onChanged: (val) async {
              final repo = ref.read(appSettingsRepositoryProvider);
              await repo.setSetting(
                AppSettingsRepository.darkModeKey,
                val.toString(),
              );
            },
          ),
        );
      },
      loading: () => const ListTile(
        title: Text('Mode sombre'),
        trailing: CircularProgressIndicator(),
      ),
      error: (e, s) => ListTile(
        title: const Text('Mode sombre'),
        subtitle: Text('Erreur: $e'),
      ),
    );
  }
}

class _HideBalanceToggle extends ConsumerWidget {
  const _HideBalanceToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsync = ref.watch(
      appSettingProvider(AppSettingsRepository.hideBalance),
    );

    return settingAsync.when(
      data: (value) {
        final isHidden = value == 'true';
        return ListTile(
          title: const Text('Masquer les soldes'),
          subtitle: const Text('Afficher les soldes des comptes comme masqués'),
          trailing: Switch(
            value: isHidden,
            onChanged: (val) async {
              final repo = ref.read(appSettingsRepositoryProvider);
              await repo.setSetting(
                AppSettingsRepository.hideBalance,
                val.toString(),
              );
            },
          ),
        );
      },
      loading: () => const ListTile(
        title: Text('Masquer les soldes'),
        trailing: CircularProgressIndicator(),
      ),
      error: (e, s) => ListTile(
        title: const Text('Masquer les soldes'),
        subtitle: Text('Erreur: $e'),
      ),
    );
  }
}

class _LocaleSelector extends ConsumerWidget {
  const _LocaleSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsync = ref.watch(
      appSettingProvider(AppSettingsRepository.locale),
    );

    return settingAsync.when(
      data: (value) {
        final locale = value ?? 'fr_FR';
        return DropdownButtonFormField<String>(
          value: locale,
          items: const [
            DropdownMenuItem(value: 'fr_FR', child: Text('Français')),
            DropdownMenuItem(value: 'en_US', child: Text('English')),
          ],
          onChanged: (val) async {
            if (val != null) {
              final repo = ref.read(appSettingsRepositoryProvider);
              await repo.setSetting(AppSettingsRepository.locale, val);
            }
          },
          decoration: const InputDecoration(
            labelText: 'Langue',
            border: OutlineInputBorder(),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Erreur: $e'),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final int count;

  const _StatRow(this.label, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            count.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
