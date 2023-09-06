import 'package:chat_app/widgets/auth/login_form.dart';
import 'package:chat_app/widgets/auth/signup_form.dart';
import 'package:flutter/material.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _selector = true;

  void _toggleSelector() {
    setState(() {
      _selector = !_selector;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: _selector
                      ? LoginForm(onSwitchSelector: _toggleSelector)
                      : SignupForm(onSwitchSelector: _toggleSelector),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
