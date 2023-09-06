import 'dart:io';

import 'package:chat_app/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class SignupForm extends StatefulWidget {
  const SignupForm({super.key, required this.onSwitchSelector});

  final VoidCallback onSwitchSelector;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _isLoading = false;

  String? _email;
  String? _password;
  File? _image;
  String? _userName;

  void _register() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    if (_image == null) {
      // TODO: show error message 'Please pick an image'
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await _firebase.createUserWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${_firebase.currentUser!.uid}.jpg');
      await storageRef.putFile(_image!);
      final url = await storageRef.getDownloadURL();
      await _firebase.currentUser!.updatePhotoURL(url);
      await _firebase.currentUser!.updateDisplayName(_userName!);

      FirebaseFirestore.instance
          .collection('users')
          .doc(_firebase.currentUser!.uid)
          .set({
        'email': _email,
        'image_url': url,
        'username': _userName,
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

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
    // setState(() {
    //   _isLoading = true;
    // });

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 162, 254, 165),
        content: Text(
          'User created. Welcome!',
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
            ImagePicker((pickedImage) => _image = pickedImage),
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
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Username'),
                // border: OutlineInputBorder(),
              ),
              obscureText: true,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a username';
                } else if (value.length < 4) {
                  return 'Username must be at least 4 characters';
                }
                _userName = value;
                return null;
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: widget.onSwitchSelector,
                        child: const Text('Log in'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _register,
                        child: const Text('Register'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
