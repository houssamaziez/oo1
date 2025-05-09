import 'package:flutter/material.dart';

class StudentsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> students = [
      {'name': 'Élève 1', 'status': 'Présent', 'performance': 'Bonne'},
      {'name': 'Élève 2', 'status': 'Absent', 'performance': 'Moyenne'},
      {'name': 'Élève 3', 'status': 'Présent', 'performance': 'Excellente'},
      {'name': 'Élève 4', 'status': 'Absent', 'performance': 'Moyenne'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Élèves inscrits',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Color(0xFF345FB4),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                students[index]['name']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    'Statut : ${students[index]['status']}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Text(
                    'Performance : ${students[index]['performance']}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.info_outline, color: Color(0xFF345FB4)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(
                          'Détails de ${students[index]['name']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Statut : ${students[index]['status']}\n'
                              'Performance : ${students[index]['performance']}\n\n'
                              'Historique de participation :\n'
                              '- Présence : 3 fois\n'
                              '- Absence : 1 fois\n'
                              '- Retard : 0 fois',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Fermer', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
