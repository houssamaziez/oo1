import 'package:flutter/material.dart';

class GradesScreen extends StatelessWidget {
  static const String routeName = 'GradesScreen';
  const GradesScreen({super.key});

  final List<Map<String, dynamic>> grades = const [
    {"subject": "Maths", "grade": 16},
    {"subject": "Physique", "grade": 13},
    {"subject": "Anglais", "grade": 18},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Notes de l’élève", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: grades.length,
        itemBuilder: (context, index) {
          final grade = grades[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo[100],
                child: const Icon(Icons.grade, color: Colors.indigo),
              ),
              title: Text(grade["subject"], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text("${grade["grade"]}/20", style: const TextStyle(fontSize: 18)),
            ),
          );
        },
      ),
    );
  }
}