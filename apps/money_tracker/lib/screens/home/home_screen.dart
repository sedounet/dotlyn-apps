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
                            // Find favorite for this button index (safe)
                            FavoriteAccount? fav;
                            try {
                              fav = favorites.firstWhere((f) => f.buttonIndex == index);
                            } catch (e) {
                              fav = null;
                            }
                            final account = fav != null ? accountMap[fav.accountId] : null;

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: _FavoriteAccountButton(
                                  index: index,
                                  account: account,
                                  onTap: () => _handleFavoriteButtonTap(
                                    context,
                                    ref,
                                    index,
                                    account,
                                    accounts,
                                  ),
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

  static void _handleFavoriteButtonTap(
    BuildContext context,
    WidgetRef ref,
    int buttonIndex,
    Account? currentAccount,
    List<Account> allAccounts,
  ) {
    if (currentAccount != null) {
      // Bouton avec compte assigné → activer ce compte
      ref.read(activeAccountIdProvider.notifier).state = currentAccount.id;
    } else {
      // Bouton vide → ouvrir sélection de compte
      _showAccountSelectionDialog(context, ref, buttonIndex, allAccounts);
    }
  }

  static Future<void> _showAccountSelectionDialog(
    BuildContext context,
    WidgetRef ref,
    int buttonIndex,
    List<Account> accounts,
  ) async {
    final selected = await showDialog<Account>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assigner au bouton ${buttonIndex + 1}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(account.name),
                subtitle: Text(account.type),
                onTap: () => Navigator.of(context).pop(account),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
        ],
      ),
    );

    if (selected != null && context.mounted) {
      // Demander confirmation
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
            'Voulez-vous assigner le compte "${selected.name}" au bouton ${buttonIndex + 1} ?',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Non')),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Oui'),
            ),
          ],
        ),
      );

      if (confirmed == true && context.mounted) {
        // Assigner le favori
        final repo = ref.read(favoriteAccountsRepositoryProvider);
        await repo.assignFavorite(buttonIndex: buttonIndex, accountId: selected.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${selected.name} assigné au bouton ${buttonIndex + 1}')),
          );
        }
      }
    }
  }
}

class _FavoriteAccountButton extends StatelessWidget {
  final int index;
  final Account? account;
  final VoidCallback? onTap;

  const _FavoriteAccountButton({required this.index, required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasAccount = account != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(
            color: hasAccount ? DotlynColors.primary : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: hasAccount ? DotlynColors.primary.withOpacity(0.05) : Colors.grey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 24,
              color: hasAccount ? DotlynColors.primary : Colors.grey[400],
            ),
            const SizedBox(height: 4),
            if (hasAccount)
              Flexible(
                child: Text(
                  account!.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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
