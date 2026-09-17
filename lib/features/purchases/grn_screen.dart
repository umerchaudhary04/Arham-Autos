import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GrnScreen extends ConsumerStatefulWidget {
  const GrnScreen({super.key});

  @override
  ConsumerState<GrnScreen> createState() => _GrnScreenState();
}

class _GrnScreenState extends ConsumerState<GrnScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Purchases & GRN (Goods Receipt Note)', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inventory, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Select Supplier to begin GRN Flow'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // In real app, open GRN Form
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('GRN structural implementation')));
                    },
                    child: const Text('New GRN Entry'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
