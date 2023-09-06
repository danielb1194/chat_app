import 'package:chat_app/widgets/chats/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No chats yet'));
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index < loadedMessages.length - 1
                ? loadedMessages[index + 1].data()
                : null;

            if (nextChatMessage != null &&
                chatMessage['uid'] == nextChatMessage['uid']) {
              return ChatBubble.next(
                message: chatMessage['text'],
                isMe: FirebaseAuth.instance.currentUser!.uid ==
                    chatMessage['uid'],
              );
            } else {
              return ChatBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['userName'],
                message: chatMessage['text'],
                isMe: FirebaseAuth.instance.currentUser!.uid ==
                    chatMessage['uid'],
              );
            }
          },
        );
      },
    );
  }
}
