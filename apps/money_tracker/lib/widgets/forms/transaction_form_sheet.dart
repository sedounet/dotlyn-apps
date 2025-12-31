import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../models/payment_method.dart';
import '../../providers/accounts_provider.dart';
import '../../providers/beneficiaries_provider.dart';
import '../../providers/categories_provider.dart';
import '../../providers/transactions_provider.dart';
import 'fields/amount_form_field.dart';
import 'fields/date_form_field.dart';
import 'fields/dropdown_form_field_custom.dart';
import 'fields/text_form_field_custom.dart';

class TransactionFormSheet extends ConsumerStatefulWidget {
  final Transaction? transaction;
  final int? accountId; // optional override
  final String? defaultType; // 'income' or 'expense' - used for quick add
  const TransactionFormSheet({super.key, this.transaction, this.accountId, this.defaultType});

  @override
  ConsumerState<TransactionFormSheet> createState() => _TransactionFormSheetState();
}

class _TransactionFormSheetState extends ConsumerState<TransactionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  int? _categoryId;
  int? _beneficiaryId;
  int? _accountToId; // For transfers
  int? _accountFromId; // For explicit source account in transfers
  DateTime _date = DateTime.now();
  String _status = 'pending';
  String _type = 'expense'; // 'income', 'expense', or 'transfer'
  PaymentMethod _paymentMethod = PaymentMethod.card;
  String? _checkNumber;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _amountController = TextEditingController(
      text: t != null ? t.amount.abs().toStringAsFixed(2) : '',
    );
    _noteController = TextEditingController(text: t?.note ?? '');
    _categoryId = t?.categoryId;
    _beneficiaryId = t?.beneficiaryId;
    _accountToId = t?.accountToId;
    _accountFromId = widget.accountId ?? t?.accountId;
    _date = t?.date ?? DateTime.now();
    _status = t?.status ?? 'pending';
    _paymentMethod = PaymentMethod.fromString(t?.paymentMethod ?? 'card');
    _checkNumber = t?.checkNumber;
    // Detect type: transfer if accountToId is set, otherwise income/expense based on amount
    if (t != null && t.accountToId != null) {
      _type = 'transfer';
    } else {
      _type = t != null ? (t.amount > 0 ? 'income' : 'expense') : (widget.defaultType ?? 'expense');
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Validation for transfers: need at least 2 accounts
    if (_type == 'transfer') {
      final accountsAsync = ref.read(accountsProvider);
      await accountsAsync.when(
        data: (accounts) async {
          if (accounts.length < 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vous devez avoir au moins 2 comptes pour effectuer un virement'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
        },
        loading: () async {},
        error: (e, s) async {},
      );

      // Exit early if validation failed
      final accounts = await ref.read(accountsProvider.future);
      if (accounts.length < 2) {
        return;
      }
    }

    if (!mounted) return;

    setState(() => _isSaving = true);

    final repository = ref.read(transactionsRepositoryProvider);
    final accountId = _type == 'transfer'
        ? _accountFromId
        : (widget.accountId ?? ref.read(activeAccountProvider)?.id);
    if (accountId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Aucun compte sélectionné')));
      setState(() => _isSaving = false);
      return;
    }

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
    final signedAmount = _type == 'income'
        ? amount.abs()
        : (_type == 'transfer' ? -amount.abs() : -amount.abs());

    try {
      if (widget.transaction == null) {
        await repository.addTransaction(
          accountId: accountId,
          categoryId: _type == 'transfer' ? null : _categoryId,
          beneficiaryId: _beneficiaryId,
          accountToId: _type == 'transfer' ? _accountToId : null,
          amount: signedAmount,
          date: _date,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          status: _status,
          paymentMethod: _paymentMethod,
          checkNumber: _checkNumber?.trim().isEmpty ?? true ? null : _checkNumber?.trim(),
        );
      } else {
        await repository.updateTransaction(
          id: widget.transaction!.id,
          accountId: accountId,
          categoryId: _type == 'transfer' ? null : (_categoryId ?? widget.transaction!.categoryId),
          beneficiaryId: _beneficiaryId ?? widget.transaction!.beneficiaryId,
          accountToId: _type == 'transfer' ? _accountToId : null,
          amount: signedAmount,
          date: _date,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          status: _status,
          paymentMethod: _paymentMethod,
          checkNumber: _checkNumber?.trim().isEmpty ?? true ? null : _checkNumber?.trim(),
        );
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final beneficiariesAsync = ref.watch(beneficiariesProvider);
    final isEdit = widget.transaction != null;

    final accountsAsync = ref.watch(accountsProvider);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEdit ? 'Modifier l\'opération' : 'Nouvelle opération',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                AmountFormField(controller: _amountController, label: 'Montant', required: true),
                const SizedBox(height: 12),
                DropdownFormFieldCustom<String>(
                  value: _type,
                  label: 'Type',
                  items: const [
                    DropdownMenuItem(value: 'expense', child: Text('Dépense')),
                    DropdownMenuItem(value: 'income', child: Text('Revenu')),
                    DropdownMenuItem(value: 'transfer', child: Text('Virement')),
                  ],
                  onChanged: (v) => setState(() {
                    _type = v ?? 'expense';
                    // Reset category and accountTo when changing type
                    if (v == 'transfer') {
                      _categoryId = null;
                    } else {
                      _accountToId = null;
                    }
                  }),
                ),
                const SizedBox(height: 12),
                // Sélection du compte source pour les virements
                if (_type == 'transfer')
                  accountsAsync.when(
                    data: (accounts) {
                      return DropdownButtonFormField<int>(
                        initialValue: _accountFromId,
                        items: accounts
                            .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                            .toList(),
                        onChanged: (v) => setState(() => _accountFromId = v),
                        decoration: const InputDecoration(labelText: 'Depuis le compte'),
                        validator: (v) => v == null ? 'Compte source requis' : null,
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Erreur comptes: $e'),
                  ),
                // Show account selector for transfer (required)
                if (_type == 'transfer')
                  Consumer(
                    builder: (context, ref, _) {
                      final accountsAsync = ref.watch(accountsProvider);
                      final currentAccountId =
                          widget.accountId ?? ref.read(activeAccountProvider)?.id;
                      return accountsAsync.when(
                        data: (accounts) {
                          final otherAccounts = accounts
                              .where((a) => a.id != currentAccountId)
                              .toList();
                          return DropdownButtonFormField<int>(
                            initialValue: _accountToId,
                            items: otherAccounts
                                .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                                .toList(),
                            onChanged: (v) => setState(() => _accountToId = v),
                            decoration: const InputDecoration(labelText: 'Vers le compte'),
                            validator: (v) => v == null ? 'Compte de destination requis' : null,
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (e, s) => Text('Erreur comptes: $e'),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                // Advanced options: Category & Beneficiary (collapsed by default)
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text('Options avancées'),
                    subtitle: Text(
                      'Catégorie et bénéficiaire',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    initiallyExpanded: _categoryId != null || _beneficiaryId != null,
                    children: [
                      // Category selector (only for income/expense)
                      if (_type != 'transfer')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: categoriesAsync.when(
                            data: (cats) {
                              final filtered = cats.where((c) => c.type == _type).toList();
                              return DropdownButtonFormField<int?>(
                                initialValue: _categoryId,
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Aucune catégorie'),
                                  ),
                                  ...filtered.map(
                                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                                  ),
                                ],
                                onChanged: (v) => setState(() => _categoryId = v),
                                decoration: const InputDecoration(labelText: 'Catégorie'),
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (e, s) => Text('Erreur catégories: $e'),
                          ),
                        ),
                      const SizedBox(height: 12),
                      // Beneficiary selector
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: beneficiariesAsync.when(
                          data: (ben) {
                            return DropdownButtonFormField<int?>(
                              initialValue: _beneficiaryId,
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('Aucun bénéficiaire'),
                                ),
                                ...ben.map(
                                  (b) => DropdownMenuItem(value: b.id, child: Text(b.name)),
                                ),
                              ],
                              onChanged: (v) => setState(() => _beneficiaryId = v),
                              decoration: const InputDecoration(labelText: 'Bénéficiaire'),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (e, s) => Text('Erreur bénéficiaires: $e'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Payment method selector
                DropdownFormFieldCustom<PaymentMethod>(
                  value: _paymentMethod,
                  label: 'Méthode de paiement',
                  items: PaymentMethod.values
                      .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _paymentMethod = v ?? PaymentMethod.card;
                    // Clear check number if not check payment
                    if (v != PaymentMethod.check) {
                      _checkNumber = null;
                    }
                  }),
                ),
                const SizedBox(height: 12),
                // Check number field (only visible for check payments)
                if (_paymentMethod == PaymentMethod.check)
                  TextFormFieldCustom(
                    controller: TextEditingController(text: _checkNumber ?? ''),
                    label: 'Numéro de chèque',
                    required: true,
                    onChanged: (v) => setState(() => _checkNumber = v),
                  ),
                const SizedBox(height: 12),
                DateFormField(
                  selectedDate: _date,
                  label: 'Date',
                  onDateSelected: (date) => setState(() => _date = date),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ),
                const SizedBox(height: 12),
                TextFormFieldCustom(
                  controller: _noteController,
                  label: 'Note',
                  required: false,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                DropdownFormFieldCustom<String>(
                  value: _status,
                  label: 'Statut',
                  items: const [
                    DropdownMenuItem(value: 'validated', child: Text('Validé')),
                    DropdownMenuItem(value: 'pending', child: Text('En attente')),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'validated'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : Text(isEdit ? 'Mettre à jour' : 'Créer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
