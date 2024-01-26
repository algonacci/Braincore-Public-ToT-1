import 'package:flutter/material.dart';
import 'chat_page.dart'; 

class FineTunedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChatPage(
      title: 'Fine-Tuned',
      model: 'ft:gpt-3.5-turbo-0613:braincore::8OMgZumY',
    );
  }
}
