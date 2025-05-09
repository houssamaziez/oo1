import 'package:flutter/material.dart';

class StudentSupportScreen extends StatelessWidget {
  static const String routeName = 'StudentSupportScreen';
  const StudentSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support Technique")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Décrivez votre problème ci-dessous :"),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Votre message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Message envoyé au support")),
                );
              },
              child: const Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }
}
