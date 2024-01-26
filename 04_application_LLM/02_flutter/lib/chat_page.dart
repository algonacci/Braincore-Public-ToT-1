import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

class ChatPage extends StatefulWidget {
  final String title;
  final String model;

  const ChatPage({Key? key, required this.title, required this.model})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();

  Future<String> generateText(String userMessage) async {
    const apiKey = '';
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": userMessage},
          ],
          "max_tokens": 4000,
          "model": widget.model,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final generatedText = data['choices'][0]['message']['content'];
        return generatedText;
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to generate text');
      }
    } catch (error) {
      print('Error generating text: $error');
      throw Exception('Failed to generate text');
    }
  }

  void handleUserMessage(String message) {
    setState(() {
      messages.add(Message(message, true));
    });

    // Generate response from OpenAI
    generateText(message).then((response) {
      setState(() {
        messages.add(Message(response, false));
      });
    }).catchError((error) {
      setState(() {
        messages.add(Message('Error generating text', false));
      });
    });

    messageController.clear();
  }

  void resetChat() {
    setState(() {
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetChat,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: message.isUser ? Colors.blue : Colors.black,
                    ),
                  ),
                  dense: true,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final userMessage = messageController.text;
                    if (userMessage.isNotEmpty) {
                      handleUserMessage(userMessage);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
