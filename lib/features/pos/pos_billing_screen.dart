import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pos_provider.dart';
import '../../core/security/admin_pin_modal.dart';

class PosBillingScreen extends ConsumerStatefulWidget {
  const PosBillingScreen({super.key});

  @override
  ConsumerState<PosBillingScreen> createState() => _PosBillingScreenState();
}

class _PosBillingScreenState extends ConsumerState<PosBillingScreen> {
  final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();

  DateTime? _lastKeystrokeTime;
  String _barcodeBuffer = '';

  @override
  void initState() {
    super.initState();
    // Keep focus on the search/scan input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f12) {
        _checkout();
        return;
      } else if (event.logicalKey == LogicalKeyboardKey.f10) {
        _overridePrice();
        return;
      }

      // Barcode Wedge Detection: rapid keystrokes (< 50ms between keys)
      final now = DateTime.now();
      if (_lastKeystrokeTime != null &&
          now.difference(_lastKeystrokeTime!).inMilliseconds < 50) {
        if (event.character != null) {
          _barcodeBuffer += event.character!;
        } else if (event.logicalKey == LogicalKeyboardKey.enter) {
          if (_barcodeBuffer.isNotEmpty) {
            _handleSearchSubmit(_barcodeBuffer);
            _barcodeBuffer = '';
          }
        }
      } else {
        // Reset buffer if delay is too long (human typing)
        if (event.character != null) {
          _barcodeBuffer = event.character!;
        }
      }
      _lastKeystrokeTime = now;
    }
  }

  void _handleSearchSubmit(String value) {
    if (value.isEmpty) return;

    // In a real implementation, search DB via partsDao
    // If exact match, auto-add 1 quantity
    // Mocking addition for structural setup
    ref.read(posCartProvider.notifier).addItem(value, 1, 1500.0);
    _searchController.clear();
    _searchFocusNode.requestFocus();
  }

  void _overridePrice() async {
    final auth = await AdminPinModal.show(
      context,
      'Override Unit Price or Discount',
    );
    if (auth) {
      // Show discount modal and apply via posCartProvider
      ref.read(posCartProvider.notifier).setDiscount(500.0);
      _searchFocusNode.requestFocus();
    }
  }

  void _checkout() async {
    final success = await ref.read(posCartProvider.notifier).checkout();
    if (success) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checkout Complete. Printing...')),
        );
    } else {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Checkout Failed.')));
    }
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(posCartProvider);

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _onKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'POS Billing',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Search / Scan Input
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: const InputDecoration(
                labelText: 'Scan Barcode or Search Part Name / OEM #',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: _handleSearchSubmit,
            ),

            const SizedBox(height: 16),

            // Cart Items List
            Expanded(
              child: ListView.builder(
                itemCount: cartState.items.length,
                itemBuilder: (context, index) {
                  final item = cartState.items[index];
                  return ListTile(
                    title: Text(item.partId),
                    subtitle: Text(
                      'Qty: ${item.quantity} x ₨ ${item.unitPrice}',
                    ),
                    trailing: Text('₨ ${item.quantity * item.unitPrice}'),
                  );
                },
              ),
            ),

            // Totals and Actions
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal: ₨ ${cartState.subtotal}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Discount: ₨ ${cartState.discount}',
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
                Text(
                  'Total: ₨ ${cartState.total}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _overridePrice,
                  icon: const Icon(Icons.discount),
                  label: const Text('Discount (F10)'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _checkout,
                  icon: const Icon(Icons.payment),
                  label: const Text('Checkout (F12)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
