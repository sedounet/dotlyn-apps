import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/database/app_database.dart';
import '../../providers/transactions_provider.dart';
import '../../providers/categories_provider.dart';
import '../../providers/beneficiaries_provider.dart';
import '../../providers/accounts_provider.dart';

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
  String _status = 'validated';
  String _type = 'expense'; // 'income', 'expense', or 'transfer'
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
    _status = t?.status ?? 'validated';
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
    setState(() => _isSaving = true);

    final repository = ref.read(transactionsRepositoryProvider);
    final accounts = ref.read(accountsProvider).value ?? [];
    final accountId = _type == 'transfer'
        ? _accountFromId
        : (widget.accountId ?? ref.read(activeAccountProvider)?.id);
    if (accountId == null) {
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
    final dateFormatter = DateFormat.yMd('fr_FR');

    final accountsAsync = ref.watch(accountsProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEdit ? 'Modifier l\'opération' : 'Nouvelle opération',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Montant'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Montant requis' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _type,
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
                ],
              ),
              const SizedBox(height: 12),
              // Sélection du compte source pour les virements
              if (_type == 'transfer')
                accountsAsync.when(
                  data: (accounts) {
                    return DropdownButtonFormField<int>(
                      value: _accountFromId,
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
              // Show category selector for income/expense, account selector for transfer
              if (_type != 'transfer')
                categoriesAsync.when(
                  data: (cats) {
                    final filtered = cats.where((c) => c.type == _type).toList();
                    return DropdownButtonFormField<int>(
                      initialValue: _categoryId,
                      items: filtered
                          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                          .toList(),
                      onChanged: (v) => setState(() => _categoryId = v),
                      decoration: const InputDecoration(labelText: 'Catégorie'),
                      validator: (v) => v == null ? 'Catégorie requise' : null,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Erreur catégories: $e'),
                )
              else
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
              beneficiariesAsync.when(
                data: (ben) {
                  return DropdownButtonFormField<int?>(
                    initialValue: _beneficiaryId,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Aucun')),
                      ...ben.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))),
                    ],
                    onChanged: (v) => setState(() => _beneficiaryId = v),
                    decoration: const InputDecoration(labelText: 'Bénéficiaire'),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text('Erreur bénéficiaires: $e'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text('Date: ${dateFormatter.format(_date)}')),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    child: const Text('Changer'),
                  ),
                ],
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Validé'),
                      value: 'validated',
                      groupValue: _status,
                      onChanged: (v) => setState(() => _status = v ?? 'validated'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('En attente'),
                      value: 'pending',
                      groupValue: _status,
                      onChanged: (v) => setState(() => _status = v ?? 'pending'),
                    ),
                  ),
                ],
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
    );
  }
}
