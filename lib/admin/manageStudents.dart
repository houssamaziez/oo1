import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageStudentsScreen extends StatefulWidget {
  static const String routeName = '/manageStudents';

  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> students = [
    {'id': '1', 'full_name': 'Ali Ahmed', 'class': 'Classe A'},
    {'id': '2', 'full_name': 'Sara Benali', 'class': 'Classe B'},
    {'id': '3', 'full_name': 'Mohamed Zidane', 'class': 'Classe C'},
  ];
  List<Map<String, dynamic>> filteredStudents = [];
  bool isLoading = false;
  String searchQuery = "";
  String selectedFilter = "Tous";

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
  }

  void filterStudents(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredStudents = students.where((student) {
        final name = (student['full_name'] ?? '').toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  void filterByCategory(String category) {
    setState(() {
      selectedFilter = category;
      if (category == "Tous") {
        filteredStudents = students;
      } else {
        filteredStudents = students.where((student) => student['class'] == category).toList();
      }
    });
  }

  void deleteStudent(String id) {
    setState(() {
      students.removeWhere((student) => student['id'] == id);
      filteredStudents = students;
    });
  }

  void markAttendance(String id) {
    print("Présence enregistrée pour l'étudiant ID: $id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Color(0xFF345FB4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Gestion des étudiants",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Rechercher, filtrer et gérer les étudiants",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  onChanged: filterStudents,
                  decoration: InputDecoration(
                    labelText: "Rechercher un étudiant",
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFF345FB4),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF345FB4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<String>(
                    dropdownColor: Color(0xFF345FB4),
                    value: selectedFilter,
                    items: ["Tous", "Classe A", "Classe B", "Classe C"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.white)),
                    ))
                        .toList(),
                    onChanged: (value) => filterByCategory(value!),
                    underline: SizedBox(),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredStudents.isEmpty
                ? Center(child: Text("Aucun étudiant trouvé"))
                : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF345FB4),
                        child: Text(
                          student['full_name']?[0] ?? '?',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      title: Text(
                        student['full_name'] ?? 'No Name',
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        "Classe: ${student['class'] ?? 'N/A'}",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            print("Modifier: ${student['id']}");
                          } else if (value == 'delete') {
                            deleteStudent(student['id']);
                          } else if (value == 'presence') {
                            markAttendance(student['id']);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'edit', child: Text("Modifier")),
                          PopupMenuItem(value: 'delete', child: Text("Supprimer")),
                          PopupMenuItem(value: 'presence', child: Text("Marque Présence")),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
