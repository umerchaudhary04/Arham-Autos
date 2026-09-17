import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/auth_provider.dart';
import '../../core/security/idle_lock_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _usePin = true;
  String _pin = '';
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onPinPadPressed(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
      });
    }
  }

  void _onPinDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _submitPin() async {
    final success = await ref.read(authProvider.notifier).loginWithPin(_pin);
    if (!mounted) return;
    if (success) {
      ref.read(idleLockProvider.notifier).resetTimer();
    } else {
      setState(() => _pin = '');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid PIN')));
    }
  }

  void _submitPassword() async {
    final success = await ref.read(authProvider.notifier).loginWithPassword(
      _usernameController.text, 
      _passwordController.text
    );
    if (!mounted) return;
    if (success) {
      ref.read(idleLockProvider.notifier).resetTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.teal),
              const SizedBox(height: 32),
              
              if (_usePin) ...[
                Text('Enter PIN', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Text('*' * _pin.length, style: const TextStyle(fontSize: 48, letterSpacing: 8)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2,
                  children: [
                    for (int i = 1; i <= 9; i++)
                      ElevatedButton(
                        onPressed: () => _onPinPadPressed(i.toString()),
                        child: Text(i.toString(), style: const TextStyle(fontSize: 24)),
                      ),
                    ElevatedButton(
                      onPressed: _onPinDelete,
                      child: const Icon(Icons.backspace),
                    ),
                    ElevatedButton(
                      onPressed: () => _onPinPadPressed('0'),
                      child: const Text('0', style: TextStyle(fontSize: 24)),
                    ),
                    ElevatedButton(
                      onPressed: _submitPin,
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              ] else ...[
                Text('Admin Login', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
                const SizedBox(height: 8),
                TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _submitPassword, child: const Text('Login')),
              ],

              const SizedBox(height: 32),
              TextButton(
                onPressed: () => setState(() => _usePin = !_usePin),
                child: Text(_usePin ? 'Switch to Password Login' : 'Switch to PIN Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
