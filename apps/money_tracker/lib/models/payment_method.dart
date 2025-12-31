enum PaymentMethod {
  card('Carte bancaire'),
  transfer('Virement'),
  directDebit('Prélèvement'),
  check('Chèque'),
  cash('Espèces');

  const PaymentMethod(this.label);
  final String label;

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentMethod.card,
    );
  }

  String toStringValue() => name;
}
