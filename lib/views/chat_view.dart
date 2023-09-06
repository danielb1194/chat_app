import 'package:chat_app/widgets/chats/chat_input.dart';
import 'package:chat_app/widgets/chats/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  void requestPermission() async {
    final fbm = FirebaseMessaging.instance;
    await fbm.requestPermission();
    // final token = await fbm.getToken();
    fbm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<bool> _sendMessage(String message) async {
    // TODO: error handling (return false on failure)
    await FirebaseFirestore.instance.collection('chats').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'userName': FirebaseAuth.instance.currentUser!.displayName,
      'userImage': FirebaseAuth.instance.currentUser!.photoURL,
    });
    if (context.mounted) FocusScope.of(context).unfocus();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: ChatList(),
            ),
          ),
          ChatInput(
            onSend: (message) => _sendMessage(message),
          )
        ],
      ),
    );
  }
}
