// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';

/**
 * Chat page UI
 */
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Chat"));
  }

}