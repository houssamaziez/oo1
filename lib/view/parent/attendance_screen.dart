import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  static String routeName = 'AttendanceScreen';

  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> students = [
    {"name": "Amine", "isPresent": true},
    {"name": "Nadia", "isPresent": false},
    {"name": "Yassine", "isPresent": true},
    {"name": "Sofia", "isPresent": false},
  ];
  List<Map<String, dynamic>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
  }

  void filterStudents(String query) {
    setState(() {
      filteredStudents = students
          .where((student) => student["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Assiduité',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔎 Barre de recherche
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Rechercher un élève",
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: filterStudents,
            ),
            const SizedBox(height: 20),

            // 📜 Liste des élèves
            Expanded(
              child: filteredStudents.isEmpty
                  ? Center(
                child: Text(
                  "Aucun élève trouvé.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  bool isPresent = filteredStudents[index]["isPresent"];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(
                        filteredStudents[index]["name"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isPresent ? Colors.green[100] : Colors.red[100], // Fond léger
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isPresent ? Icons.check : Icons.close,
                          color: isPresent ? Colors.green : Colors.red,
                          size: 30,
                        ),
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