import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParentChatScreen extends StatefulWidget {
  final String parentId;
  final String serviceId;

  const ParentChatScreen({
    Key? key,
    required this.parentId,
    required this.serviceId,
  }) : super(key: key);

  @override
  _ParentChatScreenState createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  late final Stream<List<Map<String, dynamic>>> _messageStream;

  @override
  void initState() {
    super.initState();
    _messageStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('sender_id', widget.parentId)
        .or('receiver_id.eq.${widget.parentId}')
        .order('created_at')
        .map((data) => data.map((e) => e as Map<String, dynamic>).toList());
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    await supabase.from('messages').insert({
      'sender_id': widget.parentId,
      'receiver_id': widget.serviceId,
      'content': text,
    });

    _messageController.clear();
  }

  bool isMyMessage(Map<String, dynamic> message) {
    return message['sender_id'] == widget.parentId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Chat avec Service"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;

                final filteredMessages = messages.where((message) =>
                (message['sender_id'] == widget.parentId && message['receiver_id'] == widget.serviceId) ||
                    (message['sender_id'] == widget.serviceId && message['receiver_id'] == widget.parentId)
                ).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    final message = filteredMessages[index];
                    final isMine = isMyMessage(message);

                    return Align(
                      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMine ? Colors.purple[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message['content'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
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
                    controller: _messageController,
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
                  onPressed: () => sendMessage(_messageController.text),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

extension on SupabaseStreamBuilder {
  or(String s) {}
}
