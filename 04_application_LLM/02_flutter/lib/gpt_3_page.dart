import 'package:flutter/material.dart';
import 'chat_page.dart'; 

class GPT3Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChatPage(
      title: 'GPT-3',
      model: 'gpt-3.5-turbo',
    );
  }
}
