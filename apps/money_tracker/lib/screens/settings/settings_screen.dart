import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/widgets.dart';

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
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: '⚠️ Confirmation',
      content: includeFakeData
          ? 'Supprimer toutes les données et réinsérer les données initiales + données de test ?'
          : 'Supprimer toutes les données et réinsérer uniquement les catégories par défaut ?',
      isDangerous: true,
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      final db = ref.read(databaseProvider);
      await db.resetToDefaultData(includeFakeData: includeFakeData);
      await _refreshStats();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
            const SnackBar(content: Text('Base de données réinitialisée')));
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
                // General settings
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paramètres généraux',
                            style: Theme.of(context).textTheme.titleLarge),
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

                // Dev/Debug section (only in debug mode)
                if (kDebugMode) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        leading: const Icon(Icons.developer_mode),
                        title: const Text('Dev / Debug'),
                        subtitle: Text(
                          'Outils de développement',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        initiallyExpanded: false,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Database stats
                                Text(
                                  'État de la base de données',
                                  style: Theme.of(
                                    context,
                                  )
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                if (_dbStats != null) ...[
                                  StatRow(
                                    label: 'Comptes',
                                    value: _dbStats!['accounts']!.toString(),
                                  ),
                                  StatRow(
                                    label: 'Catégories',
                                    value: _dbStats!['categories']!.toString(),
                                  ),
                                  StatRow(
                                    label: 'Bénéficiaires',
                                    value:
                                        _dbStats!['beneficiaries']!.toString(),
                                  ),
                                  StatRow(
                                    label: 'Transactions',
                                    value:
                                        _dbStats!['transactions']!.toString(),
                                  ),
                                ],
                                const Divider(height: 32),

                                // Integrity check
                                Text(
                                  'Intégrité de la base',
                                  style: Theme.of(
                                    context,
                                  )
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                if (_integrityIssues != null) ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _integrityIssues!.isEmpty
                                          ? Colors.green.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _integrityIssues!.isEmpty
                                                  ? 'Intégrité OK'
                                                  : '${_integrityIssues!.length} problème(s)',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        if (_integrityIssues!.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          ..._integrityIssues!.map(
                                            (issue) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Text(
                                                '• $issue',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                                const Divider(height: 32),

                                // Dev actions
                                Text(
                                  'Actions de développement',
                                  style: Theme.of(
                                    context,
                                  )
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _seedFakeData,
                                    icon: const Icon(Icons.science),
                                    label:
                                        const Text('Ajouter données de test'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _resetDatabase(includeFakeData: true),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text(
                                        'Reset DB (avec données test)'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange),
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
                                        backgroundColor: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _DarkModeToggle extends ConsumerWidget {
  const _DarkModeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsync =
        ref.watch(appSettingProvider(AppSettingsRepository.darkModeKey));

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
                  AppSettingsRepository.darkModeKey, val.toString());
            },
          ),
        );
      },
      loading: () => const ListTile(
          title: Text('Mode sombre'), trailing: CircularProgressIndicator()),
      error: (e, s) => ListTile(
          title: const Text('Mode sombre'), subtitle: Text('Erreur: $e')),
    );
  }
}

class _HideBalanceToggle extends ConsumerWidget {
  const _HideBalanceToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsync =
        ref.watch(appSettingProvider(AppSettingsRepository.hideBalance));

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
                  AppSettingsRepository.hideBalance, val.toString());
            },
          ),
        );
      },
      loading: () => const ListTile(
          title: Text('Masquer les soldes'),
          trailing: CircularProgressIndicator()),
      error: (e, s) => ListTile(
          title: const Text('Masquer les soldes'),
          subtitle: Text('Erreur: $e')),
    );
  }
}

class _LocaleSelector extends ConsumerWidget {
  const _LocaleSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsync =
        ref.watch(appSettingProvider(AppSettingsRepository.locale));

    return settingAsync.when(
      data: (value) {
        final locale = value ?? 'fr_FR';
        return DropdownButtonFormField<String>(
          initialValue: locale,
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
              labelText: 'Langue', border: OutlineInputBorder()),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Erreur: $e'),
    );
  }
}
