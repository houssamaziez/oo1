import 'package:flutter/material.dart';

class ChatWithSchoolScreen extends StatefulWidget {
  static const String routeName = 'ChatWithSchoolScreen';

  const ChatWithSchoolScreen({super.key});

  @override
  State<ChatWithSchoolScreen> createState() => _ChatWithSchoolScreenState();
}

class _ChatWithSchoolScreenState extends State<ChatWithSchoolScreen> {
  final List<Map<String, dynamic>> messages = [
    {"text": "Bonjour, quand aura lieu la réunion ?", "fromParent": true},
    {"text": "Demain à 10h. Merci !", "fromParent": false},
  ];

  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add({"text": text, "fromParent": true});
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Discussion avec l'école", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['fromParent'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: message['fromParent'] ? Colors.purple[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message['text']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Écrire un message...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.purple),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}