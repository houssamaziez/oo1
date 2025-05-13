import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatWithUserByIdScreen extends StatefulWidget {
  static const String routeName = '/ChatWithUserByIdScreen';
  const ChatWithUserByIdScreen({super.key});

  @override
  State<ChatWithUserByIdScreen> createState() => _ChatWithUserByIdScreenState();
}

class _ChatWithUserByIdScreenState extends State<ChatWithUserByIdScreen> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController receiverIdController = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final senderId = Supabase.instance.client.auth.currentUser?.id;
    final receiverId = receiverIdController.text.trim();

    if (senderId == null || receiverId.isEmpty) return;

    final response = await Supabase.instance.client
        .from('messages')
        .select()
        .or('sender_id.eq.$senderId,receiver_id.eq.$senderId')
        .order('created_at')
        .limit(100);



    setState(() {
      messages = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> sendMessage(String receiverId) async {
    final senderId = Supabase.instance.client.auth.currentUser?.id;
    final content = messageController.text.trim();

    if (senderId == null || content.isEmpty || receiverId.isEmpty) return;

    await Supabase.instance.client.from('messages').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
    });
    await Supabase.instance.client.from('chat').insert({
      'user1_id': senderId,
      'user2_id': receiverId,
      'last_message': content,
      'last_updated':"hi date",
    });

    messageController.clear();
    fetchMessages(); // Refresh messages
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat With User by ID"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: receiverIdController,
              decoration: InputDecoration(
                hintText: 'Enter Receiver ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => fetchMessages(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message['sender_id'] == currentUserId;

                return Align(
                  alignment:
                  isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message['content'],
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          message['created_at'].toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final receiverId = receiverIdController.text.trim();
                    sendMessage(receiverId);
                  },
                  child: const Text("Send"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
