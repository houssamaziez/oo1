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
    final backgroundGradient = const LinearGradient(
      colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 40),
                  Text(
                    "Liste des étudiants",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Rechercher, filtrer, et marquer la présence",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // RECHERCHE & FILTRE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: filterStudents,
                      style: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                      decoration: const InputDecoration(
                        hintText: "Rechercher un étudiant",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      underline: const SizedBox(),
                      isExpanded: true,
                      style: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                      items: ["Tous", "Classe A", "Classe B", "Classe C"]
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (value) => filterByCategory(value!),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // LISTE
            Expanded(
              child: filteredStudents.isEmpty
                  ? const Center(child: Text("Aucun étudiant trouvé", style: TextStyle(fontFamily: 'Poppins')))
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    final id = student['id'];
                    final presence = attendanceStatus[id];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF345FB4),
                          child: Text(
                            student['full_name']?[0] ?? '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          student['full_name'] ?? 'No Name',
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        ),
                        subtitle: Text(
                          "Classe: ${student['class'] ?? 'N/A'}",
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (presence == "present")
                              const Icon(Icons.check_circle, color: Colors.green)
                            else if (presence == "absent")
                              const Icon(Icons.cancel, color: Colors.red)
                            else
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () => markAttendance(id, "present"),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
