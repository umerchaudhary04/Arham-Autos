// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_dao.dart';

// ignore_for_file: type=lint
mixin _$PosDaoMixin on DatabaseAccessor<AppDatabase> {
  $SalesInvoicesTable get salesInvoices => attachedDatabase.salesInvoices;
  $InvoiceItemsTable get invoiceItems => attachedDatabase.invoiceItems;
  $FifoInventoryBatchesTable get fifoInventoryBatches =>
      attachedDatabase.fifoInventoryBatches;
  $AccountsLedgerTable get accountsLedger => attachedDatabase.accountsLedger;
  PosDaoManager get managers => PosDaoManager(this);
}

class PosDaoManager {
  final _$PosDaoMixin _db;
  PosDaoManager(this._db);
  $$SalesInvoicesTableTableManager get salesInvoices =>
      $$SalesInvoicesTableTableManager(_db.attachedDatabase, _db.salesInvoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db.attachedDatabase, _db.invoiceItems);
  $$FifoInventoryBatchesTableTableManager get fifoInventoryBatches =>
      $$FifoInventoryBatchesTableTableManager(
        _db.attachedDatabase,
        _db.fifoInventoryBatches,
      );
  $$AccountsLedgerTableTableManager get accountsLedger =>
      $$AccountsLedgerTableTableManager(
        _db.attachedDatabase,
        _db.accountsLedger,
      );
}
