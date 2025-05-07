import 'package:flutter/material.dart';

class HomeworkScreen extends StatelessWidget {
  const HomeworkScreen({super.key});

  final List<Map<String, String>> homeworkList = const [
    {"subject": "Maths", "task": "Exercice 5 page 23"},
    {"subject": "Physique", "task": "Rédiger un rapport"},
    {"subject": "Français", "task": "Lecture chapitre 2"},
  ];





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Suivi des devoirs", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: homeworkList.length,
        itemBuilder: (context, index) {
          final item = homeworkList[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal[100],
                child: const Icon(Icons.assignment, color: Colors.teal),
              ),
              title: Text(item["subject"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item["task"]!),
            ),
          );
        },
      ),
    );
  }
}