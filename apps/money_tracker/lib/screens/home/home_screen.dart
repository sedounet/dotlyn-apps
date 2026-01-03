import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../providers/accounts_provider.dart';
import '../../providers/favorite_accounts_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../providers/ui_state_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/widgets.dart';
import '../accounts/accounts_screen.dart';
import '../accounts/account_transactions_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Seed DB en arrière-plan APRÈS l'affichage de la homepage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(databaseSeederProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);
    // Lazy: ne charge le compte actif que si nécessaire
    final activeAccount = ref.watch(activeAccountProvider);

    double? currentBalance;
    double? availableBalance;
    if (activeAccount != null) {
      currentBalance = ref.watch(accountBalanceProvider(activeAccount.id));
      availableBalance =
          ref.watch(accountAvailableBalanceProvider(activeAccount.id));
    }

    return Scaffold(
      appBar: _buildAppBar(context, ref, isBalanceVisible),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Spacer(),

            // Boutons de comptes favoris
            _FavoriteAccountsSection(),

            // Soldes
            BalanceRow(
              availableBalance: availableBalance,
              currentBalance: currentBalance,
              isVisible: isBalanceVisible,
              onToggleVisibility: () => ref
                  .read(balanceVisibilityProvider.notifier)
                  .toggleVisibility(),
            ),

            // Boutons d'action (+/- virement)
            ActionButtonsRow(
              onIncome: () => _showTransactionDialog(context, 'income'),
              onExpense: () => _showTransactionDialog(context, 'expense'),
              onTransfer: () => _showTransactionDialog(context, 'transfer'),
            ),

            // Tagline
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Suivi quotidien de vos comptes bancaires',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            // Liste des dernières transactions
            if (activeAccount != null)
              Expanded(child: _TransactionsList(accountId: activeAccount.id)),

            // Ad Banner Placeholder
            _AdBannerPlaceholder(),
          ],
        ),
      ),
      drawer: _buildDrawer(context, ref),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, WidgetRef ref, bool isBalanceVisible) {
    return AppBar(
      title: const Text('Money Tracker'),
      actions: [
        IconButton(
          icon:
              Icon(isBalanceVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () =>
              ref.read(balanceVisibilityProvider.notifier).toggleVisibility(),
        ),
        IconButton(
          icon: Icon(
            ref.watch(themeModeProvider) == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
          onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          tooltip: 'Basculer thème',
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    return AppDrawer(
      headerTitle: 'Menu',
      items: [
        DrawerMenuItemData(icon: Icons.home, title: 'Accueil', onTap: () {}),
        DrawerMenuItemData(
          icon: Icons.account_balance_wallet,
          title: 'Mes Comptes',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AccountsScreen())),
        ),
        DrawerMenuItemData(
          icon: Icons.settings,
          title: 'Paramètres',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SettingsScreen())),
        ),
        if (kDebugMode)
          DrawerMenuItemData(
            icon: Icons.bug_report,
            title: 'Reset DB (dev)',
            iconColor: Colors.orange,
            onTap: () => _resetDatabase(context, ref),
          ),
        DrawerMenuItemData(
          icon: Icons.info_outline,
          title: 'À propos',
          onTap: () {}, // TODO: Implement
        ),
      ],
    );
  }

  void _showTransactionDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => TransactionFormSheet(defaultType: type),
    );
  }

  Future<void> _resetDatabase(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Réinitialiser la base de données',
      content: 'Confirmer la suppression de toutes les données et reseed ?',
      confirmText: 'OK',
      isDangerous: true,
    );

    if (!confirmed || !context.mounted) return;

    final db = ref.read(databaseProvider);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
        const SnackBar(content: Text('Réinitialisation en cours...')));
    await db.resetToDefaultData(includeFakeData: true);
    messenger.showSnackBar(const SnackBar(content: Text('Base réinitialisée')));
  }
}

