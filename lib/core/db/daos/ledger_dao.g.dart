// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_dao.dart';

// ignore_for_file: type=lint
mixin _$LedgerDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccountsLedgerTable get accountsLedger => attachedDatabase.accountsLedger;
  $FifoInventoryBatchesTable get fifoInventoryBatches =>
      attachedDatabase.fifoInventoryBatches;
  LedgerDaoManager get managers => LedgerDaoManager(this);
}

class LedgerDaoManager {
  final _$LedgerDaoMixin _db;
  LedgerDaoManager(this._db);
  $$AccountsLedgerTableTableManager get accountsLedger =>
      $$AccountsLedgerTableTableManager(
        _db.attachedDatabase,
        _db.accountsLedger,
      );
  $$FifoInventoryBatchesTableTableManager get fifoInventoryBatches =>
      $$FifoInventoryBatchesTableTableManager(
        _db.attachedDatabase,
        _db.fifoInventoryBatches,
      );
}
