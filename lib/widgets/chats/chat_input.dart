import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.onSend});

  final Future<bool> Function(String message) onSend;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String? _newMessage;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text('Enter a message'),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  _newMessage = value;
                  return null;
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_form.currentState!.validate() &&
                  _newMessage != null &&
                  _newMessage!.isNotEmpty) {
                await widget.onSend(_newMessage!);
                _form.currentState!.reset();
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
