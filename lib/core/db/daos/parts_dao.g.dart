// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parts_dao.dart';

// ignore_for_file: type=lint
mixin _$PartsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AutoPartsTable get autoParts => attachedDatabase.autoParts;
  $FifoInventoryBatchesTable get fifoInventoryBatches =>
      attachedDatabase.fifoInventoryBatches;
  $AuditLogTable get auditLog => attachedDatabase.auditLog;
  PartsDaoManager get managers => PartsDaoManager(this);
}

class PartsDaoManager {
  final _$PartsDaoMixin _db;
  PartsDaoManager(this._db);
  $$AutoPartsTableTableManager get autoParts =>
      $$AutoPartsTableTableManager(_db.attachedDatabase, _db.autoParts);
  $$FifoInventoryBatchesTableTableManager get fifoInventoryBatches =>
      $$FifoInventoryBatchesTableTableManager(
        _db.attachedDatabase,
        _db.fifoInventoryBatches,
      );
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db.attachedDatabase, _db.auditLog);
}