/// Section des comptes favoris avec gestion async
class _FavoriteAccountsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteAccountsProvider);
    final accountsAsync = ref.watch(accountsProvider);

    return favoritesAsync.when(
      data: (favorites) => accountsAsync.when(
        data: (accounts) {
          final accountMap = {for (var a in accounts) a.id: a};
          final favoriteAccounts = List.generate(3, (index) {
            try {
              final fav = favorites.firstWhere((f) => f.buttonIndex == index);
              return accountMap[fav.accountId];
            } catch (e) {
              return null;
            }
          });

          return FavoriteAccountsRow(
            accounts: favoriteAccounts,
            onTap: (index, account) => _handleFavoriteButtonTap(
                context, ref, index, account, accounts),
          );
        },
        loading: () => const LoadingPlaceholder(height: 64),
        error: (e, s) =>
            const SizedBox(height: 64, child: Center(child: Text('Erreur'))),
      ),
      loading: () => const LoadingPlaceholder(height: 64),
      error: (e, s) =>
          const SizedBox(height: 64, child: Center(child: Text('Erreur'))),
    );
  }

  void _handleFavoriteButtonTap(
    BuildContext context,
    WidgetRef ref,
    int buttonIndex,
    Account? currentAccount,
    List<Account> allAccounts,
  ) {
    if (currentAccount != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AccountTransactionsScreen(account: currentAccount)),
      );
    } else {
      _showAccountSelectionDialog(context, ref, buttonIndex, allAccounts);
    }
  }

  Future<void> _showAccountSelectionDialog(
    BuildContext context,
    WidgetRef ref,
    int buttonIndex,
    List<Account> accounts,
  ) async {
    final selected = await AccountSelectionDialog.show(
      context: context,
      title: 'Assigner au bouton ${buttonIndex + 1}',
      accounts: accounts,
    );

    if (selected == null || !context.mounted) return;

    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Confirmation',
      content:
          'Voulez-vous assigner le compte "${selected.name}" au bouton ${buttonIndex + 1} ?',
      confirmText: 'Oui',
      cancelText: 'Non',
    );

    if (!confirmed || !context.mounted) return;

    final repo = ref.read(favoriteAccountsRepositoryProvider);
    await repo.assignFavorite(buttonIndex: buttonIndex, accountId: selected.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('${selected.name} assigné au bouton ${buttonIndex + 1}')),
      );
    }
  }
}

/// Liste des transactions avec gestion async
class _TransactionsList extends ConsumerWidget {
  final int accountId;

  const _TransactionsList({required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider(accountId));

    return AsyncValueWidget<List<Transaction>>(
      asyncValue: transactionsAsync,
      builder: (transactions) {
        if (transactions.isEmpty) {
          return const EmptyListWidget(
              message: 'Aucune opération', icon: Icons.receipt_long);
        }

        // Limiter à 10 dernières transactions pour performance
        final recentTransactions = transactions.take(10).toList();

        double runningBalance =
            ref.watch(accountBalanceProvider(accountId)) ?? 0;

        return ListView.builder(
          itemCount: recentTransactions.length,
          itemBuilder: (context, index) {
            final transaction = recentTransactions[index];
            final balanceAfter = runningBalance;
            runningBalance -= transaction.amount;

            return TransactionListItem(
              transaction: transaction,
              balanceAfter: balanceAfter,
              onEdit: () => _editTransaction(context, transaction),
              onDelete: () => _deleteTransaction(context, ref, transaction),
              onValidate: () => _validateTransaction(ref, transaction),
            );
          },
        );
      },
    );
  }

  void _editTransaction(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => TransactionFormSheet(transaction: transaction),
    );
  }

  Future<void> _deleteTransaction(
    BuildContext context,
    WidgetRef ref,
    Transaction transaction,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Confirmation',
      content: 'Voulez-vous vraiment supprimer cette opération ?',
      confirmText: 'Supprimer',
      isDangerous: true,
    );

    if (!confirmed) return;

    final repo = ref.read(transactionsRepositoryProvider);
    await repo.deleteTransaction(transaction.id);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Opération supprimée')));
    }
  }

  Future<void> _validateTransaction(
      WidgetRef ref, Transaction transaction) async {
    final repo = ref.read(transactionsRepositoryProvider);
    final newStatus = transaction.status == 'pending' ? 'validated' : 'pending';
    await repo.updateTransaction(
      id: transaction.id,
      accountId: transaction.accountId,
      categoryId: transaction.categoryId,
      beneficiaryId: transaction.beneficiaryId,
      accountToId: transaction.accountToId,
      amount: transaction.amount,
      date: transaction.date,
      note: transaction.note,
      status: newStatus,
    );
  }
}

/// Placeholder pour bannière publicitaire
class _AdBannerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 50,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Text(
          'Ad Banner Placeholder',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
