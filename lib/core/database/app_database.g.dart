// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WalletsTable extends Wallets with TableInfo<$WalletsTable, Wallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('personal'));
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('IDR'));
  static const VerificationMeta _iconCodeMeta =
      const VerificationMeta('iconCode');
  @override
  late final GeneratedColumn<String> iconCode = GeneratedColumn<String>(
      'icon_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorCodeMeta =
      const VerificationMeta('colorCode');
  @override
  late final GeneratedColumn<String> colorCode = GeneratedColumn<String>(
      'color_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        balance,
        currency,
        iconCode,
        colorCode,
        description,
        createdAt,
        updatedAt,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(Insertable<Wallet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('icon_code')) {
      context.handle(_iconCodeMeta,
          iconCode.isAcceptableOrUnknown(data['icon_code']!, _iconCodeMeta));
    }
    if (data.containsKey('color_code')) {
      context.handle(_colorCodeMeta,
          colorCode.isAcceptableOrUnknown(data['color_code']!, _colorCodeMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Wallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wallet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      iconCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_code']),
      colorCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_code']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class Wallet extends DataClass implements Insertable<Wallet> {
  final int id;
  final String name;
  final String category;
  final double balance;
  final String currency;
  final String? iconCode;
  final String? colorCode;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  const Wallet(
      {required this.id,
      required this.name,
      required this.category,
      required this.balance,
      required this.currency,
      this.iconCode,
      this.colorCode,
      this.description,
      required this.createdAt,
      required this.updatedAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['balance'] = Variable<double>(balance);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || iconCode != null) {
      map['icon_code'] = Variable<String>(iconCode);
    }
    if (!nullToAbsent || colorCode != null) {
      map['color_code'] = Variable<String>(colorCode);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      balance: Value(balance),
      currency: Value(currency),
      iconCode: iconCode == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCode),
      colorCode: colorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(colorCode),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isActive: Value(isActive),
    );
  }

  factory Wallet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Wallet(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      balance: serializer.fromJson<double>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
      iconCode: serializer.fromJson<String?>(json['iconCode']),
      colorCode: serializer.fromJson<String?>(json['colorCode']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'balance': serializer.toJson<double>(balance),
      'currency': serializer.toJson<String>(currency),
      'iconCode': serializer.toJson<String?>(iconCode),
      'colorCode': serializer.toJson<String?>(colorCode),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Wallet copyWith(
          {int? id,
          String? name,
          String? category,
          double? balance,
          String? currency,
          Value<String?> iconCode = const Value.absent(),
          Value<String?> colorCode = const Value.absent(),
          Value<String?> description = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isActive}) =>
      Wallet(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        balance: balance ?? this.balance,
        currency: currency ?? this.currency,
        iconCode: iconCode.present ? iconCode.value : this.iconCode,
        colorCode: colorCode.present ? colorCode.value : this.colorCode,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isActive: isActive ?? this.isActive,
      );
  Wallet copyWithCompanion(WalletsCompanion data) {
    return Wallet(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      balance: data.balance.present ? data.balance.value : this.balance,
      currency: data.currency.present ? data.currency.value : this.currency,
      iconCode: data.iconCode.present ? data.iconCode.value : this.iconCode,
      colorCode: data.colorCode.present ? data.colorCode.value : this.colorCode,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Wallet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('iconCode: $iconCode, ')
          ..write('colorCode: $colorCode, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, balance, currency,
      iconCode, colorCode, description, createdAt, updatedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wallet &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.balance == this.balance &&
          other.currency == this.currency &&
          other.iconCode == this.iconCode &&
          other.colorCode == this.colorCode &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isActive == this.isActive);
}

class WalletsCompanion extends UpdateCompanion<Wallet> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<double> balance;
  final Value<String> currency;
  final Value<String?> iconCode;
  final Value<String?> colorCode;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isActive;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.iconCode = const Value.absent(),
    this.colorCode = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.iconCode = const Value.absent(),
    this.colorCode = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Wallet> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? balance,
    Expression<String>? currency,
    Expression<String>? iconCode,
    Expression<String>? colorCode,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
      if (iconCode != null) 'icon_code': iconCode,
      if (colorCode != null) 'color_code': colorCode,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  WalletsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? category,
      Value<double>? balance,
      Value<String>? currency,
      Value<String?>? iconCode,
      Value<String?>? colorCode,
      Value<String?>? description,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isActive}) {
    return WalletsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      iconCode: iconCode ?? this.iconCode,
      colorCode: colorCode ?? this.colorCode,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (iconCode.present) {
      map['icon_code'] = Variable<String>(iconCode.value);
    }
    if (colorCode.present) {
      map['color_code'] = Variable<String>(colorCode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('iconCode: $iconCode, ')
          ..write('colorCode: $colorCode, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $InternalDebtsTable extends InternalDebts
    with TableInfo<$InternalDebtsTable, InternalDebt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InternalDebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalAmountMeta =
      const VerificationMeta('originalAmount');
  @override
  late final GeneratedColumn<double> originalAmount = GeneratedColumn<double>(
      'original_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _remainingAmountMeta =
      const VerificationMeta('remainingAmount');
  @override
  late final GeneratedColumn<double> remainingAmount = GeneratedColumn<double>(
      'remaining_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _sourceWalletIdMeta =
      const VerificationMeta('sourceWalletId');
  @override
  late final GeneratedColumn<int> sourceWalletId = GeneratedColumn<int>(
      'source_wallet_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (id)'));
  static const VerificationMeta _destinationWalletIdMeta =
      const VerificationMeta('destinationWalletId');
  @override
  late final GeneratedColumn<int> destinationWalletId = GeneratedColumn<int>(
      'destination_wallet_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (id)'));
  static const VerificationMeta _borrowedAtMeta =
      const VerificationMeta('borrowedAt');
  @override
  late final GeneratedColumn<DateTime> borrowedAt = GeneratedColumn<DateTime>(
      'borrowed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _targetRepaymentDateMeta =
      const VerificationMeta('targetRepaymentDate');
  @override
  late final GeneratedColumn<DateTime> targetRepaymentDate =
      GeneratedColumn<DateTime>('target_repayment_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _settledAtMeta =
      const VerificationMeta('settledAt');
  @override
  late final GeneratedColumn<DateTime> settledAt = GeneratedColumn<DateTime>(
      'settled_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        originalAmount,
        remainingAmount,
        status,
        sourceWalletId,
        destinationWalletId,
        borrowedAt,
        targetRepaymentDate,
        settledAt,
        note,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'internal_debts';
  @override
  VerificationContext validateIntegrity(Insertable<InternalDebt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_amount')) {
      context.handle(
          _originalAmountMeta,
          originalAmount.isAcceptableOrUnknown(
              data['original_amount']!, _originalAmountMeta));
    } else if (isInserting) {
      context.missing(_originalAmountMeta);
    }
    if (data.containsKey('remaining_amount')) {
      context.handle(
          _remainingAmountMeta,
          remainingAmount.isAcceptableOrUnknown(
              data['remaining_amount']!, _remainingAmountMeta));
    } else if (isInserting) {
      context.missing(_remainingAmountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('source_wallet_id')) {
      context.handle(
          _sourceWalletIdMeta,
          sourceWalletId.isAcceptableOrUnknown(
              data['source_wallet_id']!, _sourceWalletIdMeta));
    } else if (isInserting) {
      context.missing(_sourceWalletIdMeta);
    }
    if (data.containsKey('destination_wallet_id')) {
      context.handle(
          _destinationWalletIdMeta,
          destinationWalletId.isAcceptableOrUnknown(
              data['destination_wallet_id']!, _destinationWalletIdMeta));
    } else if (isInserting) {
      context.missing(_destinationWalletIdMeta);
    }
    if (data.containsKey('borrowed_at')) {
      context.handle(
          _borrowedAtMeta,
          borrowedAt.isAcceptableOrUnknown(
              data['borrowed_at']!, _borrowedAtMeta));
    } else if (isInserting) {
      context.missing(_borrowedAtMeta);
    }
    if (data.containsKey('target_repayment_date')) {
      context.handle(
          _targetRepaymentDateMeta,
          targetRepaymentDate.isAcceptableOrUnknown(
              data['target_repayment_date']!, _targetRepaymentDateMeta));
    }
    if (data.containsKey('settled_at')) {
      context.handle(_settledAtMeta,
          settledAt.isAcceptableOrUnknown(data['settled_at']!, _settledAtMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InternalDebt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InternalDebt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      originalAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}original_amount'])!,
      remainingAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}remaining_amount'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      sourceWalletId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_wallet_id'])!,
      destinationWalletId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}destination_wallet_id'])!,
      borrowedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}borrowed_at'])!,
      targetRepaymentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}target_repayment_date']),
      settledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}settled_at']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InternalDebtsTable createAlias(String alias) {
    return $InternalDebtsTable(attachedDatabase, alias);
  }
}

class InternalDebt extends DataClass implements Insertable<InternalDebt> {
  final int id;
  final String title;
  final double originalAmount;
  final double remainingAmount;
  final String status;

  /// Dana DIAMBIL DARI dompet ini
  final int sourceWalletId;

  /// Dana MASUK KE dompet ini
  final int destinationWalletId;
  final DateTime borrowedAt;
  final DateTime? targetRepaymentDate;
  final DateTime? settledAt;
  final String? note;
  final DateTime createdAt;
  const InternalDebt(
      {required this.id,
      required this.title,
      required this.originalAmount,
      required this.remainingAmount,
      required this.status,
      required this.sourceWalletId,
      required this.destinationWalletId,
      required this.borrowedAt,
      this.targetRepaymentDate,
      this.settledAt,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['original_amount'] = Variable<double>(originalAmount);
    map['remaining_amount'] = Variable<double>(remainingAmount);
    map['status'] = Variable<String>(status);
    map['source_wallet_id'] = Variable<int>(sourceWalletId);
    map['destination_wallet_id'] = Variable<int>(destinationWalletId);
    map['borrowed_at'] = Variable<DateTime>(borrowedAt);
    if (!nullToAbsent || targetRepaymentDate != null) {
      map['target_repayment_date'] = Variable<DateTime>(targetRepaymentDate);
    }
    if (!nullToAbsent || settledAt != null) {
      map['settled_at'] = Variable<DateTime>(settledAt);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InternalDebtsCompanion toCompanion(bool nullToAbsent) {
    return InternalDebtsCompanion(
      id: Value(id),
      title: Value(title),
      originalAmount: Value(originalAmount),
      remainingAmount: Value(remainingAmount),
      status: Value(status),
      sourceWalletId: Value(sourceWalletId),
      destinationWalletId: Value(destinationWalletId),
      borrowedAt: Value(borrowedAt),
      targetRepaymentDate: targetRepaymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRepaymentDate),
      settledAt: settledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(settledAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory InternalDebt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InternalDebt(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      originalAmount: serializer.fromJson<double>(json['originalAmount']),
      remainingAmount: serializer.fromJson<double>(json['remainingAmount']),
      status: serializer.fromJson<String>(json['status']),
      sourceWalletId: serializer.fromJson<int>(json['sourceWalletId']),
      destinationWalletId:
          serializer.fromJson<int>(json['destinationWalletId']),
      borrowedAt: serializer.fromJson<DateTime>(json['borrowedAt']),
      targetRepaymentDate:
          serializer.fromJson<DateTime?>(json['targetRepaymentDate']),
      settledAt: serializer.fromJson<DateTime?>(json['settledAt']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'originalAmount': serializer.toJson<double>(originalAmount),
      'remainingAmount': serializer.toJson<double>(remainingAmount),
      'status': serializer.toJson<String>(status),
      'sourceWalletId': serializer.toJson<int>(sourceWalletId),
      'destinationWalletId': serializer.toJson<int>(destinationWalletId),
      'borrowedAt': serializer.toJson<DateTime>(borrowedAt),
      'targetRepaymentDate': serializer.toJson<DateTime?>(targetRepaymentDate),
      'settledAt': serializer.toJson<DateTime?>(settledAt),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InternalDebt copyWith(
          {int? id,
          String? title,
          double? originalAmount,
          double? remainingAmount,
          String? status,
          int? sourceWalletId,
          int? destinationWalletId,
          DateTime? borrowedAt,
          Value<DateTime?> targetRepaymentDate = const Value.absent(),
          Value<DateTime?> settledAt = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      InternalDebt(
        id: id ?? this.id,
        title: title ?? this.title,
        originalAmount: originalAmount ?? this.originalAmount,
        remainingAmount: remainingAmount ?? this.remainingAmount,
        status: status ?? this.status,
        sourceWalletId: sourceWalletId ?? this.sourceWalletId,
        destinationWalletId: destinationWalletId ?? this.destinationWalletId,
        borrowedAt: borrowedAt ?? this.borrowedAt,
        targetRepaymentDate: targetRepaymentDate.present
            ? targetRepaymentDate.value
            : this.targetRepaymentDate,
        settledAt: settledAt.present ? settledAt.value : this.settledAt,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  InternalDebt copyWithCompanion(InternalDebtsCompanion data) {
    return InternalDebt(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      originalAmount: data.originalAmount.present
          ? data.originalAmount.value
          : this.originalAmount,
      remainingAmount: data.remainingAmount.present
          ? data.remainingAmount.value
          : this.remainingAmount,
      status: data.status.present ? data.status.value : this.status,
      sourceWalletId: data.sourceWalletId.present
          ? data.sourceWalletId.value
          : this.sourceWalletId,
      destinationWalletId: data.destinationWalletId.present
          ? data.destinationWalletId.value
          : this.destinationWalletId,
      borrowedAt:
          data.borrowedAt.present ? data.borrowedAt.value : this.borrowedAt,
      targetRepaymentDate: data.targetRepaymentDate.present
          ? data.targetRepaymentDate.value
          : this.targetRepaymentDate,
      settledAt: data.settledAt.present ? data.settledAt.value : this.settledAt,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InternalDebt(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('status: $status, ')
          ..write('sourceWalletId: $sourceWalletId, ')
          ..write('destinationWalletId: $destinationWalletId, ')
          ..write('borrowedAt: $borrowedAt, ')
          ..write('targetRepaymentDate: $targetRepaymentDate, ')
          ..write('settledAt: $settledAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      originalAmount,
      remainingAmount,
      status,
      sourceWalletId,
      destinationWalletId,
      borrowedAt,
      targetRepaymentDate,
      settledAt,
      note,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InternalDebt &&
          other.id == this.id &&
          other.title == this.title &&
          other.originalAmount == this.originalAmount &&
          other.remainingAmount == this.remainingAmount &&
          other.status == this.status &&
          other.sourceWalletId == this.sourceWalletId &&
          other.destinationWalletId == this.destinationWalletId &&
          other.borrowedAt == this.borrowedAt &&
          other.targetRepaymentDate == this.targetRepaymentDate &&
          other.settledAt == this.settledAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class InternalDebtsCompanion extends UpdateCompanion<InternalDebt> {
  final Value<int> id;
  final Value<String> title;
  final Value<double> originalAmount;
  final Value<double> remainingAmount;
  final Value<String> status;
  final Value<int> sourceWalletId;
  final Value<int> destinationWalletId;
  final Value<DateTime> borrowedAt;
  final Value<DateTime?> targetRepaymentDate;
  final Value<DateTime?> settledAt;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const InternalDebtsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.originalAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.sourceWalletId = const Value.absent(),
    this.destinationWalletId = const Value.absent(),
    this.borrowedAt = const Value.absent(),
    this.targetRepaymentDate = const Value.absent(),
    this.settledAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InternalDebtsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required double originalAmount,
    required double remainingAmount,
    this.status = const Value.absent(),
    required int sourceWalletId,
    required int destinationWalletId,
    required DateTime borrowedAt,
    this.targetRepaymentDate = const Value.absent(),
    this.settledAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : title = Value(title),
        originalAmount = Value(originalAmount),
        remainingAmount = Value(remainingAmount),
        sourceWalletId = Value(sourceWalletId),
        destinationWalletId = Value(destinationWalletId),
        borrowedAt = Value(borrowedAt);
  static Insertable<InternalDebt> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<double>? originalAmount,
    Expression<double>? remainingAmount,
    Expression<String>? status,
    Expression<int>? sourceWalletId,
    Expression<int>? destinationWalletId,
    Expression<DateTime>? borrowedAt,
    Expression<DateTime>? targetRepaymentDate,
    Expression<DateTime>? settledAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (originalAmount != null) 'original_amount': originalAmount,
      if (remainingAmount != null) 'remaining_amount': remainingAmount,
      if (status != null) 'status': status,
      if (sourceWalletId != null) 'source_wallet_id': sourceWalletId,
      if (destinationWalletId != null)
        'destination_wallet_id': destinationWalletId,
      if (borrowedAt != null) 'borrowed_at': borrowedAt,
      if (targetRepaymentDate != null)
        'target_repayment_date': targetRepaymentDate,
      if (settledAt != null) 'settled_at': settledAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InternalDebtsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<double>? originalAmount,
      Value<double>? remainingAmount,
      Value<String>? status,
      Value<int>? sourceWalletId,
      Value<int>? destinationWalletId,
      Value<DateTime>? borrowedAt,
      Value<DateTime?>? targetRepaymentDate,
      Value<DateTime?>? settledAt,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return InternalDebtsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      originalAmount: originalAmount ?? this.originalAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      status: status ?? this.status,
      sourceWalletId: sourceWalletId ?? this.sourceWalletId,
      destinationWalletId: destinationWalletId ?? this.destinationWalletId,
      borrowedAt: borrowedAt ?? this.borrowedAt,
      targetRepaymentDate: targetRepaymentDate ?? this.targetRepaymentDate,
      settledAt: settledAt ?? this.settledAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (originalAmount.present) {
      map['original_amount'] = Variable<double>(originalAmount.value);
    }
    if (remainingAmount.present) {
      map['remaining_amount'] = Variable<double>(remainingAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sourceWalletId.present) {
      map['source_wallet_id'] = Variable<int>(sourceWalletId.value);
    }
    if (destinationWalletId.present) {
      map['destination_wallet_id'] = Variable<int>(destinationWalletId.value);
    }
    if (borrowedAt.present) {
      map['borrowed_at'] = Variable<DateTime>(borrowedAt.value);
    }
    if (targetRepaymentDate.present) {
      map['target_repayment_date'] =
          Variable<DateTime>(targetRepaymentDate.value);
    }
    if (settledAt.present) {
      map['settled_at'] = Variable<DateTime>(settledAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InternalDebtsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('status: $status, ')
          ..write('sourceWalletId: $sourceWalletId, ')
          ..write('destinationWalletId: $destinationWalletId, ')
          ..write('borrowedAt: $borrowedAt, ')
          ..write('targetRepaymentDate: $targetRepaymentDate, ')
          ..write('settledAt: $settledAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ReceivablesTable extends Receivables
    with TableInfo<$ReceivablesTable, Receivable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceivablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _borrowerNameMeta =
      const VerificationMeta('borrowerName');
  @override
  late final GeneratedColumn<String> borrowerName = GeneratedColumn<String>(
      'borrower_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _borrowerContactMeta =
      const VerificationMeta('borrowerContact');
  @override
  late final GeneratedColumn<String> borrowerContact = GeneratedColumn<String>(
      'borrower_contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originalAmountMeta =
      const VerificationMeta('originalAmount');
  @override
  late final GeneratedColumn<double> originalAmount = GeneratedColumn<double>(
      'original_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _remainingAmountMeta =
      const VerificationMeta('remainingAmount');
  @override
  late final GeneratedColumn<double> remainingAmount = GeneratedColumn<double>(
      'remaining_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _sourceWalletIdMeta =
      const VerificationMeta('sourceWalletId');
  @override
  late final GeneratedColumn<int> sourceWalletId = GeneratedColumn<int>(
      'source_wallet_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (id)'));
  static const VerificationMeta _lentAtMeta = const VerificationMeta('lentAt');
  @override
  late final GeneratedColumn<DateTime> lentAt = GeneratedColumn<DateTime>(
      'lent_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _targetReturnDateMeta =
      const VerificationMeta('targetReturnDate');
  @override
  late final GeneratedColumn<DateTime> targetReturnDate =
      GeneratedColumn<DateTime>('target_return_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _collectedAtMeta =
      const VerificationMeta('collectedAt');
  @override
  late final GeneratedColumn<DateTime> collectedAt = GeneratedColumn<DateTime>(
      'collected_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _purposeMeta =
      const VerificationMeta('purpose');
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
      'purpose', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        borrowerName,
        borrowerContact,
        originalAmount,
        remainingAmount,
        status,
        sourceWalletId,
        lentAt,
        targetReturnDate,
        collectedAt,
        purpose,
        note,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receivables';
  @override
  VerificationContext validateIntegrity(Insertable<Receivable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('borrower_name')) {
      context.handle(
          _borrowerNameMeta,
          borrowerName.isAcceptableOrUnknown(
              data['borrower_name']!, _borrowerNameMeta));
    } else if (isInserting) {
      context.missing(_borrowerNameMeta);
    }
    if (data.containsKey('borrower_contact')) {
      context.handle(
          _borrowerContactMeta,
          borrowerContact.isAcceptableOrUnknown(
              data['borrower_contact']!, _borrowerContactMeta));
    }
    if (data.containsKey('original_amount')) {
      context.handle(
          _originalAmountMeta,
          originalAmount.isAcceptableOrUnknown(
              data['original_amount']!, _originalAmountMeta));
    } else if (isInserting) {
      context.missing(_originalAmountMeta);
    }
    if (data.containsKey('remaining_amount')) {
      context.handle(
          _remainingAmountMeta,
          remainingAmount.isAcceptableOrUnknown(
              data['remaining_amount']!, _remainingAmountMeta));
    } else if (isInserting) {
      context.missing(_remainingAmountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('source_wallet_id')) {
      context.handle(
          _sourceWalletIdMeta,
          sourceWalletId.isAcceptableOrUnknown(
              data['source_wallet_id']!, _sourceWalletIdMeta));
    } else if (isInserting) {
      context.missing(_sourceWalletIdMeta);
    }
    if (data.containsKey('lent_at')) {
      context.handle(_lentAtMeta,
          lentAt.isAcceptableOrUnknown(data['lent_at']!, _lentAtMeta));
    } else if (isInserting) {
      context.missing(_lentAtMeta);
    }
    if (data.containsKey('target_return_date')) {
      context.handle(
          _targetReturnDateMeta,
          targetReturnDate.isAcceptableOrUnknown(
              data['target_return_date']!, _targetReturnDateMeta));
    }
    if (data.containsKey('collected_at')) {
      context.handle(
          _collectedAtMeta,
          collectedAt.isAcceptableOrUnknown(
              data['collected_at']!, _collectedAtMeta));
    }
    if (data.containsKey('purpose')) {
      context.handle(_purposeMeta,
          purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Receivable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receivable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      borrowerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}borrower_name'])!,
      borrowerContact: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}borrower_contact']),
      originalAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}original_amount'])!,
      remainingAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}remaining_amount'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      sourceWalletId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_wallet_id'])!,
      lentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}lent_at'])!,
      targetReturnDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}target_return_date']),
      collectedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}collected_at']),
      purpose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purpose']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReceivablesTable createAlias(String alias) {
    return $ReceivablesTable(attachedDatabase, alias);
  }
}

class Receivable extends DataClass implements Insertable<Receivable> {
  final int id;
  final String borrowerName;
  final String? borrowerContact;
  final double originalAmount;
  final double remainingAmount;
  final String status;
  final int sourceWalletId;
  final DateTime lentAt;
  final DateTime? targetReturnDate;
  final DateTime? collectedAt;
  final String? purpose;
  final String? note;
  final DateTime createdAt;
  const Receivable(
      {required this.id,
      required this.borrowerName,
      this.borrowerContact,
      required this.originalAmount,
      required this.remainingAmount,
      required this.status,
      required this.sourceWalletId,
      required this.lentAt,
      this.targetReturnDate,
      this.collectedAt,
      this.purpose,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['borrower_name'] = Variable<String>(borrowerName);
    if (!nullToAbsent || borrowerContact != null) {
      map['borrower_contact'] = Variable<String>(borrowerContact);
    }
    map['original_amount'] = Variable<double>(originalAmount);
    map['remaining_amount'] = Variable<double>(remainingAmount);
    map['status'] = Variable<String>(status);
    map['source_wallet_id'] = Variable<int>(sourceWalletId);
    map['lent_at'] = Variable<DateTime>(lentAt);
    if (!nullToAbsent || targetReturnDate != null) {
      map['target_return_date'] = Variable<DateTime>(targetReturnDate);
    }
    if (!nullToAbsent || collectedAt != null) {
      map['collected_at'] = Variable<DateTime>(collectedAt);
    }
    if (!nullToAbsent || purpose != null) {
      map['purpose'] = Variable<String>(purpose);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReceivablesCompanion toCompanion(bool nullToAbsent) {
    return ReceivablesCompanion(
      id: Value(id),
      borrowerName: Value(borrowerName),
      borrowerContact: borrowerContact == null && nullToAbsent
          ? const Value.absent()
          : Value(borrowerContact),
      originalAmount: Value(originalAmount),
      remainingAmount: Value(remainingAmount),
      status: Value(status),
      sourceWalletId: Value(sourceWalletId),
      lentAt: Value(lentAt),
      targetReturnDate: targetReturnDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetReturnDate),
      collectedAt: collectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(collectedAt),
      purpose: purpose == null && nullToAbsent
          ? const Value.absent()
          : Value(purpose),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Receivable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receivable(
      id: serializer.fromJson<int>(json['id']),
      borrowerName: serializer.fromJson<String>(json['borrowerName']),
      borrowerContact: serializer.fromJson<String?>(json['borrowerContact']),
      originalAmount: serializer.fromJson<double>(json['originalAmount']),
      remainingAmount: serializer.fromJson<double>(json['remainingAmount']),
      status: serializer.fromJson<String>(json['status']),
      sourceWalletId: serializer.fromJson<int>(json['sourceWalletId']),
      lentAt: serializer.fromJson<DateTime>(json['lentAt']),
      targetReturnDate:
          serializer.fromJson<DateTime?>(json['targetReturnDate']),
      collectedAt: serializer.fromJson<DateTime?>(json['collectedAt']),
      purpose: serializer.fromJson<String?>(json['purpose']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'borrowerName': serializer.toJson<String>(borrowerName),
      'borrowerContact': serializer.toJson<String?>(borrowerContact),
      'originalAmount': serializer.toJson<double>(originalAmount),
      'remainingAmount': serializer.toJson<double>(remainingAmount),
      'status': serializer.toJson<String>(status),
      'sourceWalletId': serializer.toJson<int>(sourceWalletId),
      'lentAt': serializer.toJson<DateTime>(lentAt),
      'targetReturnDate': serializer.toJson<DateTime?>(targetReturnDate),
      'collectedAt': serializer.toJson<DateTime?>(collectedAt),
      'purpose': serializer.toJson<String?>(purpose),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Receivable copyWith(
          {int? id,
          String? borrowerName,
          Value<String?> borrowerContact = const Value.absent(),
          double? originalAmount,
          double? remainingAmount,
          String? status,
          int? sourceWalletId,
          DateTime? lentAt,
          Value<DateTime?> targetReturnDate = const Value.absent(),
          Value<DateTime?> collectedAt = const Value.absent(),
          Value<String?> purpose = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      Receivable(
        id: id ?? this.id,
        borrowerName: borrowerName ?? this.borrowerName,
        borrowerContact: borrowerContact.present
            ? borrowerContact.value
            : this.borrowerContact,
        originalAmount: originalAmount ?? this.originalAmount,
        remainingAmount: remainingAmount ?? this.remainingAmount,
        status: status ?? this.status,
        sourceWalletId: sourceWalletId ?? this.sourceWalletId,
        lentAt: lentAt ?? this.lentAt,
        targetReturnDate: targetReturnDate.present
            ? targetReturnDate.value
            : this.targetReturnDate,
        collectedAt: collectedAt.present ? collectedAt.value : this.collectedAt,
        purpose: purpose.present ? purpose.value : this.purpose,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  Receivable copyWithCompanion(ReceivablesCompanion data) {
    return Receivable(
      id: data.id.present ? data.id.value : this.id,
      borrowerName: data.borrowerName.present
          ? data.borrowerName.value
          : this.borrowerName,
      borrowerContact: data.borrowerContact.present
          ? data.borrowerContact.value
          : this.borrowerContact,
      originalAmount: data.originalAmount.present
          ? data.originalAmount.value
          : this.originalAmount,
      remainingAmount: data.remainingAmount.present
          ? data.remainingAmount.value
          : this.remainingAmount,
      status: data.status.present ? data.status.value : this.status,
      sourceWalletId: data.sourceWalletId.present
          ? data.sourceWalletId.value
          : this.sourceWalletId,
      lentAt: data.lentAt.present ? data.lentAt.value : this.lentAt,
      targetReturnDate: data.targetReturnDate.present
          ? data.targetReturnDate.value
          : this.targetReturnDate,
      collectedAt:
          data.collectedAt.present ? data.collectedAt.value : this.collectedAt,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receivable(')
          ..write('id: $id, ')
          ..write('borrowerName: $borrowerName, ')
          ..write('borrowerContact: $borrowerContact, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('status: $status, ')
          ..write('sourceWalletId: $sourceWalletId, ')
          ..write('lentAt: $lentAt, ')
          ..write('targetReturnDate: $targetReturnDate, ')
          ..write('collectedAt: $collectedAt, ')
          ..write('purpose: $purpose, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      borrowerName,
      borrowerContact,
      originalAmount,
      remainingAmount,
      status,
      sourceWalletId,
      lentAt,
      targetReturnDate,
      collectedAt,
      purpose,
      note,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receivable &&
          other.id == this.id &&
          other.borrowerName == this.borrowerName &&
          other.borrowerContact == this.borrowerContact &&
          other.originalAmount == this.originalAmount &&
          other.remainingAmount == this.remainingAmount &&
          other.status == this.status &&
          other.sourceWalletId == this.sourceWalletId &&
          other.lentAt == this.lentAt &&
          other.targetReturnDate == this.targetReturnDate &&
          other.collectedAt == this.collectedAt &&
          other.purpose == this.purpose &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class ReceivablesCompanion extends UpdateCompanion<Receivable> {
  final Value<int> id;
  final Value<String> borrowerName;
  final Value<String?> borrowerContact;
  final Value<double> originalAmount;
  final Value<double> remainingAmount;
  final Value<String> status;
  final Value<int> sourceWalletId;
  final Value<DateTime> lentAt;
  final Value<DateTime?> targetReturnDate;
  final Value<DateTime?> collectedAt;
  final Value<String?> purpose;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const ReceivablesCompanion({
    this.id = const Value.absent(),
    this.borrowerName = const Value.absent(),
    this.borrowerContact = const Value.absent(),
    this.originalAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.sourceWalletId = const Value.absent(),
    this.lentAt = const Value.absent(),
    this.targetReturnDate = const Value.absent(),
    this.collectedAt = const Value.absent(),
    this.purpose = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReceivablesCompanion.insert({
    this.id = const Value.absent(),
    required String borrowerName,
    this.borrowerContact = const Value.absent(),
    required double originalAmount,
    required double remainingAmount,
    this.status = const Value.absent(),
    required int sourceWalletId,
    required DateTime lentAt,
    this.targetReturnDate = const Value.absent(),
    this.collectedAt = const Value.absent(),
    this.purpose = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : borrowerName = Value(borrowerName),
        originalAmount = Value(originalAmount),
        remainingAmount = Value(remainingAmount),
        sourceWalletId = Value(sourceWalletId),
        lentAt = Value(lentAt);
  static Insertable<Receivable> custom({
    Expression<int>? id,
    Expression<String>? borrowerName,
    Expression<String>? borrowerContact,
    Expression<double>? originalAmount,
    Expression<double>? remainingAmount,
    Expression<String>? status,
    Expression<int>? sourceWalletId,
    Expression<DateTime>? lentAt,
    Expression<DateTime>? targetReturnDate,
    Expression<DateTime>? collectedAt,
    Expression<String>? purpose,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (borrowerName != null) 'borrower_name': borrowerName,
      if (borrowerContact != null) 'borrower_contact': borrowerContact,
      if (originalAmount != null) 'original_amount': originalAmount,
      if (remainingAmount != null) 'remaining_amount': remainingAmount,
      if (status != null) 'status': status,
      if (sourceWalletId != null) 'source_wallet_id': sourceWalletId,
      if (lentAt != null) 'lent_at': lentAt,
      if (targetReturnDate != null) 'target_return_date': targetReturnDate,
      if (collectedAt != null) 'collected_at': collectedAt,
      if (purpose != null) 'purpose': purpose,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReceivablesCompanion copyWith(
      {Value<int>? id,
      Value<String>? borrowerName,
      Value<String?>? borrowerContact,
      Value<double>? originalAmount,
      Value<double>? remainingAmount,
      Value<String>? status,
      Value<int>? sourceWalletId,
      Value<DateTime>? lentAt,
      Value<DateTime?>? targetReturnDate,
      Value<DateTime?>? collectedAt,
      Value<String?>? purpose,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return ReceivablesCompanion(
      id: id ?? this.id,
      borrowerName: borrowerName ?? this.borrowerName,
      borrowerContact: borrowerContact ?? this.borrowerContact,
      originalAmount: originalAmount ?? this.originalAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      status: status ?? this.status,
      sourceWalletId: sourceWalletId ?? this.sourceWalletId,
      lentAt: lentAt ?? this.lentAt,
      targetReturnDate: targetReturnDate ?? this.targetReturnDate,
      collectedAt: collectedAt ?? this.collectedAt,
      purpose: purpose ?? this.purpose,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (borrowerName.present) {
      map['borrower_name'] = Variable<String>(borrowerName.value);
    }
    if (borrowerContact.present) {
      map['borrower_contact'] = Variable<String>(borrowerContact.value);
    }
    if (originalAmount.present) {
      map['original_amount'] = Variable<double>(originalAmount.value);
    }
    if (remainingAmount.present) {
      map['remaining_amount'] = Variable<double>(remainingAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sourceWalletId.present) {
      map['source_wallet_id'] = Variable<int>(sourceWalletId.value);
    }
    if (lentAt.present) {
      map['lent_at'] = Variable<DateTime>(lentAt.value);
    }
    if (targetReturnDate.present) {
      map['target_return_date'] = Variable<DateTime>(targetReturnDate.value);
    }
    if (collectedAt.present) {
      map['collected_at'] = Variable<DateTime>(collectedAt.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceivablesCompanion(')
          ..write('id: $id, ')
          ..write('borrowerName: $borrowerName, ')
          ..write('borrowerContact: $borrowerContact, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('status: $status, ')
          ..write('sourceWalletId: $sourceWalletId, ')
          ..write('lentAt: $lentAt, ')
          ..write('targetReturnDate: $targetReturnDate, ')
          ..write('collectedAt: $collectedAt, ')
          ..write('purpose: $purpose, ')
          ..write('note: $note, ')
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
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receiptImagePathMeta =
      const VerificationMeta('receiptImagePath');
  @override
  late final GeneratedColumn<String> receiptImagePath = GeneratedColumn<String>(
      'receipt_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceWalletIdMeta =
      const VerificationMeta('sourceWalletId');
  @override
  late final GeneratedColumn<int> sourceWalletId = GeneratedColumn<int>(
      'source_wallet_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (id)'));
  static const VerificationMeta _destinationWalletIdMeta =
      const VerificationMeta('destinationWalletId');
  @override
  late final GeneratedColumn<int> destinationWalletId = GeneratedColumn<int>(
      'destination_wallet_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES wallets (id)'));
  static const VerificationMeta _relatedInternalDebtIdMeta =
      const VerificationMeta('relatedInternalDebtId');
  @override
  late final GeneratedColumn<int> relatedInternalDebtId = GeneratedColumn<int>(
      'related_internal_debt_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES internal_debts (id)'));
  static const VerificationMeta _relatedReceivableIdMeta =
      const VerificationMeta('relatedReceivableId');
  @override
  late final GeneratedColumn<int> relatedReceivableId = GeneratedColumn<int>(
      'related_receivable_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES receivables (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        type,
        category,
        amount,
        description,
        date,
        note,
        receiptImagePath,
        sourceWalletId,
        destinationWalletId,
        relatedInternalDebtId,
        relatedReceivableId,
        createdAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('receipt_image_path')) {
      context.handle(
          _receiptImagePathMeta,
          receiptImagePath.isAcceptableOrUnknown(
              data['receipt_image_path']!, _receiptImagePathMeta));
    }
    if (data.containsKey('source_wallet_id')) {
      context.handle(
          _sourceWalletIdMeta,
          sourceWalletId.isAcceptableOrUnknown(
              data['source_wallet_id']!, _sourceWalletIdMeta));
    }
    if (data.containsKey('destination_wallet_id')) {
      context.handle(
          _destinationWalletIdMeta,
          destinationWalletId.isAcceptableOrUnknown(
              data['destination_wallet_id']!, _destinationWalletIdMeta));
    }
    if (data.containsKey('related_internal_debt_id')) {
      context.handle(
          _relatedInternalDebtIdMeta,
          relatedInternalDebtId.isAcceptableOrUnknown(
              data['related_internal_debt_id']!, _relatedInternalDebtIdMeta));
    }
    if (data.containsKey('related_receivable_id')) {
      context.handle(
          _relatedReceivableIdMeta,
          relatedReceivableId.isAcceptableOrUnknown(
              data['related_receivable_id']!, _relatedReceivableIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      receiptImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}receipt_image_path']),
      sourceWalletId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_wallet_id']),
      destinationWalletId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}destination_wallet_id']),
      relatedInternalDebtId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}related_internal_debt_id']),
      relatedReceivableId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}related_receivable_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String uuid;
  final String type;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final String? note;
  final String? receiptImagePath;

  /// Sumber dana
  final int? sourceWalletId;

  /// Tujuan dana (untuk transfer)
  final int? destinationWalletId;
  final int? relatedInternalDebtId;
  final int? relatedReceivableId;
  final DateTime createdAt;
  final bool isDeleted;
  const Transaction(
      {required this.id,
      required this.uuid,
      required this.type,
      required this.category,
      required this.amount,
      required this.description,
      required this.date,
      this.note,
      this.receiptImagePath,
      this.sourceWalletId,
      this.destinationWalletId,
      this.relatedInternalDebtId,
      this.relatedReceivableId,
      required this.createdAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || receiptImagePath != null) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath);
    }
    if (!nullToAbsent || sourceWalletId != null) {
      map['source_wallet_id'] = Variable<int>(sourceWalletId);
    }
    if (!nullToAbsent || destinationWalletId != null) {
      map['destination_wallet_id'] = Variable<int>(destinationWalletId);
    }
    if (!nullToAbsent || relatedInternalDebtId != null) {
      map['related_internal_debt_id'] = Variable<int>(relatedInternalDebtId);
    }
    if (!nullToAbsent || relatedReceivableId != null) {
      map['related_receivable_id'] = Variable<int>(relatedReceivableId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      type: Value(type),
      category: Value(category),
      amount: Value(amount),
      description: Value(description),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      receiptImagePath: receiptImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptImagePath),
      sourceWalletId: sourceWalletId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceWalletId),
      destinationWalletId: destinationWalletId == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationWalletId),
      relatedInternalDebtId: relatedInternalDebtId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedInternalDebtId),
      relatedReceivableId: relatedReceivableId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedReceivableId),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      receiptImagePath: serializer.fromJson<String?>(json['receiptImagePath']),
      sourceWalletId: serializer.fromJson<int?>(json['sourceWalletId']),
      destinationWalletId:
          serializer.fromJson<int?>(json['destinationWalletId']),
      relatedInternalDebtId:
          serializer.fromJson<int?>(json['relatedInternalDebtId']),
      relatedReceivableId:
          serializer.fromJson<int?>(json['relatedReceivableId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'receiptImagePath': serializer.toJson<String?>(receiptImagePath),
      'sourceWalletId': serializer.toJson<int?>(sourceWalletId),
      'destinationWalletId': serializer.toJson<int?>(destinationWalletId),
      'relatedInternalDebtId': serializer.toJson<int?>(relatedInternalDebtId),
      'relatedReceivableId': serializer.toJson<int?>(relatedReceivableId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Transaction copyWith(
          {int? id,
          String? uuid,
          String? type,
          String? category,
          double? amount,
          String? description,
          DateTime? date,
          Value<String?> note = const Value.absent(),
          Value<String?> receiptImagePath = const Value.absent(),
          Value<int?> sourceWalletId = const Value.absent(),
          Value<int?> destinationWalletId = const Value.absent(),
          Value<int?> relatedInternalDebtId = const Value.absent(),
          Value<int?> relatedReceivableId = const Value.absent(),
          DateTime? createdAt,
          bool? isDeleted}) =>
      Transaction(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        type: type ?? this.type,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        date: date ?? this.date,
        note: note.present ? note.value : this.note,
        receiptImagePath: receiptImagePath.present
            ? receiptImagePath.value
            : this.receiptImagePath,
        sourceWalletId:
            sourceWalletId.present ? sourceWalletId.value : this.sourceWalletId,
        destinationWalletId: destinationWalletId.present
            ? destinationWalletId.value
            : this.destinationWalletId,
        relatedInternalDebtId: relatedInternalDebtId.present
            ? relatedInternalDebtId.value
            : this.relatedInternalDebtId,
        relatedReceivableId: relatedReceivableId.present
            ? relatedReceivableId.value
            : this.relatedReceivableId,
        createdAt: createdAt ?? this.createdAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      description:
          data.description.present ? data.description.value : this.description,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      receiptImagePath: data.receiptImagePath.present
          ? data.receiptImagePath.value
          : this.receiptImagePath,
      sourceWalletId: data.sourceWalletId.present
          ? data.sourceWalletId.value
          : this.sourceWalletId,
      destinationWalletId: data.destinationWalletId.present
          ? data.destinationWalletId.value
          : this.destinationWalletId,
      relatedInternalDebtId: data.relatedInternalDebtId.present
          ? data.relatedInternalDebtId.value
          : this.relatedInternalDebtId,
      relatedReceivableId: data.relatedReceivableId.present
          ? data.relatedReceivableId.value
          : this.relatedReceivableId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('sourceWalletId: $sourceWalletId, ')
          ..write('destinationWalletId: $destinationWalletId, ')
          ..write('relatedInternalDebtId: $relatedInternalDebtId, ')
          ..write('relatedReceivableId: $relatedReceivableId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      type,
      category,
      amount,
      description,
      date,
      note,
      receiptImagePath,
      sourceWalletId,
      destinationWalletId,
      relatedInternalDebtId,
      relatedReceivableId,
      createdAt,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.type == this.type &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.date == this.date &&
          other.note == this.note &&
          other.receiptImagePath == this.receiptImagePath &&
          other.sourceWalletId == this.sourceWalletId &&
          other.destinationWalletId == this.destinationWalletId &&
          other.relatedInternalDebtId == this.relatedInternalDebtId &&
          other.relatedReceivableId == this.relatedReceivableId &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> type;
  final Value<String> category;
  final Value<double> amount;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String?> receiptImagePath;
  final Value<int?> sourceWalletId;
  final Value<int?> destinationWalletId;
  final Value<int?> relatedInternalDebtId;
  final Value<int?> relatedReceivableId;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
    this.sourceWalletId = const Value.absent(),
    this.destinationWalletId = const Value.absent(),
    this.relatedInternalDebtId = const Value.absent(),
    this.relatedReceivableId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String type,
    required String category,
    required double amount,
    required String description,
    required DateTime date,
    this.note = const Value.absent(),
    this.receiptImagePath = const Value.absent(),
    this.sourceWalletId = const Value.absent(),
    this.destinationWalletId = const Value.absent(),
    this.relatedInternalDebtId = const Value.absent(),
    this.relatedReceivableId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : uuid = Value(uuid),
        type = Value(type),
        category = Value(category),
        amount = Value(amount),
        description = Value(description),
        date = Value(date);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? type,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? receiptImagePath,
    Expression<int>? sourceWalletId,
    Expression<int>? destinationWalletId,
    Expression<int>? relatedInternalDebtId,
    Expression<int>? relatedReceivableId,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (receiptImagePath != null) 'receipt_image_path': receiptImagePath,
      if (sourceWalletId != null) 'source_wallet_id': sourceWalletId,
      if (destinationWalletId != null)
        'destination_wallet_id': destinationWalletId,
      if (relatedInternalDebtId != null)
        'related_internal_debt_id': relatedInternalDebtId,
      if (relatedReceivableId != null)
        'related_receivable_id': relatedReceivableId,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? type,
      Value<String>? category,
      Value<double>? amount,
      Value<String>? description,
      Value<DateTime>? date,
      Value<String?>? note,
      Value<String?>? receiptImagePath,
      Value<int?>? sourceWalletId,
      Value<int?>? destinationWalletId,
      Value<int?>? relatedInternalDebtId,
      Value<int?>? relatedReceivableId,
      Value<DateTime>? createdAt,
      Value<bool>? isDeleted}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      note: note ?? this.note,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      sourceWalletId: sourceWalletId ?? this.sourceWalletId,
      destinationWalletId: destinationWalletId ?? this.destinationWalletId,
      relatedInternalDebtId:
          relatedInternalDebtId ?? this.relatedInternalDebtId,
      relatedReceivableId: relatedReceivableId ?? this.relatedReceivableId,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (receiptImagePath.present) {
      map['receipt_image_path'] = Variable<String>(receiptImagePath.value);
    }
    if (sourceWalletId.present) {
      map['source_wallet_id'] = Variable<int>(sourceWalletId.value);
    }
    if (destinationWalletId.present) {
      map['destination_wallet_id'] = Variable<int>(destinationWalletId.value);
    }
    if (relatedInternalDebtId.present) {
      map['related_internal_debt_id'] =
          Variable<int>(relatedInternalDebtId.value);
    }
    if (relatedReceivableId.present) {
      map['related_receivable_id'] = Variable<int>(relatedReceivableId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('receiptImagePath: $receiptImagePath, ')
          ..write('sourceWalletId: $sourceWalletId, ')
          ..write('destinationWalletId: $destinationWalletId, ')
          ..write('relatedInternalDebtId: $relatedInternalDebtId, ')
          ..write('relatedReceivableId: $relatedReceivableId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $InternalDebtsTable internalDebts = $InternalDebtsTable(this);
  late final $ReceivablesTable receivables = $ReceivablesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [wallets, internalDebts, receivables, transactions];
}

typedef $$WalletsTableCreateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> category,
  Value<double> balance,
  Value<String> currency,
  Value<String?> iconCode,
  Value<String?> colorCode,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isActive,
});
typedef $$WalletsTableUpdateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
  Value<double> balance,
  Value<String> currency,
  Value<String?> iconCode,
  Value<String?> colorCode,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isActive,
});

final class $$WalletsTableReferences
    extends BaseReferences<_$AppDatabase, $WalletsTable, Wallet> {
  $$WalletsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InternalDebtsTable, List<InternalDebt>>
      _internalDebtsAsSourceTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.internalDebts,
              aliasName: $_aliasNameGenerator(
                  db.wallets.id, db.internalDebts.sourceWalletId));

  $$InternalDebtsTableProcessedTableManager get internalDebtsAsSource {
    final manager = $$InternalDebtsTableTableManager($_db, $_db.internalDebts)
        .filter((f) => f.sourceWalletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_internalDebtsAsSourceTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InternalDebtsTable, List<InternalDebt>>
      _internalDebtsAsDestinationTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.internalDebts,
              aliasName: $_aliasNameGenerator(
                  db.wallets.id, db.internalDebts.destinationWalletId));

  $$InternalDebtsTableProcessedTableManager get internalDebtsAsDestination {
    final manager = $$InternalDebtsTableTableManager($_db, $_db.internalDebts)
        .filter((f) =>
            f.destinationWalletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_internalDebtsAsDestinationTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReceivablesTable, List<Receivable>>
      _receivablesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.receivables,
              aliasName: $_aliasNameGenerator(
                  db.wallets.id, db.receivables.sourceWalletId));

  $$ReceivablesTableProcessedTableManager get receivablesRefs {
    final manager = $$ReceivablesTableTableManager($_db, $_db.receivables)
        .filter((f) => f.sourceWalletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_receivablesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsAsSourceTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.wallets.id, db.transactions.sourceWalletId));

  $$TransactionsTableProcessedTableManager get transactionsAsSource {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.sourceWalletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionsAsSourceTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsAsDestinationTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.wallets.id, db.transactions.destinationWalletId));

  $$TransactionsTableProcessedTableManager get transactionsAsDestination {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) =>
            f.destinationWalletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionsAsDestinationTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WalletsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconCode => $composableBuilder(
      column: $table.iconCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorCode => $composableBuilder(
      column: $table.colorCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> internalDebtsAsSource(
      Expression<bool> Function($$InternalDebtsTableFilterComposer f) f) {
    final $$InternalDebtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.internalDebts,
        getReferencedColumn: (t) => t.sourceWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InternalDebtsTableFilterComposer(
              $db: $db,
              $table: $db.internalDebts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> internalDebtsAsDestination(
      Expression<bool> Function($$InternalDebtsTableFilterComposer f) f) {
    final $$InternalDebtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.internalDebts,
        getReferencedColumn: (t) => t.destinationWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InternalDebtsTableFilterComposer(
              $db: $db,
              $table: $db.internalDebts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> receivablesRefs(
      Expression<bool> Function($$ReceivablesTableFilterComposer f) f) {
    final $$ReceivablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.receivables,
        getReferencedColumn: (t) => t.sourceWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceivablesTableFilterComposer(
              $db: $db,
              $table: $db.receivables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionsAsSource(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.sourceWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionsAsDestination(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.destinationWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconCode => $composableBuilder(
      column: $table.iconCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorCode => $composableBuilder(
      column: $table.colorCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get iconCode =>
      $composableBuilder(column: $table.iconCode, builder: (column) => column);

  GeneratedColumn<String> get colorCode =>
      $composableBuilder(column: $table.colorCode, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> internalDebtsAsSource<T extends Object>(
      Expression<T> Function($$InternalDebtsTableAnnotationComposer a) f) {
    final $$InternalDebtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.internalDebts,
        getReferencedColumn: (t) => t.sourceWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InternalDebtsTableAnnotationComposer(
              $db: $db,
              $table: $db.internalDebts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> internalDebtsAsDestination<T extends Object>(
      Expression<T> Function($$InternalDebtsTableAnnotationComposer a) f) {
    final $$InternalDebtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.internalDebts,
        getReferencedColumn: (t) => t.destinationWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InternalDebtsTableAnnotationComposer(
              $db: $db,
              $table: $db.internalDebts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> receivablesRefs<T extends Object>(
      Expression<T> Function($$ReceivablesTableAnnotationComposer a) f) {
    final $$ReceivablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.receivables,
        getReferencedColumn: (t) => t.sourceWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceivablesTableAnnotationComposer(
              $db: $db,
              $table: $db.receivables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionsAsSource<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.sourceWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionsAsDestination<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.destinationWalletId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WalletsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WalletsTable,
    Wallet,
    $$WalletsTableFilterComposer,
    $$WalletsTableOrderingComposer,
    $$WalletsTableAnnotationComposer,
    $$WalletsTableCreateCompanionBuilder,
    $$WalletsTableUpdateCompanionBuilder,
    (Wallet, $$WalletsTableReferences),
    Wallet,
    PrefetchHooks Function(
        {bool internalDebtsAsSource,
        bool internalDebtsAsDestination,
        bool receivablesRefs,
        bool transactionsAsSource,
        bool transactionsAsDestination})> {
  $$WalletsTableTableManager(_$AppDatabase db, $WalletsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> iconCode = const Value.absent(),
            Value<String?> colorCode = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              WalletsCompanion(
            id: id,
            name: name,
            category: category,
            balance: balance,
            currency: currency,
            iconCode: iconCode,
            colorCode: colorCode,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> category = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> iconCode = const Value.absent(),
            Value<String?> colorCode = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              WalletsCompanion.insert(
            id: id,
            name: name,
            category: category,
            balance: balance,
            currency: currency,
            iconCode: iconCode,
            colorCode: colorCode,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$WalletsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {internalDebtsAsSource = false,
              internalDebtsAsDestination = false,
              receivablesRefs = false,
              transactionsAsSource = false,
              transactionsAsDestination = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (internalDebtsAsSource) db.internalDebts,
                if (internalDebtsAsDestination) db.internalDebts,
                if (receivablesRefs) db.receivables,
                if (transactionsAsSource) db.transactions,
                if (transactionsAsDestination) db.transactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (internalDebtsAsSource)
                    await $_getPrefetchedData<Wallet, $WalletsTable,
                            InternalDebt>(
                        currentTable: table,
                        referencedTable: $$WalletsTableReferences
                            ._internalDebtsAsSourceTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletsTableReferences(db, table, p0)
                                .internalDebtsAsSource,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sourceWalletId == item.id),
                        typedResults: items),
                  if (internalDebtsAsDestination)
                    await $_getPrefetchedData<Wallet, $WalletsTable,
                            InternalDebt>(
                        currentTable: table,
                        referencedTable: $$WalletsTableReferences
                            ._internalDebtsAsDestinationTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletsTableReferences(db, table, p0)
                                .internalDebtsAsDestination,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.destinationWalletId == item.id),
                        typedResults: items),
                  if (receivablesRefs)
                    await $_getPrefetchedData<Wallet, $WalletsTable,
                            Receivable>(
                        currentTable: table,
                        referencedTable:
                            $$WalletsTableReferences._receivablesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletsTableReferences(db, table, p0)
                                .receivablesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sourceWalletId == item.id),
                        typedResults: items),
                  if (transactionsAsSource)
                    await $_getPrefetchedData<Wallet, $WalletsTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$WalletsTableReferences
                            ._transactionsAsSourceTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletsTableReferences(db, table, p0)
                                .transactionsAsSource,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sourceWalletId == item.id),
                        typedResults: items),
                  if (transactionsAsDestination)
                    await $_getPrefetchedData<Wallet, $WalletsTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$WalletsTableReferences
                            ._transactionsAsDestinationTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WalletsTableReferences(db, table, p0)
                                .transactionsAsDestination,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.destinationWalletId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WalletsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WalletsTable,
    Wallet,
    $$WalletsTableFilterComposer,
    $$WalletsTableOrderingComposer,
    $$WalletsTableAnnotationComposer,
    $$WalletsTableCreateCompanionBuilder,
    $$WalletsTableUpdateCompanionBuilder,
    (Wallet, $$WalletsTableReferences),
    Wallet,
    PrefetchHooks Function(
        {bool internalDebtsAsSource,
        bool internalDebtsAsDestination,
        bool receivablesRefs,
        bool transactionsAsSource,
        bool transactionsAsDestination})>;
typedef $$InternalDebtsTableCreateCompanionBuilder = InternalDebtsCompanion
    Function({
  Value<int> id,
  required String title,
  required double originalAmount,
  required double remainingAmount,
  Value<String> status,
  required int sourceWalletId,
  required int destinationWalletId,
  required DateTime borrowedAt,
  Value<DateTime?> targetRepaymentDate,
  Value<DateTime?> settledAt,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$InternalDebtsTableUpdateCompanionBuilder = InternalDebtsCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<double> originalAmount,
  Value<double> remainingAmount,
  Value<String> status,
  Value<int> sourceWalletId,
  Value<int> destinationWalletId,
  Value<DateTime> borrowedAt,
  Value<DateTime?> targetRepaymentDate,
  Value<DateTime?> settledAt,
  Value<String?> note,
  Value<DateTime> createdAt,
});

final class $$InternalDebtsTableReferences
    extends BaseReferences<_$AppDatabase, $InternalDebtsTable, InternalDebt> {
  $$InternalDebtsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WalletsTable _sourceWalletIdTable(_$AppDatabase db) =>
      db.wallets.createAlias(
          $_aliasNameGenerator(db.internalDebts.sourceWalletId, db.wallets.id));

  $$WalletsTableProcessedTableManager get sourceWalletId {
    final $_column = $_itemColumn<int>('source_wallet_id')!;

    final manager = $$WalletsTableTableManager($_db, $_db.wallets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceWalletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WalletsTable _destinationWalletIdTable(_$AppDatabase db) =>
      db.wallets.createAlias($_aliasNameGenerator(
          db.internalDebts.destinationWalletId, db.wallets.id));

  $$WalletsTableProcessedTableManager get destinationWalletId {
    final $_column = $_itemColumn<int>('destination_wallet_id')!;

    final manager = $$WalletsTableTableManager($_db, $_db.wallets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_destinationWalletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsForDebtTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.internalDebts.id, db.transactions.relatedInternalDebtId));

  $$TransactionsTableProcessedTableManager get transactionsForDebt {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) =>
            f.relatedInternalDebtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionsForDebtTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InternalDebtsTableFilterComposer
    extends Composer<_$AppDatabase, $InternalDebtsTable> {
  $$InternalDebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originalAmount => $composableBuilder(
      column: $table.originalAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get borrowedAt => $composableBuilder(
      column: $table.borrowedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetRepaymentDate => $composableBuilder(
      column: $table.targetRepaymentDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get settledAt => $composableBuilder(
      column: $table.settledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$WalletsTableFilterComposer get sourceWalletId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableFilterComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableFilterComposer get destinationWalletId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableFilterComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsForDebt(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.relatedInternalDebtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InternalDebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $InternalDebtsTable> {
  $$InternalDebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originalAmount => $composableBuilder(
      column: $table.originalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get borrowedAt => $composableBuilder(
      column: $table.borrowedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetRepaymentDate => $composableBuilder(
      column: $table.targetRepaymentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get settledAt => $composableBuilder(
      column: $table.settledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$WalletsTableOrderingComposer get sourceWalletId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableOrderingComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableOrderingComposer get destinationWalletId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableOrderingComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InternalDebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InternalDebtsTable> {
  $$InternalDebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get originalAmount => $composableBuilder(
      column: $table.originalAmount, builder: (column) => column);

  GeneratedColumn<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get borrowedAt => $composableBuilder(
      column: $table.borrowedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get targetRepaymentDate => $composableBuilder(
      column: $table.targetRepaymentDate, builder: (column) => column);

  GeneratedColumn<DateTime> get settledAt =>
      $composableBuilder(column: $table.settledAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WalletsTableAnnotationComposer get sourceWalletId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableAnnotationComposer get destinationWalletId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsForDebt<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.relatedInternalDebtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InternalDebtsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InternalDebtsTable,
    InternalDebt,
    $$InternalDebtsTableFilterComposer,
    $$InternalDebtsTableOrderingComposer,
    $$InternalDebtsTableAnnotationComposer,
    $$InternalDebtsTableCreateCompanionBuilder,
    $$InternalDebtsTableUpdateCompanionBuilder,
    (InternalDebt, $$InternalDebtsTableReferences),
    InternalDebt,
    PrefetchHooks Function(
        {bool sourceWalletId,
        bool destinationWalletId,
        bool transactionsForDebt})> {
  $$InternalDebtsTableTableManager(_$AppDatabase db, $InternalDebtsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InternalDebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InternalDebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InternalDebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> originalAmount = const Value.absent(),
            Value<double> remainingAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> sourceWalletId = const Value.absent(),
            Value<int> destinationWalletId = const Value.absent(),
            Value<DateTime> borrowedAt = const Value.absent(),
            Value<DateTime?> targetRepaymentDate = const Value.absent(),
            Value<DateTime?> settledAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              InternalDebtsCompanion(
            id: id,
            title: title,
            originalAmount: originalAmount,
            remainingAmount: remainingAmount,
            status: status,
            sourceWalletId: sourceWalletId,
            destinationWalletId: destinationWalletId,
            borrowedAt: borrowedAt,
            targetRepaymentDate: targetRepaymentDate,
            settledAt: settledAt,
            note: note,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required double originalAmount,
            required double remainingAmount,
            Value<String> status = const Value.absent(),
            required int sourceWalletId,
            required int destinationWalletId,
            required DateTime borrowedAt,
            Value<DateTime?> targetRepaymentDate = const Value.absent(),
            Value<DateTime?> settledAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              InternalDebtsCompanion.insert(
            id: id,
            title: title,
            originalAmount: originalAmount,
            remainingAmount: remainingAmount,
            status: status,
            sourceWalletId: sourceWalletId,
            destinationWalletId: destinationWalletId,
            borrowedAt: borrowedAt,
            targetRepaymentDate: targetRepaymentDate,
            settledAt: settledAt,
            note: note,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InternalDebtsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sourceWalletId = false,
              destinationWalletId = false,
              transactionsForDebt = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsForDebt) db.transactions
              ],
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
                if (sourceWalletId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceWalletId,
                    referencedTable:
                        $$InternalDebtsTableReferences._sourceWalletIdTable(db),
                    referencedColumn: $$InternalDebtsTableReferences
                        ._sourceWalletIdTable(db)
                        .id,
                  ) as T;
                }
                if (destinationWalletId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.destinationWalletId,
                    referencedTable: $$InternalDebtsTableReferences
                        ._destinationWalletIdTable(db),
                    referencedColumn: $$InternalDebtsTableReferences
                        ._destinationWalletIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsForDebt)
                    await $_getPrefetchedData<InternalDebt, $InternalDebtsTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$InternalDebtsTableReferences
                            ._transactionsForDebtTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InternalDebtsTableReferences(db, table, p0)
                                .transactionsForDebt,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedInternalDebtId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InternalDebtsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InternalDebtsTable,
    InternalDebt,
    $$InternalDebtsTableFilterComposer,
    $$InternalDebtsTableOrderingComposer,
    $$InternalDebtsTableAnnotationComposer,
    $$InternalDebtsTableCreateCompanionBuilder,
    $$InternalDebtsTableUpdateCompanionBuilder,
    (InternalDebt, $$InternalDebtsTableReferences),
    InternalDebt,
    PrefetchHooks Function(
        {bool sourceWalletId,
        bool destinationWalletId,
        bool transactionsForDebt})>;
typedef $$ReceivablesTableCreateCompanionBuilder = ReceivablesCompanion
    Function({
  Value<int> id,
  required String borrowerName,
  Value<String?> borrowerContact,
  required double originalAmount,
  required double remainingAmount,
  Value<String> status,
  required int sourceWalletId,
  required DateTime lentAt,
  Value<DateTime?> targetReturnDate,
  Value<DateTime?> collectedAt,
  Value<String?> purpose,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$ReceivablesTableUpdateCompanionBuilder = ReceivablesCompanion
    Function({
  Value<int> id,
  Value<String> borrowerName,
  Value<String?> borrowerContact,
  Value<double> originalAmount,
  Value<double> remainingAmount,
  Value<String> status,
  Value<int> sourceWalletId,
  Value<DateTime> lentAt,
  Value<DateTime?> targetReturnDate,
  Value<DateTime?> collectedAt,
  Value<String?> purpose,
  Value<String?> note,
  Value<DateTime> createdAt,
});

final class $$ReceivablesTableReferences
    extends BaseReferences<_$AppDatabase, $ReceivablesTable, Receivable> {
  $$ReceivablesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WalletsTable _sourceWalletIdTable(_$AppDatabase db) =>
      db.wallets.createAlias(
          $_aliasNameGenerator(db.receivables.sourceWalletId, db.wallets.id));

  $$WalletsTableProcessedTableManager get sourceWalletId {
    final $_column = $_itemColumn<int>('source_wallet_id')!;

    final manager = $$WalletsTableTableManager($_db, $_db.wallets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceWalletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsForReceivableTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.receivables.id, db.transactions.relatedReceivableId));

  $$TransactionsTableProcessedTableManager get transactionsForReceivable {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) =>
            f.relatedReceivableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionsForReceivableTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ReceivablesTableFilterComposer
    extends Composer<_$AppDatabase, $ReceivablesTable> {
  $$ReceivablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get borrowerName => $composableBuilder(
      column: $table.borrowerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get borrowerContact => $composableBuilder(
      column: $table.borrowerContact,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originalAmount => $composableBuilder(
      column: $table.originalAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lentAt => $composableBuilder(
      column: $table.lentAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetReturnDate => $composableBuilder(
      column: $table.targetReturnDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get collectedAt => $composableBuilder(
      column: $table.collectedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purpose => $composableBuilder(
      column: $table.purpose, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$WalletsTableFilterComposer get sourceWalletId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableFilterComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsForReceivable(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.relatedReceivableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReceivablesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceivablesTable> {
  $$ReceivablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get borrowerName => $composableBuilder(
      column: $table.borrowerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get borrowerContact => $composableBuilder(
      column: $table.borrowerContact,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originalAmount => $composableBuilder(
      column: $table.originalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lentAt => $composableBuilder(
      column: $table.lentAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetReturnDate => $composableBuilder(
      column: $table.targetReturnDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get collectedAt => $composableBuilder(
      column: $table.collectedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purpose => $composableBuilder(
      column: $table.purpose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$WalletsTableOrderingComposer get sourceWalletId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableOrderingComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReceivablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceivablesTable> {
  $$ReceivablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get borrowerName => $composableBuilder(
      column: $table.borrowerName, builder: (column) => column);

  GeneratedColumn<String> get borrowerContact => $composableBuilder(
      column: $table.borrowerContact, builder: (column) => column);

  GeneratedColumn<double> get originalAmount => $composableBuilder(
      column: $table.originalAmount, builder: (column) => column);

  GeneratedColumn<double> get remainingAmount => $composableBuilder(
      column: $table.remainingAmount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lentAt =>
      $composableBuilder(column: $table.lentAt, builder: (column) => column);

  GeneratedColumn<DateTime> get targetReturnDate => $composableBuilder(
      column: $table.targetReturnDate, builder: (column) => column);

  GeneratedColumn<DateTime> get collectedAt => $composableBuilder(
      column: $table.collectedAt, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WalletsTableAnnotationComposer get sourceWalletId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsForReceivable<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.relatedReceivableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReceivablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReceivablesTable,
    Receivable,
    $$ReceivablesTableFilterComposer,
    $$ReceivablesTableOrderingComposer,
    $$ReceivablesTableAnnotationComposer,
    $$ReceivablesTableCreateCompanionBuilder,
    $$ReceivablesTableUpdateCompanionBuilder,
    (Receivable, $$ReceivablesTableReferences),
    Receivable,
    PrefetchHooks Function(
        {bool sourceWalletId, bool transactionsForReceivable})> {
  $$ReceivablesTableTableManager(_$AppDatabase db, $ReceivablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceivablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceivablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceivablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> borrowerName = const Value.absent(),
            Value<String?> borrowerContact = const Value.absent(),
            Value<double> originalAmount = const Value.absent(),
            Value<double> remainingAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> sourceWalletId = const Value.absent(),
            Value<DateTime> lentAt = const Value.absent(),
            Value<DateTime?> targetReturnDate = const Value.absent(),
            Value<DateTime?> collectedAt = const Value.absent(),
            Value<String?> purpose = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReceivablesCompanion(
            id: id,
            borrowerName: borrowerName,
            borrowerContact: borrowerContact,
            originalAmount: originalAmount,
            remainingAmount: remainingAmount,
            status: status,
            sourceWalletId: sourceWalletId,
            lentAt: lentAt,
            targetReturnDate: targetReturnDate,
            collectedAt: collectedAt,
            purpose: purpose,
            note: note,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String borrowerName,
            Value<String?> borrowerContact = const Value.absent(),
            required double originalAmount,
            required double remainingAmount,
            Value<String> status = const Value.absent(),
            required int sourceWalletId,
            required DateTime lentAt,
            Value<DateTime?> targetReturnDate = const Value.absent(),
            Value<DateTime?> collectedAt = const Value.absent(),
            Value<String?> purpose = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReceivablesCompanion.insert(
            id: id,
            borrowerName: borrowerName,
            borrowerContact: borrowerContact,
            originalAmount: originalAmount,
            remainingAmount: remainingAmount,
            status: status,
            sourceWalletId: sourceWalletId,
            lentAt: lentAt,
            targetReturnDate: targetReturnDate,
            collectedAt: collectedAt,
            purpose: purpose,
            note: note,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReceivablesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sourceWalletId = false, transactionsForReceivable = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsForReceivable) db.transactions
              ],
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
                if (sourceWalletId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceWalletId,
                    referencedTable:
                        $$ReceivablesTableReferences._sourceWalletIdTable(db),
                    referencedColumn: $$ReceivablesTableReferences
                        ._sourceWalletIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsForReceivable)
                    await $_getPrefetchedData<Receivable, $ReceivablesTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$ReceivablesTableReferences
                            ._transactionsForReceivableTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ReceivablesTableReferences(db, table, p0)
                                .transactionsForReceivable,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.relatedReceivableId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ReceivablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReceivablesTable,
    Receivable,
    $$ReceivablesTableFilterComposer,
    $$ReceivablesTableOrderingComposer,
    $$ReceivablesTableAnnotationComposer,
    $$ReceivablesTableCreateCompanionBuilder,
    $$ReceivablesTableUpdateCompanionBuilder,
    (Receivable, $$ReceivablesTableReferences),
    Receivable,
    PrefetchHooks Function(
        {bool sourceWalletId, bool transactionsForReceivable})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required String uuid,
  required String type,
  required String category,
  required double amount,
  required String description,
  required DateTime date,
  Value<String?> note,
  Value<String?> receiptImagePath,
  Value<int?> sourceWalletId,
  Value<int?> destinationWalletId,
  Value<int?> relatedInternalDebtId,
  Value<int?> relatedReceivableId,
  Value<DateTime> createdAt,
  Value<bool> isDeleted,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> type,
  Value<String> category,
  Value<double> amount,
  Value<String> description,
  Value<DateTime> date,
  Value<String?> note,
  Value<String?> receiptImagePath,
  Value<int?> sourceWalletId,
  Value<int?> destinationWalletId,
  Value<int?> relatedInternalDebtId,
  Value<int?> relatedReceivableId,
  Value<DateTime> createdAt,
  Value<bool> isDeleted,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WalletsTable _sourceWalletIdTable(_$AppDatabase db) =>
      db.wallets.createAlias(
          $_aliasNameGenerator(db.transactions.sourceWalletId, db.wallets.id));

  $$WalletsTableProcessedTableManager? get sourceWalletId {
    final $_column = $_itemColumn<int>('source_wallet_id');
    if ($_column == null) return null;
    final manager = $$WalletsTableTableManager($_db, $_db.wallets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceWalletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WalletsTable _destinationWalletIdTable(_$AppDatabase db) =>
      db.wallets.createAlias($_aliasNameGenerator(
          db.transactions.destinationWalletId, db.wallets.id));

  $$WalletsTableProcessedTableManager? get destinationWalletId {
    final $_column = $_itemColumn<int>('destination_wallet_id');
    if ($_column == null) return null;
    final manager = $$WalletsTableTableManager($_db, $_db.wallets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_destinationWalletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InternalDebtsTable _relatedInternalDebtIdTable(_$AppDatabase db) =>
      db.internalDebts.createAlias($_aliasNameGenerator(
          db.transactions.relatedInternalDebtId, db.internalDebts.id));

  $$InternalDebtsTableProcessedTableManager? get relatedInternalDebtId {
    final $_column = $_itemColumn<int>('related_internal_debt_id');
    if ($_column == null) return null;
    final manager = $$InternalDebtsTableTableManager($_db, $_db.internalDebts)
        .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_relatedInternalDebtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ReceivablesTable _relatedReceivableIdTable(_$AppDatabase db) =>
      db.receivables.createAlias($_aliasNameGenerator(
          db.transactions.relatedReceivableId, db.receivables.id));

  $$ReceivablesTableProcessedTableManager? get relatedReceivableId {
    final $_column = $_itemColumn<int>('related_receivable_id');
    if ($_column == null) return null;
    final manager = $$ReceivablesTableTableManager($_db, $_db.receivables)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_relatedReceivableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
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
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptImagePath => $composableBuilder(
      column: $table.receiptImagePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  $$WalletsTableFilterComposer get sourceWalletId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableFilterComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableFilterComposer get destinationWalletId {
    final $$WalletsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableFilterComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InternalDebtsTableFilterComposer get relatedInternalDebtId {
    final $$InternalDebtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedInternalDebtId,
        referencedTable: $db.internalDebts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InternalDebtsTableFilterComposer(
              $db: $db,
              $table: $db.internalDebts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReceivablesTableFilterComposer get relatedReceivableId {
    final $$ReceivablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedReceivableId,
        referencedTable: $db.receivables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceivablesTableFilterComposer(
              $db: $db,
              $table: $db.receivables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
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
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptImagePath => $composableBuilder(
      column: $table.receiptImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  $$WalletsTableOrderingComposer get sourceWalletId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableOrderingComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableOrderingComposer get destinationWalletId {
    final $$WalletsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableOrderingComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InternalDebtsTableOrderingComposer get relatedInternalDebtId {
    final $$InternalDebtsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedInternalDebtId,
        referencedTable: $db.internalDebts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InternalDebtsTableOrderingComposer(
              $db: $db,
              $table: $db.internalDebts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReceivablesTableOrderingComposer get relatedReceivableId {
    final $$ReceivablesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedReceivableId,
        referencedTable: $db.receivables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceivablesTableOrderingComposer(
              $db: $db,
              $table: $db.receivables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
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

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get receiptImagePath => $composableBuilder(
      column: $table.receiptImagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$WalletsTableAnnotationComposer get sourceWalletId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WalletsTableAnnotationComposer get destinationWalletId {
    final $$WalletsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationWalletId,
        referencedTable: $db.wallets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WalletsTableAnnotationComposer(
              $db: $db,
              $table: $db.wallets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InternalDebtsTableAnnotationComposer get relatedInternalDebtId {
    final $$InternalDebtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedInternalDebtId,
        referencedTable: $db.internalDebts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InternalDebtsTableAnnotationComposer(
              $db: $db,
              $table: $db.internalDebts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReceivablesTableAnnotationComposer get relatedReceivableId {
    final $$ReceivablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.relatedReceivableId,
        referencedTable: $db.receivables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReceivablesTableAnnotationComposer(
              $db: $db,
              $table: $db.receivables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
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
    PrefetchHooks Function(
        {bool sourceWalletId,
        bool destinationWalletId,
        bool relatedInternalDebtId,
        bool relatedReceivableId})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
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
            Value<String> uuid = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> receiptImagePath = const Value.absent(),
            Value<int?> sourceWalletId = const Value.absent(),
            Value<int?> destinationWalletId = const Value.absent(),
            Value<int?> relatedInternalDebtId = const Value.absent(),
            Value<int?> relatedReceivableId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            uuid: uuid,
            type: type,
            category: category,
            amount: amount,
            description: description,
            date: date,
            note: note,
            receiptImagePath: receiptImagePath,
            sourceWalletId: sourceWalletId,
            destinationWalletId: destinationWalletId,
            relatedInternalDebtId: relatedInternalDebtId,
            relatedReceivableId: relatedReceivableId,
            createdAt: createdAt,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String type,
            required String category,
            required double amount,
            required String description,
            required DateTime date,
            Value<String?> note = const Value.absent(),
            Value<String?> receiptImagePath = const Value.absent(),
            Value<int?> sourceWalletId = const Value.absent(),
            Value<int?> destinationWalletId = const Value.absent(),
            Value<int?> relatedInternalDebtId = const Value.absent(),
            Value<int?> relatedReceivableId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            uuid: uuid,
            type: type,
            category: category,
            amount: amount,
            description: description,
            date: date,
            note: note,
            receiptImagePath: receiptImagePath,
            sourceWalletId: sourceWalletId,
            destinationWalletId: destinationWalletId,
            relatedInternalDebtId: relatedInternalDebtId,
            relatedReceivableId: relatedReceivableId,
            createdAt: createdAt,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sourceWalletId = false,
              destinationWalletId = false,
              relatedInternalDebtId = false,
              relatedReceivableId = false}) {
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
                if (sourceWalletId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceWalletId,
                    referencedTable:
                        $$TransactionsTableReferences._sourceWalletIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._sourceWalletIdTable(db)
                        .id,
                  ) as T;
                }
                if (destinationWalletId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.destinationWalletId,
                    referencedTable: $$TransactionsTableReferences
                        ._destinationWalletIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._destinationWalletIdTable(db)
                        .id,
                  ) as T;
                }
                if (relatedInternalDebtId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.relatedInternalDebtId,
                    referencedTable: $$TransactionsTableReferences
                        ._relatedInternalDebtIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._relatedInternalDebtIdTable(db)
                        .id,
                  ) as T;
                }
                if (relatedReceivableId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.relatedReceivableId,
                    referencedTable: $$TransactionsTableReferences
                        ._relatedReceivableIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._relatedReceivableIdTable(db)
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
        ));
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
    PrefetchHooks Function(
        {bool sourceWalletId,
        bool destinationWalletId,
        bool relatedInternalDebtId,
        bool relatedReceivableId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$InternalDebtsTableTableManager get internalDebts =>
      $$InternalDebtsTableTableManager(_db, _db.internalDebts);
  $$ReceivablesTableTableManager get receivables =>
      $$ReceivablesTableTableManager(_db, _db.receivables);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
}
