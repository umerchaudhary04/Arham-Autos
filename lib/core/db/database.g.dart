// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BackupLogTable extends BackupLog
    with TableInfo<$BackupLogTable, BackupLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _backupIdMeta = const VerificationMeta(
    'backupId',
  );
  @override
  late final GeneratedColumn<String> backupId = GeneratedColumn<String>(
    'backup_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
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
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [
    backupId,
    filePath,
    createdAt,
    sizeBytes,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<BackupLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('backup_id')) {
      context.handle(
        _backupIdMeta,
        backupId.isAcceptableOrUnknown(data['backup_id']!, _backupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_backupIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {backupId};
  @override
  BackupLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupLogData(
      backupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backup_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $BackupLogTable createAlias(String alias) {
    return $BackupLogTable(attachedDatabase, alias);
  }
}

class BackupLogData extends DataClass implements Insertable<BackupLogData> {
  final String backupId;
  final String filePath;
  final DateTime createdAt;
  final int? sizeBytes;
  final String status;
  const BackupLogData({
    required this.backupId,
    required this.filePath,
    required this.createdAt,
    this.sizeBytes,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['backup_id'] = Variable<String>(backupId);
    map['file_path'] = Variable<String>(filePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  BackupLogCompanion toCompanion(bool nullToAbsent) {
    return BackupLogCompanion(
      backupId: Value(backupId),
      filePath: Value(filePath),
      createdAt: Value(createdAt),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeBytes),
      status: Value(status),
    );
  }

  factory BackupLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupLogData(
      backupId: serializer.fromJson<String>(json['backupId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'backupId': serializer.toJson<String>(backupId),
      'filePath': serializer.toJson<String>(filePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
      'status': serializer.toJson<String>(status),
    };
  }

  BackupLogData copyWith({
    String? backupId,
    String? filePath,
    DateTime? createdAt,
    Value<int?> sizeBytes = const Value.absent(),
    String? status,
  }) => BackupLogData(
    backupId: backupId ?? this.backupId,
    filePath: filePath ?? this.filePath,
    createdAt: createdAt ?? this.createdAt,
    sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
    status: status ?? this.status,
  );
  BackupLogData copyWithCompanion(BackupLogCompanion data) {
    return BackupLogData(
      backupId: data.backupId.present ? data.backupId.value : this.backupId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupLogData(')
          ..write('backupId: $backupId, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(backupId, filePath, createdAt, sizeBytes, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupLogData &&
          other.backupId == this.backupId &&
          other.filePath == this.filePath &&
          other.createdAt == this.createdAt &&
          other.sizeBytes == this.sizeBytes &&
          other.status == this.status);
}

class BackupLogCompanion extends UpdateCompanion<BackupLogData> {
  final Value<String> backupId;
  final Value<String> filePath;
  final Value<DateTime> createdAt;
  final Value<int?> sizeBytes;
  final Value<String> status;
  final Value<int> rowid;
  const BackupLogCompanion({
    this.backupId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupLogCompanion.insert({
    required String backupId,
    required String filePath,
    this.createdAt = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : backupId = Value(backupId),
       filePath = Value(filePath),
       status = Value(status);
  static Insertable<BackupLogData> custom({
    Expression<String>? backupId,
    Expression<String>? filePath,
    Expression<DateTime>? createdAt,
    Expression<int>? sizeBytes,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (backupId != null) 'backup_id': backupId,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupLogCompanion copyWith({
    Value<String>? backupId,
    Value<String>? filePath,
    Value<DateTime>? createdAt,
    Value<int?>? sizeBytes,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return BackupLogCompanion(
      backupId: backupId ?? this.backupId,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (backupId.present) {
      map['backup_id'] = Variable<String>(backupId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupLogCompanion(')
          ..write('backupId: $backupId, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  @override
  late final GeneratedColumn<int> logId = GeneratedColumn<int>(
    'log_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oldValueMeta = const VerificationMeta(
    'oldValue',
  );
  @override
  late final GeneratedColumn<String> oldValue = GeneratedColumn<String>(
    'old_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newValueMeta = const VerificationMeta(
    'newValue',
  );
  @override
  late final GeneratedColumn<String> newValue = GeneratedColumn<String>(
    'new_value',
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
    logId,
    userId,
    actionType,
    targetTable,
    recordId,
    oldValue,
    newValue,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('log_id')) {
      context.handle(
        _logIdMeta,
        logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    }
    if (data.containsKey('old_value')) {
      context.handle(
        _oldValueMeta,
        oldValue.isAcceptableOrUnknown(data['old_value']!, _oldValueMeta),
      );
    }
    if (data.containsKey('new_value')) {
      context.handle(
        _newValueMeta,
        newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta),
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
  Set<GeneratedColumn> get $primaryKey => {logId};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      logId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}log_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      ),
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      ),
      oldValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_value'],
      ),
      newValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_value'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final int logId;
  final String userId;
  final String actionType;
  final String? targetTable;
  final String? recordId;
  final String? oldValue;
  final String? newValue;
  final DateTime createdAt;
  const AuditLogData({
    required this.logId,
    required this.userId,
    required this.actionType,
    this.targetTable,
    this.recordId,
    this.oldValue,
    this.newValue,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['log_id'] = Variable<int>(logId);
    map['user_id'] = Variable<String>(userId);
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || targetTable != null) {
      map['target_table'] = Variable<String>(targetTable);
    }
    if (!nullToAbsent || recordId != null) {
      map['record_id'] = Variable<String>(recordId);
    }
    if (!nullToAbsent || oldValue != null) {
      map['old_value'] = Variable<String>(oldValue);
    }
    if (!nullToAbsent || newValue != null) {
      map['new_value'] = Variable<String>(newValue);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      logId: Value(logId),
      userId: Value(userId),
      actionType: Value(actionType),
      targetTable: targetTable == null && nullToAbsent
          ? const Value.absent()
          : Value(targetTable),
      recordId: recordId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordId),
      oldValue: oldValue == null && nullToAbsent
          ? const Value.absent()
          : Value(oldValue),
      newValue: newValue == null && nullToAbsent
          ? const Value.absent()
          : Value(newValue),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      logId: serializer.fromJson<int>(json['logId']),
      userId: serializer.fromJson<String>(json['userId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      targetTable: serializer.fromJson<String?>(json['targetTable']),
      recordId: serializer.fromJson<String?>(json['recordId']),
      oldValue: serializer.fromJson<String?>(json['oldValue']),
      newValue: serializer.fromJson<String?>(json['newValue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'logId': serializer.toJson<int>(logId),
      'userId': serializer.toJson<String>(userId),
      'actionType': serializer.toJson<String>(actionType),
      'targetTable': serializer.toJson<String?>(targetTable),
      'recordId': serializer.toJson<String?>(recordId),
      'oldValue': serializer.toJson<String?>(oldValue),
      'newValue': serializer.toJson<String?>(newValue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLogData copyWith({
    int? logId,
    String? userId,
    String? actionType,
    Value<String?> targetTable = const Value.absent(),
    Value<String?> recordId = const Value.absent(),
    Value<String?> oldValue = const Value.absent(),
    Value<String?> newValue = const Value.absent(),
    DateTime? createdAt,
  }) => AuditLogData(
    logId: logId ?? this.logId,
    userId: userId ?? this.userId,
    actionType: actionType ?? this.actionType,
    targetTable: targetTable.present ? targetTable.value : this.targetTable,
    recordId: recordId.present ? recordId.value : this.recordId,
    oldValue: oldValue.present ? oldValue.value : this.oldValue,
    newValue: newValue.present ? newValue.value : this.newValue,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      logId: data.logId.present ? data.logId.value : this.logId,
      userId: data.userId.present ? data.userId.value : this.userId,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      oldValue: data.oldValue.present ? data.oldValue.value : this.oldValue,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('logId: $logId, ')
          ..write('userId: $userId, ')
          ..write('actionType: $actionType, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    logId,
    userId,
    actionType,
    targetTable,
    recordId,
    oldValue,
    newValue,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.logId == this.logId &&
          other.userId == this.userId &&
          other.actionType == this.actionType &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.oldValue == this.oldValue &&
          other.newValue == this.newValue &&
          other.createdAt == this.createdAt);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<int> logId;
  final Value<String> userId;
  final Value<String> actionType;
  final Value<String?> targetTable;
  final Value<String?> recordId;
  final Value<String?> oldValue;
  final Value<String?> newValue;
  final Value<DateTime> createdAt;
  const AuditLogCompanion({
    this.logId = const Value.absent(),
    this.userId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.logId = const Value.absent(),
    required String userId,
    required String actionType,
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       actionType = Value(actionType);
  static Insertable<AuditLogData> custom({
    Expression<int>? logId,
    Expression<String>? userId,
    Expression<String>? actionType,
    Expression<String>? targetTable,
    Expression<String>? recordId,
    Expression<String>? oldValue,
    Expression<String>? newValue,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (logId != null) 'log_id': logId,
      if (userId != null) 'user_id': userId,
      if (actionType != null) 'action_type': actionType,
      if (targetTable != null) 'target_table': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (oldValue != null) 'old_value': oldValue,
      if (newValue != null) 'new_value': newValue,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogCompanion copyWith({
    Value<int>? logId,
    Value<String>? userId,
    Value<String>? actionType,
    Value<String?>? targetTable,
    Value<String?>? recordId,
    Value<String?>? oldValue,
    Value<String?>? newValue,
    Value<DateTime>? createdAt,
  }) {
    return AuditLogCompanion(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      actionType: actionType ?? this.actionType,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (logId.present) {
      map['log_id'] = Variable<int>(logId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (oldValue.present) {
      map['old_value'] = Variable<String>(oldValue.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<String>(newValue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('logId: $logId, ')
          ..write('userId: $userId, ')
          ..write('actionType: $actionType, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MigrationLogTable extends MigrationLog
    with TableInfo<$MigrationLogTable, MigrationLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MigrationLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _migrationIdMeta = const VerificationMeta(
    'migrationId',
  );
  @override
  late final GeneratedColumn<String> migrationId = GeneratedColumn<String>(
    'migration_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceFileMeta = const VerificationMeta(
    'sourceFile',
  );
  @override
  late final GeneratedColumn<String> sourceFile = GeneratedColumn<String>(
    'source_file',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordsImportedMeta = const VerificationMeta(
    'recordsImported',
  );
  @override
  late final GeneratedColumn<int> recordsImported = GeneratedColumn<int>(
    'records_imported',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordsFlaggedMeta = const VerificationMeta(
    'recordsFlagged',
  );
  @override
  late final GeneratedColumn<int> recordsFlagged = GeneratedColumn<int>(
    'records_flagged',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _performedByMeta = const VerificationMeta(
    'performedBy',
  );
  @override
  late final GeneratedColumn<String> performedBy = GeneratedColumn<String>(
    'performed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _performedAtMeta = const VerificationMeta(
    'performedAt',
  );
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
    'performed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    migrationId,
    sourceFile,
    recordsImported,
    recordsFlagged,
    performedBy,
    performedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'migration_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<MigrationLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('migration_id')) {
      context.handle(
        _migrationIdMeta,
        migrationId.isAcceptableOrUnknown(
          data['migration_id']!,
          _migrationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_migrationIdMeta);
    }
    if (data.containsKey('source_file')) {
      context.handle(
        _sourceFileMeta,
        sourceFile.isAcceptableOrUnknown(data['source_file']!, _sourceFileMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceFileMeta);
    }
    if (data.containsKey('records_imported')) {
      context.handle(
        _recordsImportedMeta,
        recordsImported.isAcceptableOrUnknown(
          data['records_imported']!,
          _recordsImportedMeta,
        ),
      );
    }
    if (data.containsKey('records_flagged')) {
      context.handle(
        _recordsFlaggedMeta,
        recordsFlagged.isAcceptableOrUnknown(
          data['records_flagged']!,
          _recordsFlaggedMeta,
        ),
      );
    }
    if (data.containsKey('performed_by')) {
      context.handle(
        _performedByMeta,
        performedBy.isAcceptableOrUnknown(
          data['performed_by']!,
          _performedByMeta,
        ),
      );
    }
    if (data.containsKey('performed_at')) {
      context.handle(
        _performedAtMeta,
        performedAt.isAcceptableOrUnknown(
          data['performed_at']!,
          _performedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {migrationId};
  @override
  MigrationLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MigrationLogData(
      migrationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}migration_id'],
      )!,
      sourceFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_file'],
      )!,
      recordsImported: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}records_imported'],
      ),
      recordsFlagged: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}records_flagged'],
      ),
      performedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performed_by'],
      ),
      performedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_at'],
      )!,
    );
  }

  @override
  $MigrationLogTable createAlias(String alias) {
    return $MigrationLogTable(attachedDatabase, alias);
  }
}

class MigrationLogData extends DataClass
    implements Insertable<MigrationLogData> {
  final String migrationId;
  final String sourceFile;
  final int? recordsImported;
  final int? recordsFlagged;
  final String? performedBy;
  final DateTime performedAt;
  const MigrationLogData({
    required this.migrationId,
    required this.sourceFile,
    this.recordsImported,
    this.recordsFlagged,
    this.performedBy,
    required this.performedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['migration_id'] = Variable<String>(migrationId);
    map['source_file'] = Variable<String>(sourceFile);
    if (!nullToAbsent || recordsImported != null) {
      map['records_imported'] = Variable<int>(recordsImported);
    }
    if (!nullToAbsent || recordsFlagged != null) {
      map['records_flagged'] = Variable<int>(recordsFlagged);
    }
    if (!nullToAbsent || performedBy != null) {
      map['performed_by'] = Variable<String>(performedBy);
    }
    map['performed_at'] = Variable<DateTime>(performedAt);
    return map;
  }

  MigrationLogCompanion toCompanion(bool nullToAbsent) {
    return MigrationLogCompanion(
      migrationId: Value(migrationId),
      sourceFile: Value(sourceFile),
      recordsImported: recordsImported == null && nullToAbsent
          ? const Value.absent()
          : Value(recordsImported),
      recordsFlagged: recordsFlagged == null && nullToAbsent
          ? const Value.absent()
          : Value(recordsFlagged),
      performedBy: performedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(performedBy),
      performedAt: Value(performedAt),
    );
  }

  factory MigrationLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MigrationLogData(
      migrationId: serializer.fromJson<String>(json['migrationId']),
      sourceFile: serializer.fromJson<String>(json['sourceFile']),
      recordsImported: serializer.fromJson<int?>(json['recordsImported']),
      recordsFlagged: serializer.fromJson<int?>(json['recordsFlagged']),
      performedBy: serializer.fromJson<String?>(json['performedBy']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'migrationId': serializer.toJson<String>(migrationId),
      'sourceFile': serializer.toJson<String>(sourceFile),
      'recordsImported': serializer.toJson<int?>(recordsImported),
      'recordsFlagged': serializer.toJson<int?>(recordsFlagged),
      'performedBy': serializer.toJson<String?>(performedBy),
      'performedAt': serializer.toJson<DateTime>(performedAt),
    };
  }

  MigrationLogData copyWith({
    String? migrationId,
    String? sourceFile,
    Value<int?> recordsImported = const Value.absent(),
    Value<int?> recordsFlagged = const Value.absent(),
    Value<String?> performedBy = const Value.absent(),
    DateTime? performedAt,
  }) => MigrationLogData(
    migrationId: migrationId ?? this.migrationId,
    sourceFile: sourceFile ?? this.sourceFile,
    recordsImported: recordsImported.present
        ? recordsImported.value
        : this.recordsImported,
    recordsFlagged: recordsFlagged.present
        ? recordsFlagged.value
        : this.recordsFlagged,
    performedBy: performedBy.present ? performedBy.value : this.performedBy,
    performedAt: performedAt ?? this.performedAt,
  );
  MigrationLogData copyWithCompanion(MigrationLogCompanion data) {
    return MigrationLogData(
      migrationId: data.migrationId.present
          ? data.migrationId.value
          : this.migrationId,
      sourceFile: data.sourceFile.present
          ? data.sourceFile.value
          : this.sourceFile,
      recordsImported: data.recordsImported.present
          ? data.recordsImported.value
          : this.recordsImported,
      recordsFlagged: data.recordsFlagged.present
          ? data.recordsFlagged.value
          : this.recordsFlagged,
      performedBy: data.performedBy.present
          ? data.performedBy.value
          : this.performedBy,
      performedAt: data.performedAt.present
          ? data.performedAt.value
          : this.performedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MigrationLogData(')
          ..write('migrationId: $migrationId, ')
          ..write('sourceFile: $sourceFile, ')
          ..write('recordsImported: $recordsImported, ')
          ..write('recordsFlagged: $recordsFlagged, ')
          ..write('performedBy: $performedBy, ')
          ..write('performedAt: $performedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    migrationId,
    sourceFile,
    recordsImported,
    recordsFlagged,
    performedBy,
    performedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MigrationLogData &&
          other.migrationId == this.migrationId &&
          other.sourceFile == this.sourceFile &&
          other.recordsImported == this.recordsImported &&
          other.recordsFlagged == this.recordsFlagged &&
          other.performedBy == this.performedBy &&
          other.performedAt == this.performedAt);
}

class MigrationLogCompanion extends UpdateCompanion<MigrationLogData> {
  final Value<String> migrationId;
  final Value<String> sourceFile;
  final Value<int?> recordsImported;
  final Value<int?> recordsFlagged;
  final Value<String?> performedBy;
  final Value<DateTime> performedAt;
  final Value<int> rowid;
  const MigrationLogCompanion({
    this.migrationId = const Value.absent(),
    this.sourceFile = const Value.absent(),
    this.recordsImported = const Value.absent(),
    this.recordsFlagged = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MigrationLogCompanion.insert({
    required String migrationId,
    required String sourceFile,
    this.recordsImported = const Value.absent(),
    this.recordsFlagged = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : migrationId = Value(migrationId),
       sourceFile = Value(sourceFile);
  static Insertable<MigrationLogData> custom({
    Expression<String>? migrationId,
    Expression<String>? sourceFile,
    Expression<int>? recordsImported,
    Expression<int>? recordsFlagged,
    Expression<String>? performedBy,
    Expression<DateTime>? performedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (migrationId != null) 'migration_id': migrationId,
      if (sourceFile != null) 'source_file': sourceFile,
      if (recordsImported != null) 'records_imported': recordsImported,
      if (recordsFlagged != null) 'records_flagged': recordsFlagged,
      if (performedBy != null) 'performed_by': performedBy,
      if (performedAt != null) 'performed_at': performedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MigrationLogCompanion copyWith({
    Value<String>? migrationId,
    Value<String>? sourceFile,
    Value<int?>? recordsImported,
    Value<int?>? recordsFlagged,
    Value<String?>? performedBy,
    Value<DateTime>? performedAt,
    Value<int>? rowid,
  }) {
    return MigrationLogCompanion(
      migrationId: migrationId ?? this.migrationId,
      sourceFile: sourceFile ?? this.sourceFile,
      recordsImported: recordsImported ?? this.recordsImported,
      recordsFlagged: recordsFlagged ?? this.recordsFlagged,
      performedBy: performedBy ?? this.performedBy,
      performedAt: performedAt ?? this.performedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (migrationId.present) {
      map['migration_id'] = Variable<String>(migrationId.value);
    }
    if (sourceFile.present) {
      map['source_file'] = Variable<String>(sourceFile.value);
    }
    if (recordsImported.present) {
      map['records_imported'] = Variable<int>(recordsImported.value);
    }
    if (recordsFlagged.present) {
      map['records_flagged'] = Variable<int>(recordsFlagged.value);
    }
    if (performedBy.present) {
      map['performed_by'] = Variable<String>(performedBy.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MigrationLogCompanion(')
          ..write('migrationId: $migrationId, ')
          ..write('sourceFile: $sourceFile, ')
          ..write('recordsImported: $recordsImported, ')
          ..write('recordsFlagged: $recordsFlagged, ')
          ..write('performedBy: $performedBy, ')
          ..write('performedAt: $performedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParkedCartsTable extends ParkedCarts
    with TableInfo<$ParkedCartsTable, ParkedCart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParkedCartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _parkedIdMeta = const VerificationMeta(
    'parkedId',
  );
  @override
  late final GeneratedColumn<String> parkedId = GeneratedColumn<String>(
    'parked_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cartPayloadJsonMeta = const VerificationMeta(
    'cartPayloadJson',
  );
  @override
  late final GeneratedColumn<String> cartPayloadJson = GeneratedColumn<String>(
    'cart_payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parkedAtMeta = const VerificationMeta(
    'parkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> parkedAt = GeneratedColumn<DateTime>(
    'parked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    parkedId,
    userId,
    cartPayloadJson,
    parkedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parked_carts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParkedCart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('parked_id')) {
      context.handle(
        _parkedIdMeta,
        parkedId.isAcceptableOrUnknown(data['parked_id']!, _parkedIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parkedIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('cart_payload_json')) {
      context.handle(
        _cartPayloadJsonMeta,
        cartPayloadJson.isAcceptableOrUnknown(
          data['cart_payload_json']!,
          _cartPayloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cartPayloadJsonMeta);
    }
    if (data.containsKey('parked_at')) {
      context.handle(
        _parkedAtMeta,
        parkedAt.isAcceptableOrUnknown(data['parked_at']!, _parkedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {parkedId};
  @override
  ParkedCart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParkedCart(
      parkedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parked_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      cartPayloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cart_payload_json'],
      )!,
      parkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}parked_at'],
      )!,
    );
  }

  @override
  $ParkedCartsTable createAlias(String alias) {
    return $ParkedCartsTable(attachedDatabase, alias);
  }
}

class ParkedCart extends DataClass implements Insertable<ParkedCart> {
  final String parkedId;
  final String userId;
  final String cartPayloadJson;
  final DateTime parkedAt;
  const ParkedCart({
    required this.parkedId,
    required this.userId,
    required this.cartPayloadJson,
    required this.parkedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['parked_id'] = Variable<String>(parkedId);
    map['user_id'] = Variable<String>(userId);
    map['cart_payload_json'] = Variable<String>(cartPayloadJson);
    map['parked_at'] = Variable<DateTime>(parkedAt);
    return map;
  }

  ParkedCartsCompanion toCompanion(bool nullToAbsent) {
    return ParkedCartsCompanion(
      parkedId: Value(parkedId),
      userId: Value(userId),
      cartPayloadJson: Value(cartPayloadJson),
      parkedAt: Value(parkedAt),
    );
  }

  factory ParkedCart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParkedCart(
      parkedId: serializer.fromJson<String>(json['parkedId']),
      userId: serializer.fromJson<String>(json['userId']),
      cartPayloadJson: serializer.fromJson<String>(json['cartPayloadJson']),
      parkedAt: serializer.fromJson<DateTime>(json['parkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'parkedId': serializer.toJson<String>(parkedId),
      'userId': serializer.toJson<String>(userId),
      'cartPayloadJson': serializer.toJson<String>(cartPayloadJson),
      'parkedAt': serializer.toJson<DateTime>(parkedAt),
    };
  }

  ParkedCart copyWith({
    String? parkedId,
    String? userId,
    String? cartPayloadJson,
    DateTime? parkedAt,
  }) => ParkedCart(
    parkedId: parkedId ?? this.parkedId,
    userId: userId ?? this.userId,
    cartPayloadJson: cartPayloadJson ?? this.cartPayloadJson,
    parkedAt: parkedAt ?? this.parkedAt,
  );
  ParkedCart copyWithCompanion(ParkedCartsCompanion data) {
    return ParkedCart(
      parkedId: data.parkedId.present ? data.parkedId.value : this.parkedId,
      userId: data.userId.present ? data.userId.value : this.userId,
      cartPayloadJson: data.cartPayloadJson.present
          ? data.cartPayloadJson.value
          : this.cartPayloadJson,
      parkedAt: data.parkedAt.present ? data.parkedAt.value : this.parkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParkedCart(')
          ..write('parkedId: $parkedId, ')
          ..write('userId: $userId, ')
          ..write('cartPayloadJson: $cartPayloadJson, ')
          ..write('parkedAt: $parkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(parkedId, userId, cartPayloadJson, parkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParkedCart &&
          other.parkedId == this.parkedId &&
          other.userId == this.userId &&
          other.cartPayloadJson == this.cartPayloadJson &&
          other.parkedAt == this.parkedAt);
}

class ParkedCartsCompanion extends UpdateCompanion<ParkedCart> {
  final Value<String> parkedId;
  final Value<String> userId;
  final Value<String> cartPayloadJson;
  final Value<DateTime> parkedAt;
  final Value<int> rowid;
  const ParkedCartsCompanion({
    this.parkedId = const Value.absent(),
    this.userId = const Value.absent(),
    this.cartPayloadJson = const Value.absent(),
    this.parkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParkedCartsCompanion.insert({
    required String parkedId,
    required String userId,
    required String cartPayloadJson,
    this.parkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : parkedId = Value(parkedId),
       userId = Value(userId),
       cartPayloadJson = Value(cartPayloadJson);
  static Insertable<ParkedCart> custom({
    Expression<String>? parkedId,
    Expression<String>? userId,
    Expression<String>? cartPayloadJson,
    Expression<DateTime>? parkedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (parkedId != null) 'parked_id': parkedId,
      if (userId != null) 'user_id': userId,
      if (cartPayloadJson != null) 'cart_payload_json': cartPayloadJson,
      if (parkedAt != null) 'parked_at': parkedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParkedCartsCompanion copyWith({
    Value<String>? parkedId,
    Value<String>? userId,
    Value<String>? cartPayloadJson,
    Value<DateTime>? parkedAt,
    Value<int>? rowid,
  }) {
    return ParkedCartsCompanion(
      parkedId: parkedId ?? this.parkedId,
      userId: userId ?? this.userId,
      cartPayloadJson: cartPayloadJson ?? this.cartPayloadJson,
      parkedAt: parkedAt ?? this.parkedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (parkedId.present) {
      map['parked_id'] = Variable<String>(parkedId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (cartPayloadJson.present) {
      map['cart_payload_json'] = Variable<String>(cartPayloadJson.value);
    }
    if (parkedAt.present) {
      map['parked_at'] = Variable<DateTime>(parkedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParkedCartsCompanion(')
          ..write('parkedId: $parkedId, ')
          ..write('userId: $userId, ')
          ..write('cartPayloadJson: $cartPayloadJson, ')
          ..write('parkedAt: $parkedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnsClaimsTable extends ReturnsClaims
    with TableInfo<$ReturnsClaimsTable, ReturnsClaim> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnsClaimsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _claimIdMeta = const VerificationMeta(
    'claimId',
  );
  @override
  late final GeneratedColumn<String> claimId = GeneratedColumn<String>(
    'claim_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _claimTypeMeta = const VerificationMeta(
    'claimType',
  );
  @override
  late final GeneratedColumn<String> claimType = GeneratedColumn<String>(
    'claim_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceInvoiceIdMeta =
      const VerificationMeta('referenceInvoiceId');
  @override
  late final GeneratedColumn<String> referenceInvoiceId =
      GeneratedColumn<String>(
        'reference_invoice_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _initiatedByMeta = const VerificationMeta(
    'initiatedBy',
  );
  @override
  late final GeneratedColumn<String> initiatedBy = GeneratedColumn<String>(
    'initiated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING_APPROVAL'),
  );
  static const VerificationMeta _refundMethodMeta = const VerificationMeta(
    'refundMethod',
  );
  @override
  late final GeneratedColumn<String> refundMethod = GeneratedColumn<String>(
    'refund_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approvedAtMeta = const VerificationMeta(
    'approvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> approvedAt = GeneratedColumn<DateTime>(
    'approved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    claimId,
    claimType,
    referenceInvoiceId,
    initiatedBy,
    status,
    refundMethod,
    approvedBy,
    approvedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'returns_claims';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReturnsClaim> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('claim_id')) {
      context.handle(
        _claimIdMeta,
        claimId.isAcceptableOrUnknown(data['claim_id']!, _claimIdMeta),
      );
    } else if (isInserting) {
      context.missing(_claimIdMeta);
    }
    if (data.containsKey('claim_type')) {
      context.handle(
        _claimTypeMeta,
        claimType.isAcceptableOrUnknown(data['claim_type']!, _claimTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_claimTypeMeta);
    }
    if (data.containsKey('reference_invoice_id')) {
      context.handle(
        _referenceInvoiceIdMeta,
        referenceInvoiceId.isAcceptableOrUnknown(
          data['reference_invoice_id']!,
          _referenceInvoiceIdMeta,
        ),
      );
    }
    if (data.containsKey('initiated_by')) {
      context.handle(
        _initiatedByMeta,
        initiatedBy.isAcceptableOrUnknown(
          data['initiated_by']!,
          _initiatedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initiatedByMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('refund_method')) {
      context.handle(
        _refundMethodMeta,
        refundMethod.isAcceptableOrUnknown(
          data['refund_method']!,
          _refundMethodMeta,
        ),
      );
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('approved_at')) {
      context.handle(
        _approvedAtMeta,
        approvedAt.isAcceptableOrUnknown(data['approved_at']!, _approvedAtMeta),
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
  Set<GeneratedColumn> get $primaryKey => {claimId};
  @override
  ReturnsClaim map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnsClaim(
      claimId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}claim_id'],
      )!,
      claimType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}claim_type'],
      )!,
      referenceInvoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_invoice_id'],
      ),
      initiatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initiated_by'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      refundMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refund_method'],
      ),
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      ),
      approvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}approved_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReturnsClaimsTable createAlias(String alias) {
    return $ReturnsClaimsTable(attachedDatabase, alias);
  }
}

class ReturnsClaim extends DataClass implements Insertable<ReturnsClaim> {
  final String claimId;
  final String claimType;
  final String? referenceInvoiceId;
  final String initiatedBy;
  final String status;
  final String? refundMethod;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime createdAt;
  const ReturnsClaim({
    required this.claimId,
    required this.claimType,
    this.referenceInvoiceId,
    required this.initiatedBy,
    required this.status,
    this.refundMethod,
    this.approvedBy,
    this.approvedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['claim_id'] = Variable<String>(claimId);
    map['claim_type'] = Variable<String>(claimType);
    if (!nullToAbsent || referenceInvoiceId != null) {
      map['reference_invoice_id'] = Variable<String>(referenceInvoiceId);
    }
    map['initiated_by'] = Variable<String>(initiatedBy);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || refundMethod != null) {
      map['refund_method'] = Variable<String>(refundMethod);
    }
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<String>(approvedBy);
    }
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<DateTime>(approvedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReturnsClaimsCompanion toCompanion(bool nullToAbsent) {
    return ReturnsClaimsCompanion(
      claimId: Value(claimId),
      claimType: Value(claimType),
      referenceInvoiceId: referenceInvoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceInvoiceId),
      initiatedBy: Value(initiatedBy),
      status: Value(status),
      refundMethod: refundMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(refundMethod),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ReturnsClaim.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnsClaim(
      claimId: serializer.fromJson<String>(json['claimId']),
      claimType: serializer.fromJson<String>(json['claimType']),
      referenceInvoiceId: serializer.fromJson<String?>(
        json['referenceInvoiceId'],
      ),
      initiatedBy: serializer.fromJson<String>(json['initiatedBy']),
      status: serializer.fromJson<String>(json['status']),
      refundMethod: serializer.fromJson<String?>(json['refundMethod']),
      approvedBy: serializer.fromJson<String?>(json['approvedBy']),
      approvedAt: serializer.fromJson<DateTime?>(json['approvedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'claimId': serializer.toJson<String>(claimId),
      'claimType': serializer.toJson<String>(claimType),
      'referenceInvoiceId': serializer.toJson<String?>(referenceInvoiceId),
      'initiatedBy': serializer.toJson<String>(initiatedBy),
      'status': serializer.toJson<String>(status),
      'refundMethod': serializer.toJson<String?>(refundMethod),
      'approvedBy': serializer.toJson<String?>(approvedBy),
      'approvedAt': serializer.toJson<DateTime?>(approvedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReturnsClaim copyWith({
    String? claimId,
    String? claimType,
    Value<String?> referenceInvoiceId = const Value.absent(),
    String? initiatedBy,
    String? status,
    Value<String?> refundMethod = const Value.absent(),
    Value<String?> approvedBy = const Value.absent(),
    Value<DateTime?> approvedAt = const Value.absent(),
    DateTime? createdAt,
  }) => ReturnsClaim(
    claimId: claimId ?? this.claimId,
    claimType: claimType ?? this.claimType,
    referenceInvoiceId: referenceInvoiceId.present
        ? referenceInvoiceId.value
        : this.referenceInvoiceId,
    initiatedBy: initiatedBy ?? this.initiatedBy,
    status: status ?? this.status,
    refundMethod: refundMethod.present ? refundMethod.value : this.refundMethod,
    approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
    approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ReturnsClaim copyWithCompanion(ReturnsClaimsCompanion data) {
    return ReturnsClaim(
      claimId: data.claimId.present ? data.claimId.value : this.claimId,
      claimType: data.claimType.present ? data.claimType.value : this.claimType,
      referenceInvoiceId: data.referenceInvoiceId.present
          ? data.referenceInvoiceId.value
          : this.referenceInvoiceId,
      initiatedBy: data.initiatedBy.present
          ? data.initiatedBy.value
          : this.initiatedBy,
      status: data.status.present ? data.status.value : this.status,
      refundMethod: data.refundMethod.present
          ? data.refundMethod.value
          : this.refundMethod,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      approvedAt: data.approvedAt.present
          ? data.approvedAt.value
          : this.approvedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnsClaim(')
          ..write('claimId: $claimId, ')
          ..write('claimType: $claimType, ')
          ..write('referenceInvoiceId: $referenceInvoiceId, ')
          ..write('initiatedBy: $initiatedBy, ')
          ..write('status: $status, ')
          ..write('refundMethod: $refundMethod, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    claimId,
    claimType,
    referenceInvoiceId,
    initiatedBy,
    status,
    refundMethod,
    approvedBy,
    approvedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnsClaim &&
          other.claimId == this.claimId &&
          other.claimType == this.claimType &&
          other.referenceInvoiceId == this.referenceInvoiceId &&
          other.initiatedBy == this.initiatedBy &&
          other.status == this.status &&
          other.refundMethod == this.refundMethod &&
          other.approvedBy == this.approvedBy &&
          other.approvedAt == this.approvedAt &&
          other.createdAt == this.createdAt);
}

class ReturnsClaimsCompanion extends UpdateCompanion<ReturnsClaim> {
  final Value<String> claimId;
  final Value<String> claimType;
  final Value<String?> referenceInvoiceId;
  final Value<String> initiatedBy;
  final Value<String> status;
  final Value<String?> refundMethod;
  final Value<String?> approvedBy;
  final Value<DateTime?> approvedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReturnsClaimsCompanion({
    this.claimId = const Value.absent(),
    this.claimType = const Value.absent(),
    this.referenceInvoiceId = const Value.absent(),
    this.initiatedBy = const Value.absent(),
    this.status = const Value.absent(),
    this.refundMethod = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnsClaimsCompanion.insert({
    required String claimId,
    required String claimType,
    this.referenceInvoiceId = const Value.absent(),
    required String initiatedBy,
    this.status = const Value.absent(),
    this.refundMethod = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : claimId = Value(claimId),
       claimType = Value(claimType),
       initiatedBy = Value(initiatedBy);
  static Insertable<ReturnsClaim> custom({
    Expression<String>? claimId,
    Expression<String>? claimType,
    Expression<String>? referenceInvoiceId,
    Expression<String>? initiatedBy,
    Expression<String>? status,
    Expression<String>? refundMethod,
    Expression<String>? approvedBy,
    Expression<DateTime>? approvedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (claimId != null) 'claim_id': claimId,
      if (claimType != null) 'claim_type': claimType,
      if (referenceInvoiceId != null)
        'reference_invoice_id': referenceInvoiceId,
      if (initiatedBy != null) 'initiated_by': initiatedBy,
      if (status != null) 'status': status,
      if (refundMethod != null) 'refund_method': refundMethod,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnsClaimsCompanion copyWith({
    Value<String>? claimId,
    Value<String>? claimType,
    Value<String?>? referenceInvoiceId,
    Value<String>? initiatedBy,
    Value<String>? status,
    Value<String?>? refundMethod,
    Value<String?>? approvedBy,
    Value<DateTime?>? approvedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReturnsClaimsCompanion(
      claimId: claimId ?? this.claimId,
      claimType: claimType ?? this.claimType,
      referenceInvoiceId: referenceInvoiceId ?? this.referenceInvoiceId,
      initiatedBy: initiatedBy ?? this.initiatedBy,
      status: status ?? this.status,
      refundMethod: refundMethod ?? this.refundMethod,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (claimId.present) {
      map['claim_id'] = Variable<String>(claimId.value);
    }
    if (claimType.present) {
      map['claim_type'] = Variable<String>(claimType.value);
    }
    if (referenceInvoiceId.present) {
      map['reference_invoice_id'] = Variable<String>(referenceInvoiceId.value);
    }
    if (initiatedBy.present) {
      map['initiated_by'] = Variable<String>(initiatedBy.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (refundMethod.present) {
      map['refund_method'] = Variable<String>(refundMethod.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<DateTime>(approvedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnsClaimsCompanion(')
          ..write('claimId: $claimId, ')
          ..write('claimType: $claimType, ')
          ..write('referenceInvoiceId: $referenceInvoiceId, ')
          ..write('initiatedBy: $initiatedBy, ')
          ..write('status: $status, ')
          ..write('refundMethod: $refundMethod, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredLanguageMeta = const VerificationMeta(
    'preferredLanguage',
  );
  @override
  late final GeneratedColumn<String> preferredLanguage =
      GeneratedColumn<String>(
        'preferred_language',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('en'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    username,
    passwordHash,
    pinHash,
    role,
    preferredLanguage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('preferred_language')) {
      context.handle(
        _preferredLanguageMeta,
        preferredLanguage.isAcceptableOrUnknown(
          data['preferred_language']!,
          _preferredLanguageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      preferredLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_language'],
      )!,
    );
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(attachedDatabase, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String id;
  final String fullName;
  final String username;
  final String passwordHash;
  final String pinHash;
  final String role;
  final String preferredLanguage;
  const LocalUser({
    required this.id,
    required this.fullName,
    required this.username,
    required this.passwordHash,
    required this.pinHash,
    required this.role,
    required this.preferredLanguage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['pin_hash'] = Variable<String>(pinHash);
    map['role'] = Variable<String>(role);
    map['preferred_language'] = Variable<String>(preferredLanguage);
    return map;
  }

  LocalUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      username: Value(username),
      passwordHash: Value(passwordHash),
      pinHash: Value(pinHash),
      role: Value(role),
      preferredLanguage: Value(preferredLanguage),
    );
  }

  factory LocalUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      role: serializer.fromJson<String>(json['role']),
      preferredLanguage: serializer.fromJson<String>(json['preferredLanguage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'pinHash': serializer.toJson<String>(pinHash),
      'role': serializer.toJson<String>(role),
      'preferredLanguage': serializer.toJson<String>(preferredLanguage),
    };
  }

  LocalUser copyWith({
    String? id,
    String? fullName,
    String? username,
    String? passwordHash,
    String? pinHash,
    String? role,
    String? preferredLanguage,
  }) => LocalUser(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
    pinHash: pinHash ?? this.pinHash,
    role: role ?? this.role,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
  );
  LocalUser copyWithCompanion(LocalUsersCompanion data) {
    return LocalUser(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      role: data.role.present ? data.role.value : this.role,
      preferredLanguage: data.preferredLanguage.present
          ? data.preferredLanguage.value
          : this.preferredLanguage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('pinHash: $pinHash, ')
          ..write('role: $role, ')
          ..write('preferredLanguage: $preferredLanguage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    username,
    passwordHash,
    pinHash,
    role,
    preferredLanguage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.pinHash == this.pinHash &&
          other.role == this.role &&
          other.preferredLanguage == this.preferredLanguage);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> pinHash;
  final Value<String> role;
  final Value<String> preferredLanguage;
  final Value<int> rowid;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.role = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUsersCompanion.insert({
    required String id,
    required String fullName,
    required String username,
    required String passwordHash,
    required String pinHash,
    required String role,
    this.preferredLanguage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       username = Value(username),
       passwordHash = Value(passwordHash),
       pinHash = Value(pinHash),
       role = Value(role);
  static Insertable<LocalUser> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? pinHash,
    Expression<String>? role,
    Expression<String>? preferredLanguage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (pinHash != null) 'pin_hash': pinHash,
      if (role != null) 'role': role,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String>? username,
    Value<String>? passwordHash,
    Value<String>? pinHash,
    Value<String>? role,
    Value<String>? preferredLanguage,
    Value<int>? rowid,
  }) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      pinHash: pinHash ?? this.pinHash,
      role: role ?? this.role,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (preferredLanguage.present) {
      map['preferred_language'] = Variable<String>(preferredLanguage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('pinHash: $pinHash, ')
          ..write('role: $role, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppConfigTable extends AppConfig
    with TableInfo<$AppConfigTable, AppConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _configKeyMeta = const VerificationMeta(
    'configKey',
  );
  @override
  late final GeneratedColumn<String> configKey = GeneratedColumn<String>(
    'config_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configValueMeta = const VerificationMeta(
    'configValue',
  );
  @override
  late final GeneratedColumn<String> configValue = GeneratedColumn<String>(
    'config_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [configKey, configValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_config';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppConfigData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('config_key')) {
      context.handle(
        _configKeyMeta,
        configKey.isAcceptableOrUnknown(data['config_key']!, _configKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_configKeyMeta);
    }
    if (data.containsKey('config_value')) {
      context.handle(
        _configValueMeta,
        configValue.isAcceptableOrUnknown(
          data['config_value']!,
          _configValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_configValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {configKey};
  @override
  AppConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppConfigData(
      configKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_key'],
      )!,
      configValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_value'],
      )!,
    );
  }

  @override
  $AppConfigTable createAlias(String alias) {
    return $AppConfigTable(attachedDatabase, alias);
  }
}

class AppConfigData extends DataClass implements Insertable<AppConfigData> {
  final String configKey;
  final String configValue;
  const AppConfigData({required this.configKey, required this.configValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['config_key'] = Variable<String>(configKey);
    map['config_value'] = Variable<String>(configValue);
    return map;
  }

  AppConfigCompanion toCompanion(bool nullToAbsent) {
    return AppConfigCompanion(
      configKey: Value(configKey),
      configValue: Value(configValue),
    );
  }

  factory AppConfigData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppConfigData(
      configKey: serializer.fromJson<String>(json['configKey']),
      configValue: serializer.fromJson<String>(json['configValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'configKey': serializer.toJson<String>(configKey),
      'configValue': serializer.toJson<String>(configValue),
    };
  }

  AppConfigData copyWith({String? configKey, String? configValue}) =>
      AppConfigData(
        configKey: configKey ?? this.configKey,
        configValue: configValue ?? this.configValue,
      );
  AppConfigData copyWithCompanion(AppConfigCompanion data) {
    return AppConfigData(
      configKey: data.configKey.present ? data.configKey.value : this.configKey,
      configValue: data.configValue.present
          ? data.configValue.value
          : this.configValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppConfigData(')
          ..write('configKey: $configKey, ')
          ..write('configValue: $configValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(configKey, configValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppConfigData &&
          other.configKey == this.configKey &&
          other.configValue == this.configValue);
}

class AppConfigCompanion extends UpdateCompanion<AppConfigData> {
  final Value<String> configKey;
  final Value<String> configValue;
  final Value<int> rowid;
  const AppConfigCompanion({
    this.configKey = const Value.absent(),
    this.configValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppConfigCompanion.insert({
    required String configKey,
    required String configValue,
    this.rowid = const Value.absent(),
  }) : configKey = Value(configKey),
       configValue = Value(configValue);
  static Insertable<AppConfigData> custom({
    Expression<String>? configKey,
    Expression<String>? configValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (configKey != null) 'config_key': configKey,
      if (configValue != null) 'config_value': configValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppConfigCompanion copyWith({
    Value<String>? configKey,
    Value<String>? configValue,
    Value<int>? rowid,
  }) {
    return AppConfigCompanion(
      configKey: configKey ?? this.configKey,
      configValue: configValue ?? this.configValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (configKey.present) {
      map['config_key'] = Variable<String>(configKey.value);
    }
    if (configValue.present) {
      map['config_value'] = Variable<String>(configValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppConfigCompanion(')
          ..write('configKey: $configKey, ')
          ..write('configValue: $configValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AutoPartsTable extends AutoParts
    with TableInfo<$AutoPartsTable, AutoPart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AutoPartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partNameMeta = const VerificationMeta(
    'partName',
  );
  @override
  late final GeneratedColumn<String> partName = GeneratedColumn<String>(
    'part_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oemNumberMeta = const VerificationMeta(
    'oemNumber',
  );
  @override
  late final GeneratedColumn<String> oemNumber = GeneratedColumn<String>(
    'oem_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rackLocationMeta = const VerificationMeta(
    'rackLocation',
  );
  @override
  late final GeneratedColumn<String> rackLocation = GeneratedColumn<String>(
    'rack_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minReorderLevelMeta = const VerificationMeta(
    'minReorderLevel',
  );
  @override
  late final GeneratedColumn<int> minReorderLevel = GeneratedColumn<int>(
    'min_reorder_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    partId,
    partName,
    oemNumber,
    model,
    rackLocation,
    minReorderLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auto_parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AutoPart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('part_name')) {
      context.handle(
        _partNameMeta,
        partName.isAcceptableOrUnknown(data['part_name']!, _partNameMeta),
      );
    } else if (isInserting) {
      context.missing(_partNameMeta);
    }
    if (data.containsKey('oem_number')) {
      context.handle(
        _oemNumberMeta,
        oemNumber.isAcceptableOrUnknown(data['oem_number']!, _oemNumberMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('rack_location')) {
      context.handle(
        _rackLocationMeta,
        rackLocation.isAcceptableOrUnknown(
          data['rack_location']!,
          _rackLocationMeta,
        ),
      );
    }
    if (data.containsKey('min_reorder_level')) {
      context.handle(
        _minReorderLevelMeta,
        minReorderLevel.isAcceptableOrUnknown(
          data['min_reorder_level']!,
          _minReorderLevelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {partId};
  @override
  AutoPart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AutoPart(
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      )!,
      partName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_name'],
      )!,
      oemNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oem_number'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      rackLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rack_location'],
      ),
      minReorderLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_reorder_level'],
      )!,
    );
  }

  @override
  $AutoPartsTable createAlias(String alias) {
    return $AutoPartsTable(attachedDatabase, alias);
  }
}

class AutoPart extends DataClass implements Insertable<AutoPart> {
  final String partId;
  final String partName;
  final String? oemNumber;
  final String? model;
  final String? rackLocation;
  final int minReorderLevel;
  const AutoPart({
    required this.partId,
    required this.partName,
    this.oemNumber,
    this.model,
    this.rackLocation,
    required this.minReorderLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['part_id'] = Variable<String>(partId);
    map['part_name'] = Variable<String>(partName);
    if (!nullToAbsent || oemNumber != null) {
      map['oem_number'] = Variable<String>(oemNumber);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || rackLocation != null) {
      map['rack_location'] = Variable<String>(rackLocation);
    }
    map['min_reorder_level'] = Variable<int>(minReorderLevel);
    return map;
  }

  AutoPartsCompanion toCompanion(bool nullToAbsent) {
    return AutoPartsCompanion(
      partId: Value(partId),
      partName: Value(partName),
      oemNumber: oemNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(oemNumber),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      rackLocation: rackLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(rackLocation),
      minReorderLevel: Value(minReorderLevel),
    );
  }

  factory AutoPart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AutoPart(
      partId: serializer.fromJson<String>(json['partId']),
      partName: serializer.fromJson<String>(json['partName']),
      oemNumber: serializer.fromJson<String?>(json['oemNumber']),
      model: serializer.fromJson<String?>(json['model']),
      rackLocation: serializer.fromJson<String?>(json['rackLocation']),
      minReorderLevel: serializer.fromJson<int>(json['minReorderLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'partId': serializer.toJson<String>(partId),
      'partName': serializer.toJson<String>(partName),
      'oemNumber': serializer.toJson<String?>(oemNumber),
      'model': serializer.toJson<String?>(model),
      'rackLocation': serializer.toJson<String?>(rackLocation),
      'minReorderLevel': serializer.toJson<int>(minReorderLevel),
    };
  }

  AutoPart copyWith({
    String? partId,
    String? partName,
    Value<String?> oemNumber = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<String?> rackLocation = const Value.absent(),
    int? minReorderLevel,
  }) => AutoPart(
    partId: partId ?? this.partId,
    partName: partName ?? this.partName,
    oemNumber: oemNumber.present ? oemNumber.value : this.oemNumber,
    model: model.present ? model.value : this.model,
    rackLocation: rackLocation.present ? rackLocation.value : this.rackLocation,
    minReorderLevel: minReorderLevel ?? this.minReorderLevel,
  );
  AutoPart copyWithCompanion(AutoPartsCompanion data) {
    return AutoPart(
      partId: data.partId.present ? data.partId.value : this.partId,
      partName: data.partName.present ? data.partName.value : this.partName,
      oemNumber: data.oemNumber.present ? data.oemNumber.value : this.oemNumber,
      model: data.model.present ? data.model.value : this.model,
      rackLocation: data.rackLocation.present
          ? data.rackLocation.value
          : this.rackLocation,
      minReorderLevel: data.minReorderLevel.present
          ? data.minReorderLevel.value
          : this.minReorderLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AutoPart(')
          ..write('partId: $partId, ')
          ..write('partName: $partName, ')
          ..write('oemNumber: $oemNumber, ')
          ..write('model: $model, ')
          ..write('rackLocation: $rackLocation, ')
          ..write('minReorderLevel: $minReorderLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    partId,
    partName,
    oemNumber,
    model,
    rackLocation,
    minReorderLevel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AutoPart &&
          other.partId == this.partId &&
          other.partName == this.partName &&
          other.oemNumber == this.oemNumber &&
          other.model == this.model &&
          other.rackLocation == this.rackLocation &&
          other.minReorderLevel == this.minReorderLevel);
}

class AutoPartsCompanion extends UpdateCompanion<AutoPart> {
  final Value<String> partId;
  final Value<String> partName;
  final Value<String?> oemNumber;
  final Value<String?> model;
  final Value<String?> rackLocation;
  final Value<int> minReorderLevel;
  final Value<int> rowid;
  const AutoPartsCompanion({
    this.partId = const Value.absent(),
    this.partName = const Value.absent(),
    this.oemNumber = const Value.absent(),
    this.model = const Value.absent(),
    this.rackLocation = const Value.absent(),
    this.minReorderLevel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AutoPartsCompanion.insert({
    required String partId,
    required String partName,
    this.oemNumber = const Value.absent(),
    this.model = const Value.absent(),
    this.rackLocation = const Value.absent(),
    this.minReorderLevel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : partId = Value(partId),
       partName = Value(partName);
  static Insertable<AutoPart> custom({
    Expression<String>? partId,
    Expression<String>? partName,
    Expression<String>? oemNumber,
    Expression<String>? model,
    Expression<String>? rackLocation,
    Expression<int>? minReorderLevel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (partId != null) 'part_id': partId,
      if (partName != null) 'part_name': partName,
      if (oemNumber != null) 'oem_number': oemNumber,
      if (model != null) 'model': model,
      if (rackLocation != null) 'rack_location': rackLocation,
      if (minReorderLevel != null) 'min_reorder_level': minReorderLevel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AutoPartsCompanion copyWith({
    Value<String>? partId,
    Value<String>? partName,
    Value<String?>? oemNumber,
    Value<String?>? model,
    Value<String?>? rackLocation,
    Value<int>? minReorderLevel,
    Value<int>? rowid,
  }) {
    return AutoPartsCompanion(
      partId: partId ?? this.partId,
      partName: partName ?? this.partName,
      oemNumber: oemNumber ?? this.oemNumber,
      model: model ?? this.model,
      rackLocation: rackLocation ?? this.rackLocation,
      minReorderLevel: minReorderLevel ?? this.minReorderLevel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (partName.present) {
      map['part_name'] = Variable<String>(partName.value);
    }
    if (oemNumber.present) {
      map['oem_number'] = Variable<String>(oemNumber.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (rackLocation.present) {
      map['rack_location'] = Variable<String>(rackLocation.value);
    }
    if (minReorderLevel.present) {
      map['min_reorder_level'] = Variable<int>(minReorderLevel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AutoPartsCompanion(')
          ..write('partId: $partId, ')
          ..write('partName: $partName, ')
          ..write('oemNumber: $oemNumber, ')
          ..write('model: $model, ')
          ..write('rackLocation: $rackLocation, ')
          ..write('minReorderLevel: $minReorderLevel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FifoInventoryBatchesTable extends FifoInventoryBatches
    with TableInfo<$FifoInventoryBatchesTable, FifoInventoryBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FifoInventoryBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalQuantityMeta = const VerificationMeta(
    'originalQuantity',
  );
  @override
  late final GeneratedColumn<int> originalQuantity = GeneratedColumn<int>(
    'original_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingQuantityMeta = const VerificationMeta(
    'remainingQuantity',
  );
  @override
  late final GeneratedColumn<int> remainingQuantity = GeneratedColumn<int>(
    'remaining_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitLandedCostMeta = const VerificationMeta(
    'unitLandedCost',
  );
  @override
  late final GeneratedColumn<double> unitLandedCost = GeneratedColumn<double>(
    'unit_landed_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    batchId,
    partId,
    originalQuantity,
    remainingQuantity,
    unitLandedCost,
    supplierId,
    receivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fifo_inventory_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<FifoInventoryBatche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('original_quantity')) {
      context.handle(
        _originalQuantityMeta,
        originalQuantity.isAcceptableOrUnknown(
          data['original_quantity']!,
          _originalQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalQuantityMeta);
    }
    if (data.containsKey('remaining_quantity')) {
      context.handle(
        _remainingQuantityMeta,
        remainingQuantity.isAcceptableOrUnknown(
          data['remaining_quantity']!,
          _remainingQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingQuantityMeta);
    }
    if (data.containsKey('unit_landed_cost')) {
      context.handle(
        _unitLandedCostMeta,
        unitLandedCost.isAcceptableOrUnknown(
          data['unit_landed_cost']!,
          _unitLandedCostMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitLandedCostMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {batchId};
  @override
  FifoInventoryBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FifoInventoryBatche(
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      )!,
      originalQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_quantity'],
      )!,
      remainingQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_quantity'],
      )!,
      unitLandedCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_landed_cost'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $FifoInventoryBatchesTable createAlias(String alias) {
    return $FifoInventoryBatchesTable(attachedDatabase, alias);
  }
}

class FifoInventoryBatche extends DataClass
    implements Insertable<FifoInventoryBatche> {
  final String batchId;
  final String partId;
  final int originalQuantity;
  final int remainingQuantity;
  final double unitLandedCost;
  final String? supplierId;
  final DateTime receivedAt;
  const FifoInventoryBatche({
    required this.batchId,
    required this.partId,
    required this.originalQuantity,
    required this.remainingQuantity,
    required this.unitLandedCost,
    this.supplierId,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['batch_id'] = Variable<String>(batchId);
    map['part_id'] = Variable<String>(partId);
    map['original_quantity'] = Variable<int>(originalQuantity);
    map['remaining_quantity'] = Variable<int>(remainingQuantity);
    map['unit_landed_cost'] = Variable<double>(unitLandedCost);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  FifoInventoryBatchesCompanion toCompanion(bool nullToAbsent) {
    return FifoInventoryBatchesCompanion(
      batchId: Value(batchId),
      partId: Value(partId),
      originalQuantity: Value(originalQuantity),
      remainingQuantity: Value(remainingQuantity),
      unitLandedCost: Value(unitLandedCost),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      receivedAt: Value(receivedAt),
    );
  }

  factory FifoInventoryBatche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FifoInventoryBatche(
      batchId: serializer.fromJson<String>(json['batchId']),
      partId: serializer.fromJson<String>(json['partId']),
      originalQuantity: serializer.fromJson<int>(json['originalQuantity']),
      remainingQuantity: serializer.fromJson<int>(json['remainingQuantity']),
      unitLandedCost: serializer.fromJson<double>(json['unitLandedCost']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'batchId': serializer.toJson<String>(batchId),
      'partId': serializer.toJson<String>(partId),
      'originalQuantity': serializer.toJson<int>(originalQuantity),
      'remainingQuantity': serializer.toJson<int>(remainingQuantity),
      'unitLandedCost': serializer.toJson<double>(unitLandedCost),
      'supplierId': serializer.toJson<String?>(supplierId),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  FifoInventoryBatche copyWith({
    String? batchId,
    String? partId,
    int? originalQuantity,
    int? remainingQuantity,
    double? unitLandedCost,
    Value<String?> supplierId = const Value.absent(),
    DateTime? receivedAt,
  }) => FifoInventoryBatche(
    batchId: batchId ?? this.batchId,
    partId: partId ?? this.partId,
    originalQuantity: originalQuantity ?? this.originalQuantity,
    remainingQuantity: remainingQuantity ?? this.remainingQuantity,
    unitLandedCost: unitLandedCost ?? this.unitLandedCost,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    receivedAt: receivedAt ?? this.receivedAt,
  );
  FifoInventoryBatche copyWithCompanion(FifoInventoryBatchesCompanion data) {
    return FifoInventoryBatche(
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      partId: data.partId.present ? data.partId.value : this.partId,
      originalQuantity: data.originalQuantity.present
          ? data.originalQuantity.value
          : this.originalQuantity,
      remainingQuantity: data.remainingQuantity.present
          ? data.remainingQuantity.value
          : this.remainingQuantity,
      unitLandedCost: data.unitLandedCost.present
          ? data.unitLandedCost.value
          : this.unitLandedCost,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FifoInventoryBatche(')
          ..write('batchId: $batchId, ')
          ..write('partId: $partId, ')
          ..write('originalQuantity: $originalQuantity, ')
          ..write('remainingQuantity: $remainingQuantity, ')
          ..write('unitLandedCost: $unitLandedCost, ')
          ..write('supplierId: $supplierId, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    batchId,
    partId,
    originalQuantity,
    remainingQuantity,
    unitLandedCost,
    supplierId,
    receivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FifoInventoryBatche &&
          other.batchId == this.batchId &&
          other.partId == this.partId &&
          other.originalQuantity == this.originalQuantity &&
          other.remainingQuantity == this.remainingQuantity &&
          other.unitLandedCost == this.unitLandedCost &&
          other.supplierId == this.supplierId &&
          other.receivedAt == this.receivedAt);
}

class FifoInventoryBatchesCompanion
    extends UpdateCompanion<FifoInventoryBatche> {
  final Value<String> batchId;
  final Value<String> partId;
  final Value<int> originalQuantity;
  final Value<int> remainingQuantity;
  final Value<double> unitLandedCost;
  final Value<String?> supplierId;
  final Value<DateTime> receivedAt;
  final Value<int> rowid;
  const FifoInventoryBatchesCompanion({
    this.batchId = const Value.absent(),
    this.partId = const Value.absent(),
    this.originalQuantity = const Value.absent(),
    this.remainingQuantity = const Value.absent(),
    this.unitLandedCost = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FifoInventoryBatchesCompanion.insert({
    required String batchId,
    required String partId,
    required int originalQuantity,
    required int remainingQuantity,
    required double unitLandedCost,
    this.supplierId = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : batchId = Value(batchId),
       partId = Value(partId),
       originalQuantity = Value(originalQuantity),
       remainingQuantity = Value(remainingQuantity),
       unitLandedCost = Value(unitLandedCost);
  static Insertable<FifoInventoryBatche> custom({
    Expression<String>? batchId,
    Expression<String>? partId,
    Expression<int>? originalQuantity,
    Expression<int>? remainingQuantity,
    Expression<double>? unitLandedCost,
    Expression<String>? supplierId,
    Expression<DateTime>? receivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (batchId != null) 'batch_id': batchId,
      if (partId != null) 'part_id': partId,
      if (originalQuantity != null) 'original_quantity': originalQuantity,
      if (remainingQuantity != null) 'remaining_quantity': remainingQuantity,
      if (unitLandedCost != null) 'unit_landed_cost': unitLandedCost,
      if (supplierId != null) 'supplier_id': supplierId,
      if (receivedAt != null) 'received_at': receivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FifoInventoryBatchesCompanion copyWith({
    Value<String>? batchId,
    Value<String>? partId,
    Value<int>? originalQuantity,
    Value<int>? remainingQuantity,
    Value<double>? unitLandedCost,
    Value<String?>? supplierId,
    Value<DateTime>? receivedAt,
    Value<int>? rowid,
  }) {
    return FifoInventoryBatchesCompanion(
      batchId: batchId ?? this.batchId,
      partId: partId ?? this.partId,
      originalQuantity: originalQuantity ?? this.originalQuantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      unitLandedCost: unitLandedCost ?? this.unitLandedCost,
      supplierId: supplierId ?? this.supplierId,
      receivedAt: receivedAt ?? this.receivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (originalQuantity.present) {
      map['original_quantity'] = Variable<int>(originalQuantity.value);
    }
    if (remainingQuantity.present) {
      map['remaining_quantity'] = Variable<int>(remainingQuantity.value);
    }
    if (unitLandedCost.present) {
      map['unit_landed_cost'] = Variable<double>(unitLandedCost.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FifoInventoryBatchesCompanion(')
          ..write('batchId: $batchId, ')
          ..write('partId: $partId, ')
          ..write('originalQuantity: $originalQuantity, ')
          ..write('remainingQuantity: $remainingQuantity, ')
          ..write('unitLandedCost: $unitLandedCost, ')
          ..write('supplierId: $supplierId, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsLedgerTable extends AccountsLedger
    with TableInfo<$AccountsLedgerTable, AccountsLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentBalanceMeta = const VerificationMeta(
    'currentBalance',
  );
  @override
  late final GeneratedColumn<double> currentBalance = GeneratedColumn<double>(
    'current_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
    'credit_limit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    accountId,
    accountName,
    accountType,
    currentBalance,
    creditLimit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountsLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('current_balance')) {
      context.handle(
        _currentBalanceMeta,
        currentBalance.isAcceptableOrUnknown(
          data['current_balance']!,
          _currentBalanceMeta,
        ),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId};
  @override
  AccountsLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsLedgerData(
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      currentBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_balance'],
      )!,
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_limit'],
      ),
    );
  }

  @override
  $AccountsLedgerTable createAlias(String alias) {
    return $AccountsLedgerTable(attachedDatabase, alias);
  }
}

class AccountsLedgerData extends DataClass
    implements Insertable<AccountsLedgerData> {
  final String accountId;
  final String accountName;
  final String accountType;
  final double currentBalance;
  final double? creditLimit;
  const AccountsLedgerData({
    required this.accountId,
    required this.accountName,
    required this.accountType,
    required this.currentBalance,
    this.creditLimit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    map['account_name'] = Variable<String>(accountName);
    map['account_type'] = Variable<String>(accountType);
    map['current_balance'] = Variable<double>(currentBalance);
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<double>(creditLimit);
    }
    return map;
  }

  AccountsLedgerCompanion toCompanion(bool nullToAbsent) {
    return AccountsLedgerCompanion(
      accountId: Value(accountId),
      accountName: Value(accountName),
      accountType: Value(accountType),
      currentBalance: Value(currentBalance),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
    );
  }

  factory AccountsLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsLedgerData(
      accountId: serializer.fromJson<String>(json['accountId']),
      accountName: serializer.fromJson<String>(json['accountName']),
      accountType: serializer.fromJson<String>(json['accountType']),
      currentBalance: serializer.fromJson<double>(json['currentBalance']),
      creditLimit: serializer.fromJson<double?>(json['creditLimit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'accountName': serializer.toJson<String>(accountName),
      'accountType': serializer.toJson<String>(accountType),
      'currentBalance': serializer.toJson<double>(currentBalance),
      'creditLimit': serializer.toJson<double?>(creditLimit),
    };
  }

  AccountsLedgerData copyWith({
    String? accountId,
    String? accountName,
    String? accountType,
    double? currentBalance,
    Value<double?> creditLimit = const Value.absent(),
  }) => AccountsLedgerData(
    accountId: accountId ?? this.accountId,
    accountName: accountName ?? this.accountName,
    accountType: accountType ?? this.accountType,
    currentBalance: currentBalance ?? this.currentBalance,
    creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
  );
  AccountsLedgerData copyWithCompanion(AccountsLedgerCompanion data) {
    return AccountsLedgerData(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountName: data.accountName.present
          ? data.accountName.value
          : this.accountName,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountsLedgerData(')
          ..write('accountId: $accountId, ')
          ..write('accountName: $accountName, ')
          ..write('accountType: $accountType, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('creditLimit: $creditLimit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountId,
    accountName,
    accountType,
    currentBalance,
    creditLimit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsLedgerData &&
          other.accountId == this.accountId &&
          other.accountName == this.accountName &&
          other.accountType == this.accountType &&
          other.currentBalance == this.currentBalance &&
          other.creditLimit == this.creditLimit);
}

class AccountsLedgerCompanion extends UpdateCompanion<AccountsLedgerData> {
  final Value<String> accountId;
  final Value<String> accountName;
  final Value<String> accountType;
  final Value<double> currentBalance;
  final Value<double?> creditLimit;
  final Value<int> rowid;
  const AccountsLedgerCompanion({
    this.accountId = const Value.absent(),
    this.accountName = const Value.absent(),
    this.accountType = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsLedgerCompanion.insert({
    required String accountId,
    required String accountName,
    required String accountType,
    this.currentBalance = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       accountName = Value(accountName),
       accountType = Value(accountType);
  static Insertable<AccountsLedgerData> custom({
    Expression<String>? accountId,
    Expression<String>? accountName,
    Expression<String>? accountType,
    Expression<double>? currentBalance,
    Expression<double>? creditLimit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (accountName != null) 'account_name': accountName,
      if (accountType != null) 'account_type': accountType,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsLedgerCompanion copyWith({
    Value<String>? accountId,
    Value<String>? accountName,
    Value<String>? accountType,
    Value<double>? currentBalance,
    Value<double?>? creditLimit,
    Value<int>? rowid,
  }) {
    return AccountsLedgerCompanion(
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      currentBalance: currentBalance ?? this.currentBalance,
      creditLimit: creditLimit ?? this.creditLimit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<double>(currentBalance.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsLedgerCompanion(')
          ..write('accountId: $accountId, ')
          ..write('accountName: $accountName, ')
          ..write('accountType: $accountType, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesInvoicesTable extends SalesInvoices
    with TableInfo<$SalesInvoicesTable, SalesInvoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesInvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _finalAmountMeta = const VerificationMeta(
    'finalAmount',
  );
  @override
  late final GeneratedColumn<double> finalAmount = GeneratedColumn<double>(
    'final_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
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
  List<GeneratedColumn> get $columns => [
    invoiceId,
    customerId,
    totalAmount,
    discount,
    finalAmount,
    createdBy,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales_invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalesInvoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('final_amount')) {
      context.handle(
        _finalAmountMeta,
        finalAmount.isAcceptableOrUnknown(
          data['final_amount']!,
          _finalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_finalAmountMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
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
  Set<GeneratedColumn> get $primaryKey => {invoiceId};
  @override
  SalesInvoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalesInvoice(
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount'],
      )!,
      finalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}final_amount'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SalesInvoicesTable createAlias(String alias) {
    return $SalesInvoicesTable(attachedDatabase, alias);
  }
}

class SalesInvoice extends DataClass implements Insertable<SalesInvoice> {
  final String invoiceId;
  final String? customerId;
  final double totalAmount;
  final double discount;
  final double finalAmount;
  final String createdBy;
  final DateTime createdAt;
  const SalesInvoice({
    required this.invoiceId,
    this.customerId,
    required this.totalAmount,
    required this.discount,
    required this.finalAmount,
    required this.createdBy,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['invoice_id'] = Variable<String>(invoiceId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['discount'] = Variable<double>(discount);
    map['final_amount'] = Variable<double>(finalAmount);
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalesInvoicesCompanion toCompanion(bool nullToAbsent) {
    return SalesInvoicesCompanion(
      invoiceId: Value(invoiceId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      totalAmount: Value(totalAmount),
      discount: Value(discount),
      finalAmount: Value(finalAmount),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
    );
  }

  factory SalesInvoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalesInvoice(
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      discount: serializer.fromJson<double>(json['discount']),
      finalAmount: serializer.fromJson<double>(json['finalAmount']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'invoiceId': serializer.toJson<String>(invoiceId),
      'customerId': serializer.toJson<String?>(customerId),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'discount': serializer.toJson<double>(discount),
      'finalAmount': serializer.toJson<double>(finalAmount),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SalesInvoice copyWith({
    String? invoiceId,
    Value<String?> customerId = const Value.absent(),
    double? totalAmount,
    double? discount,
    double? finalAmount,
    String? createdBy,
    DateTime? createdAt,
  }) => SalesInvoice(
    invoiceId: invoiceId ?? this.invoiceId,
    customerId: customerId.present ? customerId.value : this.customerId,
    totalAmount: totalAmount ?? this.totalAmount,
    discount: discount ?? this.discount,
    finalAmount: finalAmount ?? this.finalAmount,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
  );
  SalesInvoice copyWithCompanion(SalesInvoicesCompanion data) {
    return SalesInvoice(
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      discount: data.discount.present ? data.discount.value : this.discount,
      finalAmount: data.finalAmount.present
          ? data.finalAmount.value
          : this.finalAmount,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalesInvoice(')
          ..write('invoiceId: $invoiceId, ')
          ..write('customerId: $customerId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discount: $discount, ')
          ..write('finalAmount: $finalAmount, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    invoiceId,
    customerId,
    totalAmount,
    discount,
    finalAmount,
    createdBy,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesInvoice &&
          other.invoiceId == this.invoiceId &&
          other.customerId == this.customerId &&
          other.totalAmount == this.totalAmount &&
          other.discount == this.discount &&
          other.finalAmount == this.finalAmount &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt);
}

class SalesInvoicesCompanion extends UpdateCompanion<SalesInvoice> {
  final Value<String> invoiceId;
  final Value<String?> customerId;
  final Value<double> totalAmount;
  final Value<double> discount;
  final Value<double> finalAmount;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SalesInvoicesCompanion({
    this.invoiceId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.discount = const Value.absent(),
    this.finalAmount = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesInvoicesCompanion.insert({
    required String invoiceId,
    this.customerId = const Value.absent(),
    required double totalAmount,
    this.discount = const Value.absent(),
    required double finalAmount,
    required String createdBy,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : invoiceId = Value(invoiceId),
       totalAmount = Value(totalAmount),
       finalAmount = Value(finalAmount),
       createdBy = Value(createdBy);
  static Insertable<SalesInvoice> custom({
    Expression<String>? invoiceId,
    Expression<String>? customerId,
    Expression<double>? totalAmount,
    Expression<double>? discount,
    Expression<double>? finalAmount,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (customerId != null) 'customer_id': customerId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (discount != null) 'discount': discount,
      if (finalAmount != null) 'final_amount': finalAmount,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesInvoicesCompanion copyWith({
    Value<String>? invoiceId,
    Value<String?>? customerId,
    Value<double>? totalAmount,
    Value<double>? discount,
    Value<double>? finalAmount,
    Value<String>? createdBy,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SalesInvoicesCompanion(
      invoiceId: invoiceId ?? this.invoiceId,
      customerId: customerId ?? this.customerId,
      totalAmount: totalAmount ?? this.totalAmount,
      discount: discount ?? this.discount,
      finalAmount: finalAmount ?? this.finalAmount,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (finalAmount.present) {
      map['final_amount'] = Variable<double>(finalAmount.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesInvoicesCompanion(')
          ..write('invoiceId: $invoiceId, ')
          ..write('customerId: $customerId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discount: $discount, ')
          ..write('finalAmount: $finalAmount, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCogsMeta = const VerificationMeta(
    'unitCogs',
  );
  @override
  late final GeneratedColumn<double> unitCogs = GeneratedColumn<double>(
    'unit_cogs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    invoiceId,
    partId,
    batchId,
    quantity,
    unitPrice,
    unitCogs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('unit_cogs')) {
      context.handle(
        _unitCogsMeta,
        unitCogs.isAcceptableOrUnknown(data['unit_cogs']!, _unitCogsMeta),
      );
    } else if (isInserting) {
      context.missing(_unitCogsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  InvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItem(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      unitCogs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_cogs'],
      )!,
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItem extends DataClass implements Insertable<InvoiceItem> {
  final String itemId;
  final String invoiceId;
  final String partId;
  final String batchId;
  final int quantity;
  final double unitPrice;
  final double unitCogs;
  const InvoiceItem({
    required this.itemId,
    required this.invoiceId,
    required this.partId,
    required this.batchId,
    required this.quantity,
    required this.unitPrice,
    required this.unitCogs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['part_id'] = Variable<String>(partId);
    map['batch_id'] = Variable<String>(batchId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['unit_cogs'] = Variable<double>(unitCogs);
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      itemId: Value(itemId),
      invoiceId: Value(invoiceId),
      partId: Value(partId),
      batchId: Value(batchId),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      unitCogs: Value(unitCogs),
    );
  }

  factory InvoiceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItem(
      itemId: serializer.fromJson<String>(json['itemId']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      partId: serializer.fromJson<String>(json['partId']),
      batchId: serializer.fromJson<String>(json['batchId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      unitCogs: serializer.fromJson<double>(json['unitCogs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'partId': serializer.toJson<String>(partId),
      'batchId': serializer.toJson<String>(batchId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'unitCogs': serializer.toJson<double>(unitCogs),
    };
  }

  InvoiceItem copyWith({
    String? itemId,
    String? invoiceId,
    String? partId,
    String? batchId,
    int? quantity,
    double? unitPrice,
    double? unitCogs,
  }) => InvoiceItem(
    itemId: itemId ?? this.itemId,
    invoiceId: invoiceId ?? this.invoiceId,
    partId: partId ?? this.partId,
    batchId: batchId ?? this.batchId,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    unitCogs: unitCogs ?? this.unitCogs,
  );
  InvoiceItem copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItem(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      partId: data.partId.present ? data.partId.value : this.partId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      unitCogs: data.unitCogs.present ? data.unitCogs.value : this.unitCogs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItem(')
          ..write('itemId: $itemId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('partId: $partId, ')
          ..write('batchId: $batchId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitCogs: $unitCogs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    invoiceId,
    partId,
    batchId,
    quantity,
    unitPrice,
    unitCogs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItem &&
          other.itemId == this.itemId &&
          other.invoiceId == this.invoiceId &&
          other.partId == this.partId &&
          other.batchId == this.batchId &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.unitCogs == this.unitCogs);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItem> {
  final Value<String> itemId;
  final Value<String> invoiceId;
  final Value<String> partId;
  final Value<String> batchId;
  final Value<int> quantity;
  final Value<double> unitPrice;
  final Value<double> unitCogs;
  final Value<int> rowid;
  const InvoiceItemsCompanion({
    this.itemId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.partId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.unitCogs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    required String itemId,
    required String invoiceId,
    required String partId,
    required String batchId,
    required int quantity,
    required double unitPrice,
    required double unitCogs,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       invoiceId = Value(invoiceId),
       partId = Value(partId),
       batchId = Value(batchId),
       quantity = Value(quantity),
       unitPrice = Value(unitPrice),
       unitCogs = Value(unitCogs);
  static Insertable<InvoiceItem> custom({
    Expression<String>? itemId,
    Expression<String>? invoiceId,
    Expression<String>? partId,
    Expression<String>? batchId,
    Expression<int>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? unitCogs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (partId != null) 'part_id': partId,
      if (batchId != null) 'batch_id': batchId,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (unitCogs != null) 'unit_cogs': unitCogs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoiceItemsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? invoiceId,
    Value<String>? partId,
    Value<String>? batchId,
    Value<int>? quantity,
    Value<double>? unitPrice,
    Value<double>? unitCogs,
    Value<int>? rowid,
  }) {
    return InvoiceItemsCompanion(
      itemId: itemId ?? this.itemId,
      invoiceId: invoiceId ?? this.invoiceId,
      partId: partId ?? this.partId,
      batchId: batchId ?? this.batchId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      unitCogs: unitCogs ?? this.unitCogs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (unitCogs.present) {
      map['unit_cogs'] = Variable<double>(unitCogs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('partId: $partId, ')
          ..write('batchId: $batchId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitCogs: $unitCogs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BackupLogTable backupLog = $BackupLogTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $MigrationLogTable migrationLog = $MigrationLogTable(this);
  late final $ParkedCartsTable parkedCarts = $ParkedCartsTable(this);
  late final $ReturnsClaimsTable returnsClaims = $ReturnsClaimsTable(this);
  late final $LocalUsersTable localUsers = $LocalUsersTable(this);
  late final $AppConfigTable appConfig = $AppConfigTable(this);
  late final $AutoPartsTable autoParts = $AutoPartsTable(this);
  late final $FifoInventoryBatchesTable fifoInventoryBatches =
      $FifoInventoryBatchesTable(this);
  late final $AccountsLedgerTable accountsLedger = $AccountsLedgerTable(this);
  late final $SalesInvoicesTable salesInvoices = $SalesInvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final PartsDao partsDao = PartsDao(this as AppDatabase);
  late final PosDao posDao = PosDao(this as AppDatabase);
  late final LedgerDao ledgerDao = LedgerDao(this as AppDatabase);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final ReportsDao reportsDao = ReportsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    backupLog,
    auditLog,
    migrationLog,
    parkedCarts,
    returnsClaims,
    localUsers,
    appConfig,
    autoParts,
    fifoInventoryBatches,
    accountsLedger,
    salesInvoices,
    invoiceItems,
  ];
}

typedef $$BackupLogTableCreateCompanionBuilder =
    BackupLogCompanion Function({
      required String backupId,
      required String filePath,
      Value<DateTime> createdAt,
      Value<int?> sizeBytes,
      required String status,
      Value<int> rowid,
    });
typedef $$BackupLogTableUpdateCompanionBuilder =
    BackupLogCompanion Function({
      Value<String> backupId,
      Value<String> filePath,
      Value<DateTime> createdAt,
      Value<int?> sizeBytes,
      Value<String> status,
      Value<int> rowid,
    });

class $$BackupLogTableFilterComposer
    extends Composer<_$AppDatabase, $BackupLogTable> {
  $$BackupLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get backupId => $composableBuilder(
    column: $table.backupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BackupLogTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupLogTable> {
  $$BackupLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get backupId => $composableBuilder(
    column: $table.backupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BackupLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupLogTable> {
  $$BackupLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get backupId =>
      $composableBuilder(column: $table.backupId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$BackupLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BackupLogTable,
          BackupLogData,
          $$BackupLogTableFilterComposer,
          $$BackupLogTableOrderingComposer,
          $$BackupLogTableAnnotationComposer,
          $$BackupLogTableCreateCompanionBuilder,
          $$BackupLogTableUpdateCompanionBuilder,
          (
            BackupLogData,
            BaseReferences<_$AppDatabase, $BackupLogTable, BackupLogData>,
          ),
          BackupLogData,
          PrefetchHooks Function()
        > {
  $$BackupLogTableTableManager(_$AppDatabase db, $BackupLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> backupId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BackupLogCompanion(
                backupId: backupId,
                filePath: filePath,
                createdAt: createdAt,
                sizeBytes: sizeBytes,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String backupId,
                required String filePath,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => BackupLogCompanion.insert(
                backupId: backupId,
                filePath: filePath,
                createdAt: createdAt,
                sizeBytes: sizeBytes,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BackupLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BackupLogTable,
      BackupLogData,
      $$BackupLogTableFilterComposer,
      $$BackupLogTableOrderingComposer,
      $$BackupLogTableAnnotationComposer,
      $$BackupLogTableCreateCompanionBuilder,
      $$BackupLogTableUpdateCompanionBuilder,
      (
        BackupLogData,
        BaseReferences<_$AppDatabase, $BackupLogTable, BackupLogData>,
      ),
      BackupLogData,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> logId,
      required String userId,
      required String actionType,
      Value<String?> targetTable,
      Value<String?> recordId,
      Value<String?> oldValue,
      Value<String?> newValue,
      Value<DateTime> createdAt,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> logId,
      Value<String> userId,
      Value<String> actionType,
      Value<String?> targetTable,
      Value<String?> recordId,
      Value<String?> oldValue,
      Value<String?> newValue,
      Value<DateTime> createdAt,
    });

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get logId => $composableBuilder(
    column: $table.logId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get logId => $composableBuilder(
    column: $table.logId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get logId =>
      $composableBuilder(column: $table.logId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get oldValue =>
      $composableBuilder(column: $table.oldValue, builder: (column) => column);

  GeneratedColumn<String> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> logId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String?> targetTable = const Value.absent(),
                Value<String?> recordId = const Value.absent(),
                Value<String?> oldValue = const Value.absent(),
                Value<String?> newValue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AuditLogCompanion(
                logId: logId,
                userId: userId,
                actionType: actionType,
                targetTable: targetTable,
                recordId: recordId,
                oldValue: oldValue,
                newValue: newValue,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> logId = const Value.absent(),
                required String userId,
                required String actionType,
                Value<String?> targetTable = const Value.absent(),
                Value<String?> recordId = const Value.absent(),
                Value<String?> oldValue = const Value.absent(),
                Value<String?> newValue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AuditLogCompanion.insert(
                logId: logId,
                userId: userId,
                actionType: actionType,
                targetTable: targetTable,
                recordId: recordId,
                oldValue: oldValue,
                newValue: newValue,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;
typedef $$MigrationLogTableCreateCompanionBuilder =
    MigrationLogCompanion Function({
      required String migrationId,
      required String sourceFile,
      Value<int?> recordsImported,
      Value<int?> recordsFlagged,
      Value<String?> performedBy,
      Value<DateTime> performedAt,
      Value<int> rowid,
    });
typedef $$MigrationLogTableUpdateCompanionBuilder =
    MigrationLogCompanion Function({
      Value<String> migrationId,
      Value<String> sourceFile,
      Value<int?> recordsImported,
      Value<int?> recordsFlagged,
      Value<String?> performedBy,
      Value<DateTime> performedAt,
      Value<int> rowid,
    });

class $$MigrationLogTableFilterComposer
    extends Composer<_$AppDatabase, $MigrationLogTable> {
  $$MigrationLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get migrationId => $composableBuilder(
    column: $table.migrationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFile => $composableBuilder(
    column: $table.sourceFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordsImported => $composableBuilder(
    column: $table.recordsImported,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordsFlagged => $composableBuilder(
    column: $table.recordsFlagged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MigrationLogTableOrderingComposer
    extends Composer<_$AppDatabase, $MigrationLogTable> {
  $$MigrationLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get migrationId => $composableBuilder(
    column: $table.migrationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFile => $composableBuilder(
    column: $table.sourceFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordsImported => $composableBuilder(
    column: $table.recordsImported,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordsFlagged => $composableBuilder(
    column: $table.recordsFlagged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MigrationLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $MigrationLogTable> {
  $$MigrationLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get migrationId => $composableBuilder(
    column: $table.migrationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceFile => $composableBuilder(
    column: $table.sourceFile,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordsImported => $composableBuilder(
    column: $table.recordsImported,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordsFlagged => $composableBuilder(
    column: $table.recordsFlagged,
    builder: (column) => column,
  );

  GeneratedColumn<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => column,
  );
}

class $$MigrationLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MigrationLogTable,
          MigrationLogData,
          $$MigrationLogTableFilterComposer,
          $$MigrationLogTableOrderingComposer,
          $$MigrationLogTableAnnotationComposer,
          $$MigrationLogTableCreateCompanionBuilder,
          $$MigrationLogTableUpdateCompanionBuilder,
          (
            MigrationLogData,
            BaseReferences<_$AppDatabase, $MigrationLogTable, MigrationLogData>,
          ),
          MigrationLogData,
          PrefetchHooks Function()
        > {
  $$MigrationLogTableTableManager(_$AppDatabase db, $MigrationLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MigrationLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MigrationLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MigrationLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> migrationId = const Value.absent(),
                Value<String> sourceFile = const Value.absent(),
                Value<int?> recordsImported = const Value.absent(),
                Value<int?> recordsFlagged = const Value.absent(),
                Value<String?> performedBy = const Value.absent(),
                Value<DateTime> performedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MigrationLogCompanion(
                migrationId: migrationId,
                sourceFile: sourceFile,
                recordsImported: recordsImported,
                recordsFlagged: recordsFlagged,
                performedBy: performedBy,
                performedAt: performedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String migrationId,
                required String sourceFile,
                Value<int?> recordsImported = const Value.absent(),
                Value<int?> recordsFlagged = const Value.absent(),
                Value<String?> performedBy = const Value.absent(),
                Value<DateTime> performedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MigrationLogCompanion.insert(
                migrationId: migrationId,
                sourceFile: sourceFile,
                recordsImported: recordsImported,
                recordsFlagged: recordsFlagged,
                performedBy: performedBy,
                performedAt: performedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MigrationLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MigrationLogTable,
      MigrationLogData,
      $$MigrationLogTableFilterComposer,
      $$MigrationLogTableOrderingComposer,
      $$MigrationLogTableAnnotationComposer,
      $$MigrationLogTableCreateCompanionBuilder,
      $$MigrationLogTableUpdateCompanionBuilder,
      (
        MigrationLogData,
        BaseReferences<_$AppDatabase, $MigrationLogTable, MigrationLogData>,
      ),
      MigrationLogData,
      PrefetchHooks Function()
    >;
typedef $$ParkedCartsTableCreateCompanionBuilder =
    ParkedCartsCompanion Function({
      required String parkedId,
      required String userId,
      required String cartPayloadJson,
      Value<DateTime> parkedAt,
      Value<int> rowid,
    });
typedef $$ParkedCartsTableUpdateCompanionBuilder =
    ParkedCartsCompanion Function({
      Value<String> parkedId,
      Value<String> userId,
      Value<String> cartPayloadJson,
      Value<DateTime> parkedAt,
      Value<int> rowid,
    });

class $$ParkedCartsTableFilterComposer
    extends Composer<_$AppDatabase, $ParkedCartsTable> {
  $$ParkedCartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get parkedId => $composableBuilder(
    column: $table.parkedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cartPayloadJson => $composableBuilder(
    column: $table.cartPayloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get parkedAt => $composableBuilder(
    column: $table.parkedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParkedCartsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParkedCartsTable> {
  $$ParkedCartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get parkedId => $composableBuilder(
    column: $table.parkedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cartPayloadJson => $composableBuilder(
    column: $table.cartPayloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get parkedAt => $composableBuilder(
    column: $table.parkedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParkedCartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParkedCartsTable> {
  $$ParkedCartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get parkedId =>
      $composableBuilder(column: $table.parkedId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get cartPayloadJson => $composableBuilder(
    column: $table.cartPayloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get parkedAt =>
      $composableBuilder(column: $table.parkedAt, builder: (column) => column);
}

class $$ParkedCartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParkedCartsTable,
          ParkedCart,
          $$ParkedCartsTableFilterComposer,
          $$ParkedCartsTableOrderingComposer,
          $$ParkedCartsTableAnnotationComposer,
          $$ParkedCartsTableCreateCompanionBuilder,
          $$ParkedCartsTableUpdateCompanionBuilder,
          (
            ParkedCart,
            BaseReferences<_$AppDatabase, $ParkedCartsTable, ParkedCart>,
          ),
          ParkedCart,
          PrefetchHooks Function()
        > {
  $$ParkedCartsTableTableManager(_$AppDatabase db, $ParkedCartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParkedCartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParkedCartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParkedCartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> parkedId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> cartPayloadJson = const Value.absent(),
                Value<DateTime> parkedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParkedCartsCompanion(
                parkedId: parkedId,
                userId: userId,
                cartPayloadJson: cartPayloadJson,
                parkedAt: parkedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String parkedId,
                required String userId,
                required String cartPayloadJson,
                Value<DateTime> parkedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParkedCartsCompanion.insert(
                parkedId: parkedId,
                userId: userId,
                cartPayloadJson: cartPayloadJson,
                parkedAt: parkedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParkedCartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParkedCartsTable,
      ParkedCart,
      $$ParkedCartsTableFilterComposer,
      $$ParkedCartsTableOrderingComposer,
      $$ParkedCartsTableAnnotationComposer,
      $$ParkedCartsTableCreateCompanionBuilder,
      $$ParkedCartsTableUpdateCompanionBuilder,
      (
        ParkedCart,
        BaseReferences<_$AppDatabase, $ParkedCartsTable, ParkedCart>,
      ),
      ParkedCart,
      PrefetchHooks Function()
    >;
typedef $$ReturnsClaimsTableCreateCompanionBuilder =
    ReturnsClaimsCompanion Function({
      required String claimId,
      required String claimType,
      Value<String?> referenceInvoiceId,
      required String initiatedBy,
      Value<String> status,
      Value<String?> refundMethod,
      Value<String?> approvedBy,
      Value<DateTime?> approvedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ReturnsClaimsTableUpdateCompanionBuilder =
    ReturnsClaimsCompanion Function({
      Value<String> claimId,
      Value<String> claimType,
      Value<String?> referenceInvoiceId,
      Value<String> initiatedBy,
      Value<String> status,
      Value<String?> refundMethod,
      Value<String?> approvedBy,
      Value<DateTime?> approvedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ReturnsClaimsTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnsClaimsTable> {
  $$ReturnsClaimsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get claimId => $composableBuilder(
    column: $table.claimId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get claimType => $composableBuilder(
    column: $table.claimType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceInvoiceId => $composableBuilder(
    column: $table.referenceInvoiceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initiatedBy => $composableBuilder(
    column: $table.initiatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refundMethod => $composableBuilder(
    column: $table.refundMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReturnsClaimsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnsClaimsTable> {
  $$ReturnsClaimsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get claimId => $composableBuilder(
    column: $table.claimId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get claimType => $composableBuilder(
    column: $table.claimType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceInvoiceId => $composableBuilder(
    column: $table.referenceInvoiceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initiatedBy => $composableBuilder(
    column: $table.initiatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refundMethod => $composableBuilder(
    column: $table.refundMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReturnsClaimsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnsClaimsTable> {
  $$ReturnsClaimsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get claimId =>
      $composableBuilder(column: $table.claimId, builder: (column) => column);

  GeneratedColumn<String> get claimType =>
      $composableBuilder(column: $table.claimType, builder: (column) => column);

  GeneratedColumn<String> get referenceInvoiceId => $composableBuilder(
    column: $table.referenceInvoiceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initiatedBy => $composableBuilder(
    column: $table.initiatedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get refundMethod => $composableBuilder(
    column: $table.refundMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReturnsClaimsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReturnsClaimsTable,
          ReturnsClaim,
          $$ReturnsClaimsTableFilterComposer,
          $$ReturnsClaimsTableOrderingComposer,
          $$ReturnsClaimsTableAnnotationComposer,
          $$ReturnsClaimsTableCreateCompanionBuilder,
          $$ReturnsClaimsTableUpdateCompanionBuilder,
          (
            ReturnsClaim,
            BaseReferences<_$AppDatabase, $ReturnsClaimsTable, ReturnsClaim>,
          ),
          ReturnsClaim,
          PrefetchHooks Function()
        > {
  $$ReturnsClaimsTableTableManager(_$AppDatabase db, $ReturnsClaimsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnsClaimsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnsClaimsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnsClaimsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> claimId = const Value.absent(),
                Value<String> claimType = const Value.absent(),
                Value<String?> referenceInvoiceId = const Value.absent(),
                Value<String> initiatedBy = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> refundMethod = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<DateTime?> approvedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnsClaimsCompanion(
                claimId: claimId,
                claimType: claimType,
                referenceInvoiceId: referenceInvoiceId,
                initiatedBy: initiatedBy,
                status: status,
                refundMethod: refundMethod,
                approvedBy: approvedBy,
                approvedAt: approvedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String claimId,
                required String claimType,
                Value<String?> referenceInvoiceId = const Value.absent(),
                required String initiatedBy,
                Value<String> status = const Value.absent(),
                Value<String?> refundMethod = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<DateTime?> approvedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnsClaimsCompanion.insert(
                claimId: claimId,
                claimType: claimType,
                referenceInvoiceId: referenceInvoiceId,
                initiatedBy: initiatedBy,
                status: status,
                refundMethod: refundMethod,
                approvedBy: approvedBy,
                approvedAt: approvedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReturnsClaimsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReturnsClaimsTable,
      ReturnsClaim,
      $$ReturnsClaimsTableFilterComposer,
      $$ReturnsClaimsTableOrderingComposer,
      $$ReturnsClaimsTableAnnotationComposer,
      $$ReturnsClaimsTableCreateCompanionBuilder,
      $$ReturnsClaimsTableUpdateCompanionBuilder,
      (
        ReturnsClaim,
        BaseReferences<_$AppDatabase, $ReturnsClaimsTable, ReturnsClaim>,
      ),
      ReturnsClaim,
      PrefetchHooks Function()
    >;
typedef $$LocalUsersTableCreateCompanionBuilder =
    LocalUsersCompanion Function({
      required String id,
      required String fullName,
      required String username,
      required String passwordHash,
      required String pinHash,
      required String role,
      Value<String> preferredLanguage,
      Value<int> rowid,
    });
typedef $$LocalUsersTableUpdateCompanionBuilder =
    LocalUsersCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String> username,
      Value<String> passwordHash,
      Value<String> pinHash,
      Value<String> role,
      Value<String> preferredLanguage,
      Value<int> rowid,
    });

class $$LocalUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => column,
  );
}

class $$LocalUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUsersTable,
          LocalUser,
          $$LocalUsersTableFilterComposer,
          $$LocalUsersTableOrderingComposer,
          $$LocalUsersTableAnnotationComposer,
          $$LocalUsersTableCreateCompanionBuilder,
          $$LocalUsersTableUpdateCompanionBuilder,
          (
            LocalUser,
            BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>,
          ),
          LocalUser,
          PrefetchHooks Function()
        > {
  $$LocalUsersTableTableManager(_$AppDatabase db, $LocalUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> preferredLanguage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion(
                id: id,
                fullName: fullName,
                username: username,
                passwordHash: passwordHash,
                pinHash: pinHash,
                role: role,
                preferredLanguage: preferredLanguage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                required String username,
                required String passwordHash,
                required String pinHash,
                required String role,
                Value<String> preferredLanguage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion.insert(
                id: id,
                fullName: fullName,
                username: username,
                passwordHash: passwordHash,
                pinHash: pinHash,
                role: role,
                preferredLanguage: preferredLanguage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUsersTable,
      LocalUser,
      $$LocalUsersTableFilterComposer,
      $$LocalUsersTableOrderingComposer,
      $$LocalUsersTableAnnotationComposer,
      $$LocalUsersTableCreateCompanionBuilder,
      $$LocalUsersTableUpdateCompanionBuilder,
      (LocalUser, BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>),
      LocalUser,
      PrefetchHooks Function()
    >;
typedef $$AppConfigTableCreateCompanionBuilder =
    AppConfigCompanion Function({
      required String configKey,
      required String configValue,
      Value<int> rowid,
    });
typedef $$AppConfigTableUpdateCompanionBuilder =
    AppConfigCompanion Function({
      Value<String> configKey,
      Value<String> configValue,
      Value<int> rowid,
    });

class $$AppConfigTableFilterComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get configKey => $composableBuilder(
    column: $table.configKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configValue => $composableBuilder(
    column: $table.configValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get configKey => $composableBuilder(
    column: $table.configKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configValue => $composableBuilder(
    column: $table.configValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get configKey =>
      $composableBuilder(column: $table.configKey, builder: (column) => column);

  GeneratedColumn<String> get configValue => $composableBuilder(
    column: $table.configValue,
    builder: (column) => column,
  );
}

class $$AppConfigTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppConfigTable,
          AppConfigData,
          $$AppConfigTableFilterComposer,
          $$AppConfigTableOrderingComposer,
          $$AppConfigTableAnnotationComposer,
          $$AppConfigTableCreateCompanionBuilder,
          $$AppConfigTableUpdateCompanionBuilder,
          (
            AppConfigData,
            BaseReferences<_$AppDatabase, $AppConfigTable, AppConfigData>,
          ),
          AppConfigData,
          PrefetchHooks Function()
        > {
  $$AppConfigTableTableManager(_$AppDatabase db, $AppConfigTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> configKey = const Value.absent(),
                Value<String> configValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppConfigCompanion(
                configKey: configKey,
                configValue: configValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String configKey,
                required String configValue,
                Value<int> rowid = const Value.absent(),
              }) => AppConfigCompanion.insert(
                configKey: configKey,
                configValue: configValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppConfigTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppConfigTable,
      AppConfigData,
      $$AppConfigTableFilterComposer,
      $$AppConfigTableOrderingComposer,
      $$AppConfigTableAnnotationComposer,
      $$AppConfigTableCreateCompanionBuilder,
      $$AppConfigTableUpdateCompanionBuilder,
      (
        AppConfigData,
        BaseReferences<_$AppDatabase, $AppConfigTable, AppConfigData>,
      ),
      AppConfigData,
      PrefetchHooks Function()
    >;
typedef $$AutoPartsTableCreateCompanionBuilder =
    AutoPartsCompanion Function({
      required String partId,
      required String partName,
      Value<String?> oemNumber,
      Value<String?> model,
      Value<String?> rackLocation,
      Value<int> minReorderLevel,
      Value<int> rowid,
    });
typedef $$AutoPartsTableUpdateCompanionBuilder =
    AutoPartsCompanion Function({
      Value<String> partId,
      Value<String> partName,
      Value<String?> oemNumber,
      Value<String?> model,
      Value<String?> rackLocation,
      Value<int> minReorderLevel,
      Value<int> rowid,
    });

class $$AutoPartsTableFilterComposer
    extends Composer<_$AppDatabase, $AutoPartsTable> {
  $$AutoPartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partName => $composableBuilder(
    column: $table.partName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oemNumber => $composableBuilder(
    column: $table.oemNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rackLocation => $composableBuilder(
    column: $table.rackLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minReorderLevel => $composableBuilder(
    column: $table.minReorderLevel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AutoPartsTableOrderingComposer
    extends Composer<_$AppDatabase, $AutoPartsTable> {
  $$AutoPartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partName => $composableBuilder(
    column: $table.partName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oemNumber => $composableBuilder(
    column: $table.oemNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rackLocation => $composableBuilder(
    column: $table.rackLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minReorderLevel => $composableBuilder(
    column: $table.minReorderLevel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AutoPartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AutoPartsTable> {
  $$AutoPartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get partId =>
      $composableBuilder(column: $table.partId, builder: (column) => column);

  GeneratedColumn<String> get partName =>
      $composableBuilder(column: $table.partName, builder: (column) => column);

  GeneratedColumn<String> get oemNumber =>
      $composableBuilder(column: $table.oemNumber, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get rackLocation => $composableBuilder(
    column: $table.rackLocation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minReorderLevel => $composableBuilder(
    column: $table.minReorderLevel,
    builder: (column) => column,
  );
}

class $$AutoPartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AutoPartsTable,
          AutoPart,
          $$AutoPartsTableFilterComposer,
          $$AutoPartsTableOrderingComposer,
          $$AutoPartsTableAnnotationComposer,
          $$AutoPartsTableCreateCompanionBuilder,
          $$AutoPartsTableUpdateCompanionBuilder,
          (AutoPart, BaseReferences<_$AppDatabase, $AutoPartsTable, AutoPart>),
          AutoPart,
          PrefetchHooks Function()
        > {
  $$AutoPartsTableTableManager(_$AppDatabase db, $AutoPartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AutoPartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AutoPartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AutoPartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> partId = const Value.absent(),
                Value<String> partName = const Value.absent(),
                Value<String?> oemNumber = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> rackLocation = const Value.absent(),
                Value<int> minReorderLevel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AutoPartsCompanion(
                partId: partId,
                partName: partName,
                oemNumber: oemNumber,
                model: model,
                rackLocation: rackLocation,
                minReorderLevel: minReorderLevel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String partId,
                required String partName,
                Value<String?> oemNumber = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> rackLocation = const Value.absent(),
                Value<int> minReorderLevel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AutoPartsCompanion.insert(
                partId: partId,
                partName: partName,
                oemNumber: oemNumber,
                model: model,
                rackLocation: rackLocation,
                minReorderLevel: minReorderLevel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AutoPartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AutoPartsTable,
      AutoPart,
      $$AutoPartsTableFilterComposer,
      $$AutoPartsTableOrderingComposer,
      $$AutoPartsTableAnnotationComposer,
      $$AutoPartsTableCreateCompanionBuilder,
      $$AutoPartsTableUpdateCompanionBuilder,
      (AutoPart, BaseReferences<_$AppDatabase, $AutoPartsTable, AutoPart>),
      AutoPart,
      PrefetchHooks Function()
    >;
typedef $$FifoInventoryBatchesTableCreateCompanionBuilder =
    FifoInventoryBatchesCompanion Function({
      required String batchId,
      required String partId,
      required int originalQuantity,
      required int remainingQuantity,
      required double unitLandedCost,
      Value<String?> supplierId,
      Value<DateTime> receivedAt,
      Value<int> rowid,
    });
typedef $$FifoInventoryBatchesTableUpdateCompanionBuilder =
    FifoInventoryBatchesCompanion Function({
      Value<String> batchId,
      Value<String> partId,
      Value<int> originalQuantity,
      Value<int> remainingQuantity,
      Value<double> unitLandedCost,
      Value<String?> supplierId,
      Value<DateTime> receivedAt,
      Value<int> rowid,
    });

class $$FifoInventoryBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $FifoInventoryBatchesTable> {
  $$FifoInventoryBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalQuantity => $composableBuilder(
    column: $table.originalQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingQuantity => $composableBuilder(
    column: $table.remainingQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitLandedCost => $composableBuilder(
    column: $table.unitLandedCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FifoInventoryBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $FifoInventoryBatchesTable> {
  $$FifoInventoryBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalQuantity => $composableBuilder(
    column: $table.originalQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingQuantity => $composableBuilder(
    column: $table.remainingQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitLandedCost => $composableBuilder(
    column: $table.unitLandedCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FifoInventoryBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FifoInventoryBatchesTable> {
  $$FifoInventoryBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get partId =>
      $composableBuilder(column: $table.partId, builder: (column) => column);

  GeneratedColumn<int> get originalQuantity => $composableBuilder(
    column: $table.originalQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingQuantity => $composableBuilder(
    column: $table.remainingQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitLandedCost => $composableBuilder(
    column: $table.unitLandedCost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );
}

class $$FifoInventoryBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FifoInventoryBatchesTable,
          FifoInventoryBatche,
          $$FifoInventoryBatchesTableFilterComposer,
          $$FifoInventoryBatchesTableOrderingComposer,
          $$FifoInventoryBatchesTableAnnotationComposer,
          $$FifoInventoryBatchesTableCreateCompanionBuilder,
          $$FifoInventoryBatchesTableUpdateCompanionBuilder,
          (
            FifoInventoryBatche,
            BaseReferences<
              _$AppDatabase,
              $FifoInventoryBatchesTable,
              FifoInventoryBatche
            >,
          ),
          FifoInventoryBatche,
          PrefetchHooks Function()
        > {
  $$FifoInventoryBatchesTableTableManager(
    _$AppDatabase db,
    $FifoInventoryBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FifoInventoryBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FifoInventoryBatchesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FifoInventoryBatchesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> batchId = const Value.absent(),
                Value<String> partId = const Value.absent(),
                Value<int> originalQuantity = const Value.absent(),
                Value<int> remainingQuantity = const Value.absent(),
                Value<double> unitLandedCost = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FifoInventoryBatchesCompanion(
                batchId: batchId,
                partId: partId,
                originalQuantity: originalQuantity,
                remainingQuantity: remainingQuantity,
                unitLandedCost: unitLandedCost,
                supplierId: supplierId,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String batchId,
                required String partId,
                required int originalQuantity,
                required int remainingQuantity,
                required double unitLandedCost,
                Value<String?> supplierId = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FifoInventoryBatchesCompanion.insert(
                batchId: batchId,
                partId: partId,
                originalQuantity: originalQuantity,
                remainingQuantity: remainingQuantity,
                unitLandedCost: unitLandedCost,
                supplierId: supplierId,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FifoInventoryBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FifoInventoryBatchesTable,
      FifoInventoryBatche,
      $$FifoInventoryBatchesTableFilterComposer,
      $$FifoInventoryBatchesTableOrderingComposer,
      $$FifoInventoryBatchesTableAnnotationComposer,
      $$FifoInventoryBatchesTableCreateCompanionBuilder,
      $$FifoInventoryBatchesTableUpdateCompanionBuilder,
      (
        FifoInventoryBatche,
        BaseReferences<
          _$AppDatabase,
          $FifoInventoryBatchesTable,
          FifoInventoryBatche
        >,
      ),
      FifoInventoryBatche,
      PrefetchHooks Function()
    >;
typedef $$AccountsLedgerTableCreateCompanionBuilder =
    AccountsLedgerCompanion Function({
      required String accountId,
      required String accountName,
      required String accountType,
      Value<double> currentBalance,
      Value<double?> creditLimit,
      Value<int> rowid,
    });
typedef $$AccountsLedgerTableUpdateCompanionBuilder =
    AccountsLedgerCompanion Function({
      Value<String> accountId,
      Value<String> accountName,
      Value<String> accountType,
      Value<double> currentBalance,
      Value<double?> creditLimit,
      Value<int> rowid,
    });

class $$AccountsLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsLedgerTable> {
  $$AccountsLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsLedgerTable> {
  $$AccountsLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsLedgerTable> {
  $$AccountsLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );
}

class $$AccountsLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsLedgerTable,
          AccountsLedgerData,
          $$AccountsLedgerTableFilterComposer,
          $$AccountsLedgerTableOrderingComposer,
          $$AccountsLedgerTableAnnotationComposer,
          $$AccountsLedgerTableCreateCompanionBuilder,
          $$AccountsLedgerTableUpdateCompanionBuilder,
          (
            AccountsLedgerData,
            BaseReferences<
              _$AppDatabase,
              $AccountsLedgerTable,
              AccountsLedgerData
            >,
          ),
          AccountsLedgerData,
          PrefetchHooks Function()
        > {
  $$AccountsLedgerTableTableManager(
    _$AppDatabase db,
    $AccountsLedgerTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> accountId = const Value.absent(),
                Value<String> accountName = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<double> currentBalance = const Value.absent(),
                Value<double?> creditLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsLedgerCompanion(
                accountId: accountId,
                accountName: accountName,
                accountType: accountType,
                currentBalance: currentBalance,
                creditLimit: creditLimit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String accountId,
                required String accountName,
                required String accountType,
                Value<double> currentBalance = const Value.absent(),
                Value<double?> creditLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsLedgerCompanion.insert(
                accountId: accountId,
                accountName: accountName,
                accountType: accountType,
                currentBalance: currentBalance,
                creditLimit: creditLimit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsLedgerTable,
      AccountsLedgerData,
      $$AccountsLedgerTableFilterComposer,
      $$AccountsLedgerTableOrderingComposer,
      $$AccountsLedgerTableAnnotationComposer,
      $$AccountsLedgerTableCreateCompanionBuilder,
      $$AccountsLedgerTableUpdateCompanionBuilder,
      (
        AccountsLedgerData,
        BaseReferences<_$AppDatabase, $AccountsLedgerTable, AccountsLedgerData>,
      ),
      AccountsLedgerData,
      PrefetchHooks Function()
    >;
typedef $$SalesInvoicesTableCreateCompanionBuilder =
    SalesInvoicesCompanion Function({
      required String invoiceId,
      Value<String?> customerId,
      required double totalAmount,
      Value<double> discount,
      required double finalAmount,
      required String createdBy,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SalesInvoicesTableUpdateCompanionBuilder =
    SalesInvoicesCompanion Function({
      Value<String> invoiceId,
      Value<String?> customerId,
      Value<double> totalAmount,
      Value<double> discount,
      Value<double> finalAmount,
      Value<String> createdBy,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SalesInvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $SalesInvoicesTable> {
  $$SalesInvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get invoiceId => $composableBuilder(
    column: $table.invoiceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finalAmount => $composableBuilder(
    column: $table.finalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesInvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesInvoicesTable> {
  $$SalesInvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get invoiceId => $composableBuilder(
    column: $table.invoiceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finalAmount => $composableBuilder(
    column: $table.finalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesInvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesInvoicesTable> {
  $$SalesInvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get invoiceId =>
      $composableBuilder(column: $table.invoiceId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get finalAmount => $composableBuilder(
    column: $table.finalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SalesInvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesInvoicesTable,
          SalesInvoice,
          $$SalesInvoicesTableFilterComposer,
          $$SalesInvoicesTableOrderingComposer,
          $$SalesInvoicesTableAnnotationComposer,
          $$SalesInvoicesTableCreateCompanionBuilder,
          $$SalesInvoicesTableUpdateCompanionBuilder,
          (
            SalesInvoice,
            BaseReferences<_$AppDatabase, $SalesInvoicesTable, SalesInvoice>,
          ),
          SalesInvoice,
          PrefetchHooks Function()
        > {
  $$SalesInvoicesTableTableManager(_$AppDatabase db, $SalesInvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesInvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesInvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesInvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> invoiceId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<double> finalAmount = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesInvoicesCompanion(
                invoiceId: invoiceId,
                customerId: customerId,
                totalAmount: totalAmount,
                discount: discount,
                finalAmount: finalAmount,
                createdBy: createdBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String invoiceId,
                Value<String?> customerId = const Value.absent(),
                required double totalAmount,
                Value<double> discount = const Value.absent(),
                required double finalAmount,
                required String createdBy,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesInvoicesCompanion.insert(
                invoiceId: invoiceId,
                customerId: customerId,
                totalAmount: totalAmount,
                discount: discount,
                finalAmount: finalAmount,
                createdBy: createdBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesInvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesInvoicesTable,
      SalesInvoice,
      $$SalesInvoicesTableFilterComposer,
      $$SalesInvoicesTableOrderingComposer,
      $$SalesInvoicesTableAnnotationComposer,
      $$SalesInvoicesTableCreateCompanionBuilder,
      $$SalesInvoicesTableUpdateCompanionBuilder,
      (
        SalesInvoice,
        BaseReferences<_$AppDatabase, $SalesInvoicesTable, SalesInvoice>,
      ),
      SalesInvoice,
      PrefetchHooks Function()
    >;
typedef $$InvoiceItemsTableCreateCompanionBuilder =
    InvoiceItemsCompanion Function({
      required String itemId,
      required String invoiceId,
      required String partId,
      required String batchId,
      required int quantity,
      required double unitPrice,
      required double unitCogs,
      Value<int> rowid,
    });
typedef $$InvoiceItemsTableUpdateCompanionBuilder =
    InvoiceItemsCompanion Function({
      Value<String> itemId,
      Value<String> invoiceId,
      Value<String> partId,
      Value<String> batchId,
      Value<int> quantity,
      Value<double> unitPrice,
      Value<double> unitCogs,
      Value<int> rowid,
    });

class $$InvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceId => $composableBuilder(
    column: $table.invoiceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitCogs => $composableBuilder(
    column: $table.unitCogs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceId => $composableBuilder(
    column: $table.invoiceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitCogs => $composableBuilder(
    column: $table.unitCogs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get invoiceId =>
      $composableBuilder(column: $table.invoiceId, builder: (column) => column);

  GeneratedColumn<String> get partId =>
      $composableBuilder(column: $table.partId, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get unitCogs =>
      $composableBuilder(column: $table.unitCogs, builder: (column) => column);
}

class $$InvoiceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceItemsTable,
          InvoiceItem,
          $$InvoiceItemsTableFilterComposer,
          $$InvoiceItemsTableOrderingComposer,
          $$InvoiceItemsTableAnnotationComposer,
          $$InvoiceItemsTableCreateCompanionBuilder,
          $$InvoiceItemsTableUpdateCompanionBuilder,
          (
            InvoiceItem,
            BaseReferences<_$AppDatabase, $InvoiceItemsTable, InvoiceItem>,
          ),
          InvoiceItem,
          PrefetchHooks Function()
        > {
  $$InvoiceItemsTableTableManager(_$AppDatabase db, $InvoiceItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> invoiceId = const Value.absent(),
                Value<String> partId = const Value.absent(),
                Value<String> batchId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> unitCogs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoiceItemsCompanion(
                itemId: itemId,
                invoiceId: invoiceId,
                partId: partId,
                batchId: batchId,
                quantity: quantity,
                unitPrice: unitPrice,
                unitCogs: unitCogs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String invoiceId,
                required String partId,
                required String batchId,
                required int quantity,
                required double unitPrice,
                required double unitCogs,
                Value<int> rowid = const Value.absent(),
              }) => InvoiceItemsCompanion.insert(
                itemId: itemId,
                invoiceId: invoiceId,
                partId: partId,
                batchId: batchId,
                quantity: quantity,
                unitPrice: unitPrice,
                unitCogs: unitCogs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoiceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceItemsTable,
      InvoiceItem,
      $$InvoiceItemsTableFilterComposer,
      $$InvoiceItemsTableOrderingComposer,
      $$InvoiceItemsTableAnnotationComposer,
      $$InvoiceItemsTableCreateCompanionBuilder,
      $$InvoiceItemsTableUpdateCompanionBuilder,
      (
        InvoiceItem,
        BaseReferences<_$AppDatabase, $InvoiceItemsTable, InvoiceItem>,
      ),
      InvoiceItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BackupLogTableTableManager get backupLog =>
      $$BackupLogTableTableManager(_db, _db.backupLog);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$MigrationLogTableTableManager get migrationLog =>
      $$MigrationLogTableTableManager(_db, _db.migrationLog);
  $$ParkedCartsTableTableManager get parkedCarts =>
      $$ParkedCartsTableTableManager(_db, _db.parkedCarts);
  $$ReturnsClaimsTableTableManager get returnsClaims =>
      $$ReturnsClaimsTableTableManager(_db, _db.returnsClaims);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db, _db.localUsers);
  $$AppConfigTableTableManager get appConfig =>
      $$AppConfigTableTableManager(_db, _db.appConfig);
  $$AutoPartsTableTableManager get autoParts =>
      $$AutoPartsTableTableManager(_db, _db.autoParts);
  $$FifoInventoryBatchesTableTableManager get fifoInventoryBatches =>
      $$FifoInventoryBatchesTableTableManager(_db, _db.fifoInventoryBatches);
  $$AccountsLedgerTableTableManager get accountsLedger =>
      $$AccountsLedgerTableTableManager(_db, _db.accountsLedger);
  $$SalesInvoicesTableTableManager get salesInvoices =>
      $$SalesInvoicesTableTableManager(_db, _db.salesInvoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
}
