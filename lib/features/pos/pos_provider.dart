import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/daos/pos_dao.dart';
import '../../core/security/auth_provider.dart';
import 'print_service.dart';

class PosCartState {
  final String? customerId;
  final List<CartItem> items;
  final double discount;
  final String? overrideReason;

  PosCartState({
    this.customerId,
    this.items = const [],
    this.discount = 0.0,
    this.overrideReason,
  });

  double get subtotal =>
      items.fold(0, (sum, item) => sum + (item.unitPrice * item.quantity));
  double get total => subtotal - discount;

  PosCartState copyWith({
    String? customerId,
    List<CartItem>? items,
    double? discount,
    String? overrideReason,
  }) {
    return PosCartState(
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      discount: discount ?? this.discount,
      overrideReason: overrideReason ?? this.overrideReason,
    );
  }
}

class PosCartNotifier extends Notifier<PosCartState> {
  @override
  PosCartState build() {
    return PosCartState();
  }

  void setCustomer(String customerId) {
    state = state.copyWith(customerId: customerId);
  }

  void addItem(String partId, int quantity, double unitPrice) {
    // If part already in cart, update quantity
    final existingIndex = state.items.indexWhere((i) => i.partId == partId);
    if (existingIndex >= 0) {
      final existingItem = state.items[existingIndex];
      final newItems = List<CartItem>.from(state.items);
      newItems[existingIndex] = CartItem(
        partId: partId,
        quantity: existingItem.quantity + quantity,
        unitPrice: existingItem
            .unitPrice, // Keep existing or update? Let's assume keep.
      );
      state = state.copyWith(items: newItems);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(partId: partId, quantity: quantity, unitPrice: unitPrice),
        ],
      );
    }
  }

  void setDiscount(double discount) {
    state = state.copyWith(discount: discount);
  }

  void clearCart() {
    state = PosCartState();
  }

  Future<bool> checkout() async {
    final db = ref.read(databaseProvider);
    final user = ref.read(authProvider).user;
    if (db == null || user == null) return false;

    if (state.items.isEmpty) return false;

    try {
      final invoiceId = await db.posDao.processSale(
        userId: user.id,
        customerId: state.customerId,
        items: state.items,
        discount: state.discount,
        totalAmount: state.subtotal,
        finalAmount: state.total,
      );

      // Silent PDF render & print using invoiceId
      final printSvc = ref.read(printServiceProvider);
      await printSvc.printInvoiceSilently(
        invoiceId,
        80, // Default 80mm for now, can be read from config
        {'totalAmount': state.total}, // Pass actual invoice data here
      );

      clearCart();
      return true;
    } catch (e) {
      // e.g., Not enough stock Exception
      return false;
    }
  }
}

final posCartProvider = NotifierProvider<PosCartNotifier, PosCartState>(
  () => PosCartNotifier(),
);
