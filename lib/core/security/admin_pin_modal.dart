import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/auth_provider.dart';

class AdminPinModal extends ConsumerStatefulWidget {
  final String actionDescription;
  
  const AdminPinModal({super.key, required this.actionDescription});

  static Future<bool> show(BuildContext context, String description) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AdminPinModal(actionDescription: description),
    );
    return result ?? false;
  }

  @override
  ConsumerState<AdminPinModal> createState() => _AdminPinModalState();
}

class _AdminPinModalState extends ConsumerState<AdminPinModal> {
  final _pinController = TextEditingController();
  bool _isError = false;

  void _verify() async {
    final db = ref.read(databaseProvider);
    if (db == null) return;
    
    final pin = _pinController.text;
    
    // Check if PIN belongs to an Admin or Manager
    final users = await db.select(db.localUsers).get();
    final authorizedUser = users.where((u) => 
      u.pinHash == pin && (u.role == 'Admin' || u.role == 'Manager')
    ).firstOrNull;

    if (authorizedUser != null) {
      if (mounted) Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isError = true;
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Authorization Required'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.actionDescription),
          const SizedBox(height: 16),
          TextField(
            controller: _pinController,
            obscureText: true,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Admin/Manager PIN',
              errorText: _isError ? 'Invalid PIN or unauthorized role' : null,
            ),
            onSubmitted: (_) => _verify(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _verify,
          child: const Text('Authorize'),
        ),
      ],
    );
  }
}
