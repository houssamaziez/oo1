import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExamResultsScreen extends StatefulWidget {
  const ExamResultsScreen({Key? key}) : super(key: key);

  @override
  _ExamResultsScreenState createState() => _ExamResultsScreenState();
}

class _ExamResultsScreenState extends State<ExamResultsScreen> {
  // Liste des résultats des examens avec les données initiales
  List<Map<String, String>> examResults = [
    {"student": "Ali Ben", "subject": "Mathématiques", "grade": "15/20", "date": "2025-04-01", "status": "Réussi"},
    {"student": "Sara M.", "subject": "Français", "grade": "18/20", "date": "2025-04-02", "status": "Réussi"},
    {"student": "Youssef T.", "subject": "Sciences", "grade": "10/20", "date": "2025-04-03", "status": "Échoué"},
    {"student": "Lina D.", "subject": "Histoire", "grade": "17/20", "date": "2025-04-04", "status": "Réussi"},
  ];

  // Contrôleurs pour la saisie des informations de l'élève
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  // Méthode pour récupérer les notes pour le graphique
  List<double> getGrades() {
    return examResults.map((result) {
      return double.parse(result["grade"]!.split('/')[0]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Transformer les résultats en notes pour le graphique
    List<double> grades = getGrades();

    return Scaffold(
      appBar: AppBar(
        title: Text("Résultats des examens"),
        backgroundColor: Color(0xFF345FB4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for the buttons at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Afficher une boîte de dialogue pour entrer les informations d'un nouvel étudiant
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Ajouter un étudiant"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: "Nom de l'élève"),
                              ),
                              TextField(
                                controller: _subjectController,
                                decoration: InputDecoration(labelText: "Matière"),
                              ),
                              TextField(
                                controller: _gradeController,
                                decoration: InputDecoration(labelText: "Note (ex: 15/20)"),
                              ),
                              TextField(
                                controller: _dateController,
                                decoration: InputDecoration(labelText: "Date de l'examen"),
                              ),
                              TextField(
                                controller: _statusController,
                                decoration: InputDecoration(labelText: "Statut (Réussi/Échoué)"),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Ajouter l'élève à la liste
                                setState(() {
                                  examResults.add({
                                    "student": _nameController.text,
                                    "subject": _subjectController.text,
                                    "grade": _gradeController.text,
                                    "date": _dateController.text,
                                    "status": _statusController.text,
                                  });
                                });

                                // Fermer la boîte de dialogue et réinitialiser les champs
                                Navigator.pop(context);
                                _nameController.clear();
                                _subjectController.clear();
                                _gradeController.clear();
                                _dateController.clear();
                                _statusController.clear();
                              },
                              child: Text("Ajouter"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Fermer la boîte de dialogue sans ajouter d'élève
                                Navigator.pop(context);
                              },
                              child: Text("Annuler"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Ajouter un étudiant", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF345FB4),
                    foregroundColor: Colors.white, // Texte en blanc
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Revenir à l'écran précédent
                  },
                  child: Text("Retour", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF345FB4),
                    foregroundColor: Colors.white, // Texte en blanc
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Résultats des examens",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345FB4),
              ),
            ),
            SizedBox(height: 20),
            // Affichage du graphique
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: grades.map((grade) {
                    return BarChartGroupData(
                      x: grades.indexOf(grade),
                      barRods: [
                        BarChartRodData(
                          toY: grade,
                          color: grade >= 10 ? Colors.green : Colors.red, // Rouge si < 10, vert si >= 10
                          width: 15,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Liste des résultats
            Expanded(
              child: ListView.builder(
                itemCount: examResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    child: ListTile(
                      title: Text(examResults[index]["student"]!),
                      subtitle: Text(
                        "${examResults[index]["subject"]} - ${examResults[index]["grade"]} - ${examResults[index]["date"]} - ${examResults[index]["status"]}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
