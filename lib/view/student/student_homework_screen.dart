import 'package:flutter/material.dart';

class StudentHomeworkScreen extends StatelessWidget {
  static const String routeName = 'StudentHomeworkScreen';

  final List<Map<String, String>> homeworkList;

  const StudentHomeworkScreen({super.key, required this.homeworkList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Devoirs")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: homeworkList.length,
        itemBuilder: (context, index) {
          final homework = homeworkList[index];
          return Card(
            child: ListTile(
              title: Text(homework['subject']!),
              subtitle: Text("À faire pour le ${homework['dueDate']}"),
            ),
          );
        },
      ),
    );
  }
}
