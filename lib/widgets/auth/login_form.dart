import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onSwitchSelector});

  final VoidCallback onSwitchSelector;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String? _email;

  String? _password;

  void _login() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    // _form.currentState!.save();

    // log the user in via firebase
    try {
      await _firebase.signInWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An unknown error occurred'),
        ),
      );

      return;
    }

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 162, 254, 165),
        content: Text(
          'Logged in. Welcome!',
          style: const TextStyle().copyWith(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Email'),
                // border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an email';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                _email = value;
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Password'),
                // border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                _password = value;
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: widget.onSwitchSelector,
                  child: const Text('Register'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
