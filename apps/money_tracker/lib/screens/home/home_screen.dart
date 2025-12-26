import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import '../../data/database/app_database.dart';
import '../../providers/accounts_provider.dart';
import '../../providers/favorite_accounts_provider.dart';
import '../../providers/ui_state_provider.dart';
import '../../providers/database_provider.dart';
import '../../widgets/forms/transaction_form_sheet.dart';
import '../accounts/accounts_screen.dart';
import '../settings/settings_screen.dart';
import '../beneficiaries/beneficiaries_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAccount = ref.watch(activeAccountProvider);
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);
    final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

    double? currentBalance;
    double? availableBalance;
    if (activeAccount != null) {
      currentBalance = ref.watch(accountBalanceProvider(activeAccount.id));
      availableBalance = ref.watch(accountAvailableBalanceProvider(activeAccount.id));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracker'),
        actions: [
          IconButton(
            icon: Icon(isBalanceVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => ref.read(balanceVisibilityProvider.notifier).toggleVisibility(),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Spacer(),

            // Boutons de choix de compte (comptes favoris)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer(
                builder: (context, ref, _) {
                  final favoritesAsync = ref.watch(favoriteAccountsProvider);
                  final accountsAsync = ref.watch(accountsProvider);

                  return favoritesAsync.when(
                    data: (favorites) => accountsAsync.when(
                      data: (accounts) {
                        final accountMap = {for (var a in accounts) a.id: a};
                        return Row(
                          children: List.generate(3, (index) {
                            final fav = favorites.firstWhere(
                              (f) => f.buttonIndex == index,
                              orElse: () => null as dynamic,
                            );
                            final account = fav != null ? accountMap[fav.accountId] : null;

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: _FavoriteAccountButton(
                                  index: index,
                                  account: account,
                                  onTap: account != null
                                      ? () => ref.read(activeAccountIdProvider.notifier).state =
                                            account.id
                                      : null,
                                ),
                              ),
                            );
                          }),
                        );
                      },
                      loading: () => const SizedBox(
                        height: 64,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, s) =>
                          SizedBox(height: 64, child: Center(child: Text('Erreur: $e'))),
                    ),
                    loading: () => const SizedBox(
                      height: 64,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, s) => SizedBox(height: 64, child: Center(child: Text('Erreur: $e'))),
                  );
                },
              ),
            ),

            // Soldes du compte actif sur 2 colonnes + show/hide
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disponible
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disponible',
                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isBalanceVisible
                              ? currencyFormatter.format(availableBalance ?? 0)
                              : '***',
                          style: TextStyle(
                            color: (availableBalance ?? 0) < 0
                                ? DotlynColors.primary
                                : DotlynColors.secondary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Actuel
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actuel',
                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isBalanceVisible ? currencyFormatter.format(currentBalance ?? 0) : '***',
                          style: const TextStyle(
                            color: DotlynColors.secondary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Show/hide button
                  IconButton(
                    icon: Icon(isBalanceVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () =>
                        ref.read(balanceVisibilityProvider.notifier).toggleVisibility(),
                    tooltip: 'Afficher/Masquer',
                  ),
                ],
              ),
            ),

            // Boutons +/- virement (ligne propre, alignés à droite)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      heroTag: 'remove',
                      onPressed: () => _showTransactionDialog(context, 'expense'),
                      backgroundColor: DotlynColors.primary,
                      child: const Icon(Icons.remove, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      heroTag: 'transfer',
                      onPressed: () => _showTransactionDialog(context, 'transfer'),
                      backgroundColor: DotlynColors.primary,
                      child: const Icon(Icons.swap_horiz, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      heroTag: 'add',
                      onPressed: () => _showTransactionDialog(context, 'income'),
                      backgroundColor: DotlynColors.primary,
                      child: const Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Tagline
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Suivi quotidien de vos comptes bancaires',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            // Ad Banner Placeholder (tout en bas)
            Container(
              height: 50,
              color: Colors.grey[300],
              child: const Center(child: Text('Ad Banner Placeholder')),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: const Text('Accueil'), onTap: () => Navigator.pop(context)),
            ListTile(
              title: const Text('Mes Comptes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountsScreen()));
              },
            ),
            ListTile(title: const Text('Catégories'), onTap: () => Navigator.pop(context)),
            ListTile(
              title: const Text('Bénéficiaires'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BeneficiariesScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            if (kDebugMode)
              ListTile(
                title: const Text('Reset DB (dev)'),
                subtitle: const Text('Supprime et reseed la DB pour tests'),
                onTap: () async {
                  Navigator.pop(context);
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Réinitialiser la base de données'),
                          content: const Text(
                            'Confirmer la suppression de toutes les données et reseed ?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                  if (!confirmed) return;

                  final db = ref.read(databaseProvider);
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Réinitialisation en cours...')),
                  );
                  await db.resetToDefaultData(includeFakeData: true);
                  messenger.showSnackBar(const SnackBar(content: Text('Base réinitialisée')));
                },
              ),
            ListTile(title: const Text('À propos'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  void _showTransactionDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => TransactionFormSheet(defaultType: type),
    );
  }
}

class _FavoriteAccountButton extends StatelessWidget {
  final int index;
  final Account? account;
  final VoidCallback? onTap;

  const _FavoriteAccountButton({required this.index, required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: isActive ? DotlynColors.primary : Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: isActive ? DotlynColors.primary.withOpacity(0.05) : Colors.grey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 24,
              color: isActive ? DotlynColors.primary : Colors.grey[400],
            ),
            const SizedBox(height: 4),
            if (account != null)
              Flexible(
                child: Text(
                  account!.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: DotlynColors.secondary,
                  ),
                ),
              )
            else
              Text('Vide', style: TextStyle(fontSize: 11, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}
