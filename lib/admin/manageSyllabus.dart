import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageSyllabusScreen extends StatefulWidget {
  static const String routeName = '/manageSyllabus';

  @override
  _ManageSyllabusScreenState createState() => _ManageSyllabusScreenState();
}

class _ManageSyllabusScreenState extends State<ManageSyllabusScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> syllabusList = [
    {'id': '1', 'subject': 'Mathématiques', 'year': '2024', 'description': 'Algèbre et géométrie.'},
    {'id': '2', 'subject': 'Science', 'year': '2024', 'description': 'Biologie et chimie.'},
    {'id': '3', 'subject': 'Histoire', 'year': '2024', 'description': 'Histoire ancienne et moderne.'},
  ];
  List<Map<String, dynamic>> filteredSyllabus = [];
  String searchQuery = "";
  String selectedFilter = "Tous";

  @override
  void initState() {
    super.initState();
    filteredSyllabus = List.from(syllabusList);
  }

  void filterSyllabus(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredSyllabus = syllabusList.where((s) {
        final subject = (s['subject'] ?? '').toLowerCase();
        return subject.contains(searchQuery);
      }).toList();
    });
  }

  void filterBySubject(String subject) {
    setState(() {
      selectedFilter = subject;
      if (subject == "Tous") {
        filteredSyllabus = syllabusList;
      } else {
        filteredSyllabus = syllabusList.where((s) => s['subject'] == subject).toList();
      }
    });
  }

  void deleteSyllabus(String id) {
    setState(() {
      syllabusList.removeWhere((s) => s['id'] == id);
      filteredSyllabus = List.from(syllabusList);
    });
  }

  void editSyllabus(String id) {
    print("Modification du syllabus ID: $id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("📋 Gestion des syllabus")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  onChanged: filterSyllabus,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    labelText: "Rechercher un syllabus",
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: ["Tous", "Mathématiques", "Science", "Histoire"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => filterBySubject(value!),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredSyllabus.isEmpty
                ? Center(child: Text("Aucun syllabus trouvé"))
                : ListView.builder(
              itemCount: filteredSyllabus.length,
              itemBuilder: (context, index) {
                final syllabus = filteredSyllabus[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(syllabus['subject'] ?? 'Matière inconnue'),
                    subtitle: Text("Année: ${syllabus['year']}\n${syllabus['description']}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') editSyllabus(syllabus['id']);
                        if (value == 'delete') deleteSyllabus(syllabus['id']);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text("✏️ Modifier")),
                        PopupMenuItem(value: 'delete', child: Text("🗑 Supprimer")),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class StudentListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> students = [
    {'name': 'Ali', 'presence': 15},
    {'name': 'Sara', 'presence': 10},
    {'name': 'Karim', 'presence': 20},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("👩‍🎓 Liste des étudiants")),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(student['name']),
              subtitle: Text("Présences ce mois-ci: ${student['presence']}"),
            ),
          );
        },
      ),
    );
  }
}
