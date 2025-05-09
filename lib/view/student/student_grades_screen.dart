import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentGradesScreen extends StatefulWidget {
  static const String routeName = 'StudentGradesScreen';
  const StudentGradesScreen({Key? key}) : super(key: key);

  @override
  _StudentGradesScreenState createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchGrades() async {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final response = await supabase
        .from('grades')
        .select()
        .eq('student_id', userId)
        .order('subject', ascending: true);

    return response;
  }

  IconData getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
      case 'mathématiques':
        return Icons.calculate;
      case 'physique':
        return Icons.science;
      case 'informatique':
        return Icons.computer;
      case 'français':
        return Icons.menu_book;
      case 'histoire':
        return Icons.account_balance;
      case 'anglais':
        return Icons.language;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mes Notes"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchGrades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final grades = snapshot.data;

          if (grades == null || grades.isEmpty) {
            return const Center(child: Text("Aucune note disponible."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: grades.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final grade = grades[index];
              final subject = grade['subject'] ?? 'Inconnu';
              final score = grade['grade']?.toString() ?? '--';
              final date = grade['date']?.toString().split('T').first ?? '';

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(getSubjectIcon(subject), size: 40, color: Colors.blue[900]),
                      const SizedBox(height: 10),
                      Text(
                        subject,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Note : $score',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date : $date',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
