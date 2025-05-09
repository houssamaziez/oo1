import 'package:flutter/material.dart';

class MesCoursScreen extends StatelessWidget {
  final List<Map<String, dynamic>> courses = [
    {
      'nom': 'Mathématiques',
      'niveau': '3ème',
      'nombreEleves': 30,
      'horaire': 'Lundi 10h-12h',
      'lieu': 'Salle 101',
    },
    {
      'nom': 'Français',
      'niveau': '2ème',
      'nombreEleves': 25,
      'horaire': 'Mardi 14h-16h',
      'lieu': 'Salle 203',
    },
    {
      'nom': 'Physique',
      'niveau': '1ère',
      'nombreEleves': 28,
      'horaire': 'Jeudi 08h-10h',
      'lieu': 'Salle 305',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Cours', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Text(course['nom'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Text(
                  'Niveau: ${course['niveau']} - ${course['nombreEleves']} élèves',
                  style: TextStyle(fontSize: 14),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'Voir Détails':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailsScreen(course: course),
                          ),
                        );
                        break;
                      case 'Ajouter un Cours':
                        _addCourse(context);
                        break;
                      case 'Marquer l\'absence':
                        _markAbsence(context, course);
                        break;
                      case 'Consulter les Notes':
                        _viewNotes(context, course);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'Voir Détails', child: Text('Voir Détails du Cours', style: TextStyle(fontSize: 16))),
                    PopupMenuItem(value: 'Ajouter un Cours', child: Text('Ajouter un Cours', style: TextStyle(fontSize: 16))),
                    PopupMenuItem(value: 'Marquer l\'absence', child: Text('Marquer l\'Absence', style: TextStyle(fontSize: 16))),
                    PopupMenuItem(value: 'Consulter les Notes', child: Text('Consulter les Notes', style: TextStyle(fontSize: 16))),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _addCourse(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un Cours', style: TextStyle(fontSize: 18)),
          content: TextField(
            decoration: InputDecoration(hintText: 'Nom du Cours', hintStyle: TextStyle(fontSize: 16)),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler', style: TextStyle(fontSize: 16))),
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Ajouter', style: TextStyle(fontSize: 16))),
          ],
        );
      },
    );
  }

  void _markAbsence(BuildContext context, Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Marquer l\'absence pour ${course['nom']}', style: TextStyle(fontSize: 18)),
          content: Text('Sélectionnez les élèves absents', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler', style: TextStyle(fontSize: 16))),
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Marquer', style: TextStyle(fontSize: 16))),
          ],
        );
      },
    );
  }

  void _viewNotes(BuildContext context, Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notes pour ${course['nom']}', style: TextStyle(fontSize: 18)),
          content: Text('Affichage des notes des élèves pour ce cours', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Fermer', style: TextStyle(fontSize: 16))),
          ],
        );
      },
    );
  }
}

// Écran des détails d’un cours
class CourseDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Cours'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course['nom'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Niveau : ${course['niveau']}', style: TextStyle(fontSize: 16)),
                Text('Horaire : ${course['horaire']}', style: TextStyle(fontSize: 16)),
                Text('Lieu : ${course['lieu']}', style: TextStyle(fontSize: 16)),
                Text('Nombre d\'élèves inscrits : ${course['nombreEleves']}', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
