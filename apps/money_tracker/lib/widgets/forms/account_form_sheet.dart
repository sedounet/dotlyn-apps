import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../providers/accounts_provider.dart';
import '../../utils/string_extensions.dart';
import 'fields/amount_form_field.dart';
import 'fields/dropdown_form_field_custom.dart';
import 'fields/text_form_field_custom.dart';

class AccountFormSheet extends ConsumerStatefulWidget {
  final Account? account;
  const AccountFormSheet({super.key, this.account});

  @override
  ConsumerState<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends ConsumerState<AccountFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  String _selectedType = 'current';
  var _isSaving = false;

  static const _typeChoices = <String>['current', 'savings', 'other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.account != null
          ? widget.account!.initialBalance.toStringAsFixed(2)
          : '',
    );
    _selectedType = widget.account?.type ?? _selectedType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final name = _nameController.text.trim();
    final type = _selectedType;
    final initialBalance =
        double.tryParse(_balanceController.text.replaceAll(',', '.')) ?? 0.0;
    final repository = ref.read(accountsRepositoryProvider);

    try {
      if (widget.account == null) {
        await repository.addAccount(
          name: name,
          type: type,
          initialBalance: initialBalance,
        );
      } else {
        await repository.updateAccount(
          id: widget.account!.id,
          name: name,
          type: type,
          initialBalance: initialBalance,
        );
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.account != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEdit ? 'Modifier le compte' : 'Nouveau compte',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormFieldCustom(
                controller: _nameController,
                label: 'Nom du compte',
                required: true,
              ),
              const SizedBox(height: 12),
              DropdownFormFieldCustom<String>(
                value: _selectedType,
                label: 'Type de compte',
                items: _typeChoices
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.capitalize()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              AmountFormField(
                controller: _balanceController,
                label: 'Solde initial',
                required: false,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEdit ? 'Mettre à jour' : 'Créer le compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
