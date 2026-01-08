// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialBalanceMeta = const VerificationMeta(
    'initialBalance',
  );
  @override
  late final GeneratedColumn<double> initialBalance = GeneratedColumn<double>(
    'initial_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _defaultPaymentMethodMeta =
      const VerificationMeta('defaultPaymentMethod');
  @override
  late final GeneratedColumn<String> defaultPaymentMethod =
      GeneratedColumn<String>(
    'default_payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('card'),
  );
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        initialBalance,
        createdAt,
        defaultPaymentMethod,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('initial_balance')) {
      context.handle(
        _initialBalanceMeta,
        initialBalance.isAcceptableOrUnknown(
          data['initial_balance']!,
          _initialBalanceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('default_payment_method')) {
      context.handle(
        _defaultPaymentMethodMeta,
        defaultPaymentMethod.isAcceptableOrUnknown(
          data['default_payment_method']!,
          _defaultPaymentMethodMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      initialBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_balance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      defaultPaymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_payment_method'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;
  final String type;
  final double initialBalance;
  final DateTime createdAt;
  final String defaultPaymentMethod;
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.createdAt,
    required this.defaultPaymentMethod,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['initial_balance'] = Variable<double>(initialBalance);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['default_payment_method'] = Variable<String>(defaultPaymentMethod);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      initialBalance: Value(initialBalance),
      createdAt: Value(createdAt),
      defaultPaymentMethod: Value(defaultPaymentMethod),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      initialBalance: serializer.fromJson<double>(json['initialBalance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      defaultPaymentMethod: serializer.fromJson<String>(
        json['defaultPaymentMethod'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'initialBalance': serializer.toJson<double>(initialBalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'defaultPaymentMethod': serializer.toJson<String>(defaultPaymentMethod),
    };
  }

  Account copyWith({
    int? id,
    String? name,
    String? type,
    double? initialBalance,
    DateTime? createdAt,
    String? defaultPaymentMethod,
  }) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        initialBalance: initialBalance ?? this.initialBalance,
        createdAt: createdAt ?? this.createdAt,
        defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      defaultPaymentMethod: data.defaultPaymentMethod.present
          ? data.defaultPaymentMethod.value
          : this.defaultPaymentMethod,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('defaultPaymentMethod: $defaultPaymentMethod')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        type,
        initialBalance,
        createdAt,
        defaultPaymentMethod,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.initialBalance == this.initialBalance &&
          other.createdAt == this.createdAt &&
          other.defaultPaymentMethod == this.defaultPaymentMethod);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<double> initialBalance;
  final Value<DateTime> createdAt;
  final Value<String> defaultPaymentMethod;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.defaultPaymentMethod = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.initialBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.defaultPaymentMethod = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? initialBalance,
    Expression<DateTime>? createdAt,
    Expression<String>? defaultPaymentMethod,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (createdAt != null) 'created_at': createdAt,
      if (defaultPaymentMethod != null)
        'default_payment_method': defaultPaymentMethod,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<double>? initialBalance,
    Value<DateTime>? createdAt,
    Value<String>? defaultPaymentMethod,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      initialBalance: initialBalance ?? this.initialBalance,
      createdAt: createdAt ?? this.createdAt,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<double>(initialBalance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (defaultPaymentMethod.present) {
      map['default_payment_method'] = Variable<String>(
        defaultPaymentMethod.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('defaultPaymentMethod: $defaultPaymentMethod')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        icon,
        color,
        sortOrder,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String type;
  final String? icon;
  final String? color;
  final int sortOrder;
  const Category({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? type,
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    int? sortOrder,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        icon: icon.present ? icon.value : this.icon,
        color: color.present ? color.value : this.color,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, icon, color, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? icon,
    Value<String?>? color,
    Value<int>? sortOrder,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $BeneficiariesTable extends Beneficiaries
    with TableInfo<$BeneficiariesTable, Beneficiary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeneficiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beneficiaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Beneficiary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Beneficiary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Beneficiary(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BeneficiariesTable createAlias(String alias) {
    return $BeneficiariesTable(attachedDatabase, alias);
  }
}

class Beneficiary extends DataClass implements Insertable<Beneficiary> {
  final int id;
  final String name;
  final DateTime createdAt;
  const Beneficiary({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BeneficiariesCompanion toCompanion(bool nullToAbsent) {
    return BeneficiariesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Beneficiary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Beneficiary(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Beneficiary copyWith({int? id, String? name, DateTime? createdAt}) =>
      Beneficiary(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  Beneficiary copyWithCompanion(BeneficiariesCompanion data) {
    return Beneficiary(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Beneficiary(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Beneficiary &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class BeneficiariesCompanion extends UpdateCompanion<Beneficiary> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const BeneficiariesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BeneficiariesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Beneficiary> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BeneficiariesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return BeneficiariesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeneficiariesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _beneficiaryIdMeta = const VerificationMeta(
    'beneficiaryId',
  );
  @override
  late final GeneratedColumn<int> beneficiaryId = GeneratedColumn<int>(
    'beneficiary_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES beneficiaries (id)',
    ),
  );
  static const VerificationMeta _accountToIdMeta = const VerificationMeta(
    'accountToId',
  );
  @override
  late final GeneratedColumn<int> accountToId = GeneratedColumn<int>(
    'account_to_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('card'),
  );
  static const VerificationMeta _checkNumberMeta = const VerificationMeta(
    'checkNumber',
  );
  @override
  late final GeneratedColumn<String> checkNumber = GeneratedColumn<String>(
    'check_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        categoryId,
        beneficiaryId,
        accountToId,
        amount,
        date,
        note,
        status,
        paymentMethod,
        checkNumber,
        createdAt,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('beneficiary_id')) {
      context.handle(
        _beneficiaryIdMeta,
        beneficiaryId.isAcceptableOrUnknown(
          data['beneficiary_id']!,
          _beneficiaryIdMeta,
        ),
      );
    }
    if (data.containsKey('account_to_id')) {
      context.handle(
        _accountToIdMeta,
        accountToId.isAcceptableOrUnknown(
          data['account_to_id']!,
          _accountToIdMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('check_number')) {
      context.handle(
        _checkNumberMeta,
        checkNumber.isAcceptableOrUnknown(
          data['check_number']!,
          _checkNumberMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      beneficiaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}beneficiary_id'],
      ),
      accountToId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_to_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      checkNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_number'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int accountId;
  final int? categoryId;
  final int? beneficiaryId;
  final int? accountToId;
  final double amount;
  final DateTime date;
  final String? note;
  final String status;
  final String paymentMethod;
  final String? checkNumber;
  final DateTime createdAt;
  const Transaction({
    required this.id,
    required this.accountId,
    this.categoryId,
    this.beneficiaryId,
    this.accountToId,
    required this.amount,
    required this.date,
    this.note,
    required this.status,
    required this.paymentMethod,
    this.checkNumber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || beneficiaryId != null) {
      map['beneficiary_id'] = Variable<int>(beneficiaryId);
    }
    if (!nullToAbsent || accountToId != null) {
      map['account_to_id'] = Variable<int>(accountToId);
    }
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || checkNumber != null) {
      map['check_number'] = Variable<String>(checkNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      beneficiaryId: beneficiaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(beneficiaryId),
      accountToId: accountToId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountToId),
      amount: Value(amount),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      paymentMethod: Value(paymentMethod),
      checkNumber: checkNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(checkNumber),
      createdAt: Value(createdAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      beneficiaryId: serializer.fromJson<int?>(json['beneficiaryId']),
      accountToId: serializer.fromJson<int?>(json['accountToId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      checkNumber: serializer.fromJson<String?>(json['checkNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'beneficiaryId': serializer.toJson<int?>(beneficiaryId),
      'accountToId': serializer.toJson<int?>(accountToId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'checkNumber': serializer.toJson<String?>(checkNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transaction copyWith({
    int? id,
    int? accountId,
    Value<int?> categoryId = const Value.absent(),
    Value<int?> beneficiaryId = const Value.absent(),
    Value<int?> accountToId = const Value.absent(),
    double? amount,
    DateTime? date,
    Value<String?> note = const Value.absent(),
    String? status,
    String? paymentMethod,
    Value<String?> checkNumber = const Value.absent(),
    DateTime? createdAt,
  }) =>
      Transaction(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        beneficiaryId:
            beneficiaryId.present ? beneficiaryId.value : this.beneficiaryId,
        accountToId: accountToId.present ? accountToId.value : this.accountToId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        note: note.present ? note.value : this.note,
        status: status ?? this.status,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        checkNumber: checkNumber.present ? checkNumber.value : this.checkNumber,
        createdAt: createdAt ?? this.createdAt,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      beneficiaryId: data.beneficiaryId.present
          ? data.beneficiaryId.value
          : this.beneficiaryId,
      accountToId:
          data.accountToId.present ? data.accountToId.value : this.accountToId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      checkNumber:
          data.checkNumber.present ? data.checkNumber.value : this.checkNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('beneficiaryId: $beneficiaryId, ')
          ..write('accountToId: $accountToId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('checkNumber: $checkNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        accountId,
        categoryId,
        beneficiaryId,
        accountToId,
        amount,
        date,
        note,
        status,
        paymentMethod,
        checkNumber,
        createdAt,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.beneficiaryId == this.beneficiaryId &&
          other.accountToId == this.accountToId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.note == this.note &&
          other.status == this.status &&
          other.paymentMethod == this.paymentMethod &&
          other.checkNumber == this.checkNumber &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int?> categoryId;
  final Value<int?> beneficiaryId;
  final Value<int?> accountToId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String> status;
  final Value<String> paymentMethod;
  final Value<String?> checkNumber;
  final Value<DateTime> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.beneficiaryId = const Value.absent(),
    this.accountToId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.checkNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.categoryId = const Value.absent(),
    this.beneficiaryId = const Value.absent(),
    this.accountToId = const Value.absent(),
    required double amount,
    required DateTime date,
    this.note = const Value.absent(),
    required String status,
    this.paymentMethod = const Value.absent(),
    this.checkNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : accountId = Value(accountId),
        amount = Value(amount),
        date = Value(date),
        status = Value(status);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<int>? beneficiaryId,
    Expression<int>? accountToId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? status,
    Expression<String>? paymentMethod,
    Expression<String>? checkNumber,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (beneficiaryId != null) 'beneficiary_id': beneficiaryId,
      if (accountToId != null) 'account_to_id': accountToId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (checkNumber != null) 'check_number': checkNumber,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<int?>? categoryId,
    Value<int?>? beneficiaryId,
    Value<int?>? accountToId,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String?>? note,
    Value<String>? status,
    Value<String>? paymentMethod,
    Value<String?>? checkNumber,
    Value<DateTime>? createdAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      accountToId: accountToId ?? this.accountToId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      checkNumber: checkNumber ?? this.checkNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (beneficiaryId.present) {
      map['beneficiary_id'] = Variable<int>(beneficiaryId.value);
    }
    if (accountToId.present) {
      map['account_to_id'] = Variable<int>(accountToId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (checkNumber.present) {
      map['check_number'] = Variable<String>(checkNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('beneficiaryId: $beneficiaryId, ')
          ..write('accountToId: $accountToId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('checkNumber: $checkNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FavoriteAccountsTable extends FavoriteAccounts
    with TableInfo<$FavoriteAccountsTable, FavoriteAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _buttonIndexMeta = const VerificationMeta(
    'buttonIndex',
  );
  @override
  late final GeneratedColumn<int> buttonIndex = GeneratedColumn<int>(
    'button_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, buttonIndex, accountId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('button_index')) {
      context.handle(
        _buttonIndexMeta,
        buttonIndex.isAcceptableOrUnknown(
          data['button_index']!,
          _buttonIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_buttonIndexMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoriteAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      buttonIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}button_index'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $FavoriteAccountsTable createAlias(String alias) {
    return $FavoriteAccountsTable(attachedDatabase, alias);
  }
}

class FavoriteAccount extends DataClass implements Insertable<FavoriteAccount> {
  final int id;
  final int buttonIndex;
  final int accountId;
  const FavoriteAccount({
    required this.id,
    required this.buttonIndex,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['button_index'] = Variable<int>(buttonIndex);
    map['account_id'] = Variable<int>(accountId);
    return map;
  }

  FavoriteAccountsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteAccountsCompanion(
      id: Value(id),
      buttonIndex: Value(buttonIndex),
      accountId: Value(accountId),
    );
  }

  factory FavoriteAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteAccount(
      id: serializer.fromJson<int>(json['id']),
      buttonIndex: serializer.fromJson<int>(json['buttonIndex']),
      accountId: serializer.fromJson<int>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'buttonIndex': serializer.toJson<int>(buttonIndex),
      'accountId': serializer.toJson<int>(accountId),
    };
  }

  FavoriteAccount copyWith({int? id, int? buttonIndex, int? accountId}) =>
      FavoriteAccount(
        id: id ?? this.id,
        buttonIndex: buttonIndex ?? this.buttonIndex,
        accountId: accountId ?? this.accountId,
      );
  FavoriteAccount copyWithCompanion(FavoriteAccountsCompanion data) {
    return FavoriteAccount(
      id: data.id.present ? data.id.value : this.id,
      buttonIndex:
          data.buttonIndex.present ? data.buttonIndex.value : this.buttonIndex,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteAccount(')
          ..write('id: $id, ')
          ..write('buttonIndex: $buttonIndex, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, buttonIndex, accountId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteAccount &&
          other.id == this.id &&
          other.buttonIndex == this.buttonIndex &&
          other.accountId == this.accountId);
}

class FavoriteAccountsCompanion extends UpdateCompanion<FavoriteAccount> {
  final Value<int> id;
  final Value<int> buttonIndex;
  final Value<int> accountId;
  const FavoriteAccountsCompanion({
    this.id = const Value.absent(),
    this.buttonIndex = const Value.absent(),
    this.accountId = const Value.absent(),
  });
  FavoriteAccountsCompanion.insert({
    this.id = const Value.absent(),
    required int buttonIndex,
    required int accountId,
  })  : buttonIndex = Value(buttonIndex),
        accountId = Value(accountId);
  static Insertable<FavoriteAccount> custom({
    Expression<int>? id,
    Expression<int>? buttonIndex,
    Expression<int>? accountId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (buttonIndex != null) 'button_index': buttonIndex,
      if (accountId != null) 'account_id': accountId,
    });
  }

  FavoriteAccountsCompanion copyWith({
    Value<int>? id,
    Value<int>? buttonIndex,
    Value<int>? accountId,
  }) {
    return FavoriteAccountsCompanion(
      id: id ?? this.id,
      buttonIndex: buttonIndex ?? this.buttonIndex,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (buttonIndex.present) {
      map['button_index'] = Variable<int>(buttonIndex.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteAccountsCompanion(')
          ..write('id: $id, ')
          ..write('buttonIndex: $buttonIndex, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BeneficiariesTable beneficiaries = $BeneficiariesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $FavoriteAccountsTable favoriteAccounts = $FavoriteAccountsTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accounts,
        categories,
        beneficiaries,
        transactions,
        favoriteAccounts,
        appSettings,
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
        WritePropagation(
          on: TableUpdateQuery.onTableName(
            'accounts',
            limitUpdateKind: UpdateKind.delete,
          ),
          result: [TableUpdate('transactions', kind: UpdateKind.delete)],
        ),
        WritePropagation(
          on: TableUpdateQuery.onTableName(
            'accounts',
            limitUpdateKind: UpdateKind.delete,
          ),
          result: [TableUpdate('transactions', kind: UpdateKind.delete)],
        ),
        WritePropagation(
          on: TableUpdateQuery.onTableName(
            'accounts',
            limitUpdateKind: UpdateKind.delete,
          ),
          result: [TableUpdate('favorite_accounts', kind: UpdateKind.delete)],
        ),
      ]);
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String name,
  required String type,
  Value<double> initialBalance,
  Value<DateTime> createdAt,
  Value<String> defaultPaymentMethod,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<double> initialBalance,
  Value<DateTime> createdAt,
  Value<String> defaultPaymentMethod,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FavoriteAccountsTable, List<FavoriteAccount>>
      _favoriteAccountsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(
            db.favoriteAccounts,
            aliasName: $_aliasNameGenerator(
              db.accounts.id,
              db.favoriteAccounts.accountId,
            ),
          );

  $$FavoriteAccountsTableProcessedTableManager get favoriteAccountsRefs {
    final manager = $$FavoriteAccountsTableTableManager(
      $_db,
      $_db.favoriteAccounts,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _favoriteAccountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
        column: $table.name,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get type => $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<double> get initialBalance => $composableBuilder(
        column: $table.initialBalance,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get defaultPaymentMethod => $composableBuilder(
        column: $table.defaultPaymentMethod,
        builder: (column) => ColumnFilters(column),
      );

  Expression<bool> favoriteAccountsRefs(
    Expression<bool> Function($$FavoriteAccountsTableFilterComposer f) f,
  ) {
    final $$FavoriteAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favoriteAccounts,
      getReferencedColumn: (t) => t.accountId,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$FavoriteAccountsTableFilterComposer(
        $db: $db,
        $table: $db.favoriteAccounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get name => $composableBuilder(
        column: $table.name,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get type => $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<double> get initialBalance => $composableBuilder(
        column: $table.initialBalance,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get defaultPaymentMethod => $composableBuilder(
        column: $table.defaultPaymentMethod,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get initialBalance => $composableBuilder(
        column: $table.initialBalance,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get defaultPaymentMethod => $composableBuilder(
        column: $table.defaultPaymentMethod,
        builder: (column) => column,
      );

  Expression<T> favoriteAccountsRefs<T extends Object>(
    Expression<T> Function($$FavoriteAccountsTableAnnotationComposer a) f,
  ) {
    final $$FavoriteAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favoriteAccounts,
      getReferencedColumn: (t) => t.accountId,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$FavoriteAccountsTableAnnotationComposer(
        $db: $db,
        $table: $db.favoriteAccounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function({bool favoriteAccountsRefs})> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$AccountsTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$AccountsTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$AccountsTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<int> id = const Value.absent(),
              Value<String> name = const Value.absent(),
              Value<String> type = const Value.absent(),
              Value<double> initialBalance = const Value.absent(),
              Value<DateTime> createdAt = const Value.absent(),
              Value<String> defaultPaymentMethod = const Value.absent(),
            }) =>
                AccountsCompanion(
              id: id,
              name: name,
              type: type,
              initialBalance: initialBalance,
              createdAt: createdAt,
              defaultPaymentMethod: defaultPaymentMethod,
            ),
            createCompanionCallback: ({
              Value<int> id = const Value.absent(),
              required String name,
              required String type,
              Value<double> initialBalance = const Value.absent(),
              Value<DateTime> createdAt = const Value.absent(),
              Value<String> defaultPaymentMethod = const Value.absent(),
            }) =>
                AccountsCompanion.insert(
              id: id,
              name: name,
              type: type,
              initialBalance: initialBalance,
              createdAt: createdAt,
              defaultPaymentMethod: defaultPaymentMethod,
            ),
            withReferenceMapper: (p0) => p0
                .map(
                  (e) => (
                    e.readTable(table),
                    $$AccountsTableReferences(db, table, e),
                  ),
                )
                .toList(),
            prefetchHooksCallback: ({favoriteAccountsRefs = false}) {
              return PrefetchHooks(
                db: db,
                explicitlyWatchedTables: [
                  if (favoriteAccountsRefs) db.favoriteAccounts,
                ],
                addJoins: null,
                getPrefetchedDataCallback: (items) async {
                  return [
                    if (favoriteAccountsRefs)
                      await $_getPrefetchedData<Account, $AccountsTable,
                          FavoriteAccount>(
                        currentTable: table,
                        referencedTable: $$AccountsTableReferences
                            ._favoriteAccountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(
                          db,
                          table,
                          p0,
                        ).favoriteAccountsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items,
                      ),
                  ];
                },
              );
            },
          ),
        );
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function({bool favoriteAccountsRefs})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  required String type,
  Value<String?> icon,
  Value<String?> color,
  Value<int> sortOrder,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<String?> icon,
  Value<String?> color,
  Value<int> sortOrder,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
            db.transactions,
            aliasName: $_aliasNameGenerator(
              db.categories.id,
              db.transactions.categoryId,
            ),
          );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
        column: $table.name,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get type => $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get icon => $composableBuilder(
        column: $table.icon,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get color => $composableBuilder(
        column: $table.color,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
        column: $table.sortOrder,
        builder: (column) => ColumnFilters(column),
      );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$TransactionsTableFilterComposer(
        $db: $db,
        $table: $db.transactions,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get name => $composableBuilder(
        column: $table.name,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get type => $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get icon => $composableBuilder(
        column: $table.icon,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get color => $composableBuilder(
        column: $table.color,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
        column: $table.sortOrder,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$TransactionsTableAnnotationComposer(
        $db: $db,
        $table: $db.transactions,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$CategoriesTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$CategoriesTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$CategoriesTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<int> id = const Value.absent(),
              Value<String> name = const Value.absent(),
              Value<String> type = const Value.absent(),
              Value<String?> icon = const Value.absent(),
              Value<String?> color = const Value.absent(),
              Value<int> sortOrder = const Value.absent(),
            }) =>
                CategoriesCompanion(
              id: id,
              name: name,
              type: type,
              icon: icon,
              color: color,
              sortOrder: sortOrder,
            ),
            createCompanionCallback: ({
              Value<int> id = const Value.absent(),
              required String name,
              required String type,
              Value<String?> icon = const Value.absent(),
              Value<String?> color = const Value.absent(),
              Value<int> sortOrder = const Value.absent(),
            }) =>
                CategoriesCompanion.insert(
              id: id,
              name: name,
              type: type,
              icon: icon,
              color: color,
              sortOrder: sortOrder,
            ),
            withReferenceMapper: (p0) => p0
                .map(
                  (e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e),
                  ),
                )
                .toList(),
            prefetchHooksCallback: ({transactionsRefs = false}) {
              return PrefetchHooks(
                db: db,
                explicitlyWatchedTables: [
                  if (transactionsRefs) db.transactions
                ],
                addJoins: null,
                getPrefetchedDataCallback: (items) async {
                  return [
                    if (transactionsRefs)
                      await $_getPrefetchedData<Category, $CategoriesTable,
                          Transaction>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(
                          db,
                          table,
                          p0,
                        ).transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items,
                      ),
                  ];
                },
              );
            },
          ),
        );
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$BeneficiariesTableCreateCompanionBuilder = BeneficiariesCompanion
    Function({
  Value<int> id,
  required String name,
  Value<DateTime> createdAt,
});
typedef $$BeneficiariesTableUpdateCompanionBuilder = BeneficiariesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
});

final class $$BeneficiariesTableReferences
    extends BaseReferences<_$AppDatabase, $BeneficiariesTable, Beneficiary> {
  $$BeneficiariesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
            db.transactions,
            aliasName: $_aliasNameGenerator(
              db.beneficiaries.id,
              db.transactions.beneficiaryId,
            ),
          );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.beneficiaryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BeneficiariesTableFilterComposer
    extends Composer<_$AppDatabase, $BeneficiariesTable> {
  $$BeneficiariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
        column: $table.name,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnFilters(column),
      );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.beneficiaryId,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$TransactionsTableFilterComposer(
        $db: $db,
        $table: $db.transactions,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return f(composer);
  }
}

class $$BeneficiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $BeneficiariesTable> {
  $$BeneficiariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get name => $composableBuilder(
        column: $table.name,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$BeneficiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BeneficiariesTable> {
  $$BeneficiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.beneficiaryId,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$TransactionsTableAnnotationComposer(
        $db: $db,
        $table: $db.transactions,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return f(composer);
  }
}

class $$BeneficiariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BeneficiariesTable,
    Beneficiary,
    $$BeneficiariesTableFilterComposer,
    $$BeneficiariesTableOrderingComposer,
    $$BeneficiariesTableAnnotationComposer,
    $$BeneficiariesTableCreateCompanionBuilder,
    $$BeneficiariesTableUpdateCompanionBuilder,
    (Beneficiary, $$BeneficiariesTableReferences),
    Beneficiary,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$BeneficiariesTableTableManager(_$AppDatabase db, $BeneficiariesTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$BeneficiariesTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$BeneficiariesTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$BeneficiariesTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<int> id = const Value.absent(),
              Value<String> name = const Value.absent(),
              Value<DateTime> createdAt = const Value.absent(),
            }) =>
                BeneficiariesCompanion(
              id: id,
              name: name,
              createdAt: createdAt,
            ),
            createCompanionCallback: ({
              Value<int> id = const Value.absent(),
              required String name,
              Value<DateTime> createdAt = const Value.absent(),
            }) =>
                BeneficiariesCompanion.insert(
              id: id,
              name: name,
              createdAt: createdAt,
            ),
            withReferenceMapper: (p0) => p0
                .map(
                  (e) => (
                    e.readTable(table),
                    $$BeneficiariesTableReferences(db, table, e),
                  ),
                )
                .toList(),
            prefetchHooksCallback: ({transactionsRefs = false}) {
              return PrefetchHooks(
                db: db,
                explicitlyWatchedTables: [
                  if (transactionsRefs) db.transactions
                ],
                addJoins: null,
                getPrefetchedDataCallback: (items) async {
                  return [
                    if (transactionsRefs)
                      await $_getPrefetchedData<Beneficiary,
                          $BeneficiariesTable, Transaction>(
                        currentTable: table,
                        referencedTable: $$BeneficiariesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BeneficiariesTableReferences(
                          db,
                          table,
                          p0,
                        ).transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                          (e) => e.beneficiaryId == item.id,
                        ),
                        typedResults: items,
                      ),
                  ];
                },
              );
            },
          ),
        );
}

typedef $$BeneficiariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BeneficiariesTable,
    Beneficiary,
    $$BeneficiariesTableFilterComposer,
    $$BeneficiariesTableOrderingComposer,
    $$BeneficiariesTableAnnotationComposer,
    $$BeneficiariesTableCreateCompanionBuilder,
    $$BeneficiariesTableUpdateCompanionBuilder,
    (Beneficiary, $$BeneficiariesTableReferences),
    Beneficiary,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required int accountId,
  Value<int?> categoryId,
  Value<int?> beneficiaryId,
  Value<int?> accountToId,
  required double amount,
  required DateTime date,
  Value<String?> note,
  required String status,
  Value<String> paymentMethod,
  Value<String?> checkNumber,
  Value<DateTime> createdAt,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<int> accountId,
  Value<int?> categoryId,
  Value<int?> beneficiaryId,
  Value<int?> accountToId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String?> note,
  Value<String> status,
  Value<String> paymentMethod,
  Value<String?> checkNumber,
  Value<DateTime> createdAt,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.transactions.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.transactions.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BeneficiariesTable _beneficiaryIdTable(_$AppDatabase db) =>
      db.beneficiaries.createAlias(
        $_aliasNameGenerator(
          db.transactions.beneficiaryId,
          db.beneficiaries.id,
        ),
      );

  $$BeneficiariesTableProcessedTableManager? get beneficiaryId {
    final $_column = $_itemColumn<int>('beneficiary_id');
    if ($_column == null) return null;
    final manager = $$BeneficiariesTableTableManager(
      $_db,
      $_db.beneficiaries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_beneficiaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountToIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.transactions.accountToId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager? get accountToId {
    final $_column = $_itemColumn<int>('account_to_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountToIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<double> get amount => $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get date => $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
        column: $table.note,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get status => $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
        column: $table.paymentMethod,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get checkNumber => $composableBuilder(
        column: $table.checkNumber,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnFilters(column),
      );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableFilterComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$CategoriesTableFilterComposer(
        $db: $db,
        $table: $db.categories,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$BeneficiariesTableFilterComposer get beneficiaryId {
    final $$BeneficiariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beneficiaryId,
      referencedTable: $db.beneficiaries,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$BeneficiariesTableFilterComposer(
        $db: $db,
        $table: $db.beneficiaries,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountToId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountToId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableFilterComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<double> get amount => $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get date => $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get note => $composableBuilder(
        column: $table.note,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get status => $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
        column: $table.paymentMethod,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get checkNumber => $composableBuilder(
        column: $table.checkNumber,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnOrderings(column),
      );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableOrderingComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$CategoriesTableOrderingComposer(
        $db: $db,
        $table: $db.categories,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$BeneficiariesTableOrderingComposer get beneficiaryId {
    final $$BeneficiariesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beneficiaryId,
      referencedTable: $db.beneficiaries,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$BeneficiariesTableOrderingComposer(
        $db: $db,
        $table: $db.beneficiaries,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountToId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountToId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableOrderingComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
        column: $table.paymentMethod,
        builder: (column) => column,
      );

  GeneratedColumn<String> get checkNumber => $composableBuilder(
        column: $table.checkNumber,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableAnnotationComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$CategoriesTableAnnotationComposer(
        $db: $db,
        $table: $db.categories,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$BeneficiariesTableAnnotationComposer get beneficiaryId {
    final $$BeneficiariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beneficiaryId,
      referencedTable: $db.beneficiaries,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$BeneficiariesTableAnnotationComposer(
        $db: $db,
        $table: $db.beneficiaries,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountToId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountToId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableAnnotationComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function({
      bool accountId,
      bool categoryId,
      bool beneficiaryId,
      bool accountToId,
    })> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$TransactionsTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$TransactionsTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$TransactionsTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<int> id = const Value.absent(),
              Value<int> accountId = const Value.absent(),
              Value<int?> categoryId = const Value.absent(),
              Value<int?> beneficiaryId = const Value.absent(),
              Value<int?> accountToId = const Value.absent(),
              Value<double> amount = const Value.absent(),
              Value<DateTime> date = const Value.absent(),
              Value<String?> note = const Value.absent(),
              Value<String> status = const Value.absent(),
              Value<String> paymentMethod = const Value.absent(),
              Value<String?> checkNumber = const Value.absent(),
              Value<DateTime> createdAt = const Value.absent(),
            }) =>
                TransactionsCompanion(
              id: id,
              accountId: accountId,
              categoryId: categoryId,
              beneficiaryId: beneficiaryId,
              accountToId: accountToId,
              amount: amount,
              date: date,
              note: note,
              status: status,
              paymentMethod: paymentMethod,
              checkNumber: checkNumber,
              createdAt: createdAt,
            ),
            createCompanionCallback: ({
              Value<int> id = const Value.absent(),
              required int accountId,
              Value<int?> categoryId = const Value.absent(),
              Value<int?> beneficiaryId = const Value.absent(),
              Value<int?> accountToId = const Value.absent(),
              required double amount,
              required DateTime date,
              Value<String?> note = const Value.absent(),
              required String status,
              Value<String> paymentMethod = const Value.absent(),
              Value<String?> checkNumber = const Value.absent(),
              Value<DateTime> createdAt = const Value.absent(),
            }) =>
                TransactionsCompanion.insert(
              id: id,
              accountId: accountId,
              categoryId: categoryId,
              beneficiaryId: beneficiaryId,
              accountToId: accountToId,
              amount: amount,
              date: date,
              note: note,
              status: status,
              paymentMethod: paymentMethod,
              checkNumber: checkNumber,
              createdAt: createdAt,
            ),
            withReferenceMapper: (p0) => p0
                .map(
                  (e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e),
                  ),
                )
                .toList(),
            prefetchHooksCallback: ({
              accountId = false,
              categoryId = false,
              beneficiaryId = false,
              accountToId = false,
            }) {
              return PrefetchHooks(
                db: db,
                explicitlyWatchedTables: [],
                addJoins: <
                    T extends TableManagerState<
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic>>(state) {
                  if (accountId) {
                    state = state.withJoin(
                      currentTable: table,
                      currentColumn: table.accountId,
                      referencedTable:
                          $$TransactionsTableReferences._accountIdTable(db),
                      referencedColumn:
                          $$TransactionsTableReferences._accountIdTable(db).id,
                    ) as T;
                  }
                  if (categoryId) {
                    state = state.withJoin(
                      currentTable: table,
                      currentColumn: table.categoryId,
                      referencedTable:
                          $$TransactionsTableReferences._categoryIdTable(db),
                      referencedColumn:
                          $$TransactionsTableReferences._categoryIdTable(db).id,
                    ) as T;
                  }
                  if (beneficiaryId) {
                    state = state.withJoin(
                      currentTable: table,
                      currentColumn: table.beneficiaryId,
                      referencedTable:
                          $$TransactionsTableReferences._beneficiaryIdTable(db),
                      referencedColumn: $$TransactionsTableReferences
                          ._beneficiaryIdTable(db)
                          .id,
                    ) as T;
                  }
                  if (accountToId) {
                    state = state.withJoin(
                      currentTable: table,
                      currentColumn: table.accountToId,
                      referencedTable:
                          $$TransactionsTableReferences._accountToIdTable(db),
                      referencedColumn: $$TransactionsTableReferences
                          ._accountToIdTable(db)
                          .id,
                    ) as T;
                  }

                  return state;
                },
                getPrefetchedDataCallback: (items) async {
                  return [];
                },
              );
            },
          ),
        );
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function({
      bool accountId,
      bool categoryId,
      bool beneficiaryId,
      bool accountToId,
    })>;
typedef $$FavoriteAccountsTableCreateCompanionBuilder
    = FavoriteAccountsCompanion Function({
  Value<int> id,
  required int buttonIndex,
  required int accountId,
});
typedef $$FavoriteAccountsTableUpdateCompanionBuilder
    = FavoriteAccountsCompanion Function({
  Value<int> id,
  Value<int> buttonIndex,
  Value<int> accountId,
});

final class $$FavoriteAccountsTableReferences extends BaseReferences<
    _$AppDatabase, $FavoriteAccountsTable, FavoriteAccount> {
  $$FavoriteAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.favoriteAccounts.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FavoriteAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteAccountsTable> {
  $$FavoriteAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get buttonIndex => $composableBuilder(
        column: $table.buttonIndex,
        builder: (column) => ColumnFilters(column),
      );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableFilterComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$FavoriteAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteAccountsTable> {
  $$FavoriteAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get buttonIndex => $composableBuilder(
        column: $table.buttonIndex,
        builder: (column) => ColumnOrderings(column),
      );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableOrderingComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$FavoriteAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteAccountsTable> {
  $$FavoriteAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get buttonIndex => $composableBuilder(
        column: $table.buttonIndex,
        builder: (column) => column,
      );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$AccountsTableAnnotationComposer(
        $db: $db,
        $table: $db.accounts,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$FavoriteAccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoriteAccountsTable,
    FavoriteAccount,
    $$FavoriteAccountsTableFilterComposer,
    $$FavoriteAccountsTableOrderingComposer,
    $$FavoriteAccountsTableAnnotationComposer,
    $$FavoriteAccountsTableCreateCompanionBuilder,
    $$FavoriteAccountsTableUpdateCompanionBuilder,
    (FavoriteAccount, $$FavoriteAccountsTableReferences),
    FavoriteAccount,
    PrefetchHooks Function({bool accountId})> {
  $$FavoriteAccountsTableTableManager(
    _$AppDatabase db,
    $FavoriteAccountsTable table,
  ) : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$FavoriteAccountsTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$FavoriteAccountsTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$FavoriteAccountsTableAnnotationComposer(
                    $db: db, $table: table),
            updateCompanionCallback: ({
              Value<int> id = const Value.absent(),
              Value<int> buttonIndex = const Value.absent(),
              Value<int> accountId = const Value.absent(),
            }) =>
                FavoriteAccountsCompanion(
              id: id,
              buttonIndex: buttonIndex,
              accountId: accountId,
            ),
            createCompanionCallback: ({
              Value<int> id = const Value.absent(),
              required int buttonIndex,
              required int accountId,
            }) =>
                FavoriteAccountsCompanion.insert(
              id: id,
              buttonIndex: buttonIndex,
              accountId: accountId,
            ),
            withReferenceMapper: (p0) => p0
                .map(
                  (e) => (
                    e.readTable(table),
                    $$FavoriteAccountsTableReferences(db, table, e),
                  ),
                )
                .toList(),
            prefetchHooksCallback: ({accountId = false}) {
              return PrefetchHooks(
                db: db,
                explicitlyWatchedTables: [],
                addJoins: <
                    T extends TableManagerState<
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic>>(state) {
                  if (accountId) {
                    state = state.withJoin(
                      currentTable: table,
                      currentColumn: table.accountId,
                      referencedTable:
                          $$FavoriteAccountsTableReferences._accountIdTable(db),
                      referencedColumn: $$FavoriteAccountsTableReferences
                          ._accountIdTable(db)
                          .id,
                    ) as T;
                  }

                  return state;
                },
                getPrefetchedDataCallback: (items) async {
                  return [];
                },
              );
            },
          ),
        );
}

typedef $$FavoriteAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoriteAccountsTable,
    FavoriteAccount,
    $$FavoriteAccountsTableFilterComposer,
    $$FavoriteAccountsTableOrderingComposer,
    $$FavoriteAccountsTableAnnotationComposer,
    $$FavoriteAccountsTableCreateCompanionBuilder,
    $$FavoriteAccountsTableUpdateCompanionBuilder,
    (FavoriteAccount, $$FavoriteAccountsTableReferences),
    FavoriteAccount,
    PrefetchHooks Function({bool accountId})>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
        column: $table.key,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get value => $composableBuilder(
        column: $table.value,
        builder: (column) => ColumnFilters(column),
      );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
        column: $table.key,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get value => $composableBuilder(
        column: $table.value,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSetting,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
    ),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$AppSettingsTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$AppSettingsTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$AppSettingsTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<String> key = const Value.absent(),
              Value<String> value = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                AppSettingsCompanion(key: key, value: value, rowid: rowid),
            createCompanionCallback: ({
              required String key,
              required String value,
              Value<int> rowid = const Value.absent(),
            }) =>
                AppSettingsCompanion.insert(
              key: key,
              value: value,
              rowid: rowid,
            ),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (
      AppSetting,
      BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
    ),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$BeneficiariesTableTableManager get beneficiaries =>
      $$BeneficiariesTableTableManager(_db, _db.beneficiaries);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$FavoriteAccountsTableTableManager get favoriteAccounts =>
      $$FavoriteAccountsTableTableManager(_db, _db.favoriteAccounts);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
