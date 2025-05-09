import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageStudentsScreen extends StatefulWidget {
  static const String routeName = '/manageStudents';

  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> filteredStudents = [];
  Map<String, String> attendanceStatus = {}; // id => "present" or "absent"
  bool isLoading = false;
  String searchQuery = "";
  String selectedFilter = "Tous";

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    setState(() => isLoading = true);
    final response = await supabase.from('students').select();

    if (response != null) {
      setState(() {
        students = List<Map<String, dynamic>>.from(response);
        filteredStudents = students;
        isLoading = false;
      });
    }
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

  void markAttendance(String id, String status) {
    setState(() {
      attendanceStatus[id] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Rechercher, filtrer et marquer la présence",
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                // Recherche & filtre
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

                // Liste étudiants
                Expanded(
                  child: filteredStudents.isEmpty
                      ? Center(child: Text("Aucun étudiant trouvé"))
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = filteredStudents[index];
                              final id = student['id'];
                              final presence = attendanceStatus[id];

                              return Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (presence == "present")
                                        Icon(Icons.check_circle, color: Colors.green)
                                      else if (presence == "absent")
                                        Icon(Icons.cancel, color: Colors.red)
                                      else
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.check, color: Colors.green),
                                              onPressed: () => markAttendance(id, "present"),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close, color: Colors.red),
                                              onPressed: () => markAttendance(id, "absent"),
                                            ),
                                          ],
                                        ),
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
