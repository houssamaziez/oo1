import 'package:flutter/material.dart';

class LessonCompensationScreen extends StatefulWidget {
  static String routeName = 'LessonCompensationScreen';

  const LessonCompensationScreen({super.key});

  @override
  _LessonCompensationScreenState createState() => _LessonCompensationScreenState();
}

class _LessonCompensationScreenState extends State<LessonCompensationScreen> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> lessons = [
    {"name": "Maths", "isCompensated": true},
    {"name": "Physique", "isCompensated": false},
    {"name": "Informatique", "isCompensated": true},
    {"name": "Chimie", "isCompensated": false},
  ];
  List<Map<String, dynamic>> filteredLessons = [];

  @override
  void initState() {
    super.initState();
    filteredLessons = lessons;
  }

  void filterLessons(String query) {
    setState(() {
      filteredLessons = lessons
          .where((lesson) => lesson["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Compensation des leçons',
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
                labelText: "Rechercher une leçon",
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: filterLessons,
            ),
            const SizedBox(height: 20),

            // 📜 Liste des leçons
            Expanded(
              child: filteredLessons.isEmpty
                  ? Center(
                child: Text(
                  "Aucune leçon trouvée.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: filteredLessons.length,
                itemBuilder: (context, index) {
                  bool isCompensated = filteredLessons[index]["isCompensated"];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(
                        filteredLessons[index]["name"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isCompensated ? Colors.green[100] : Colors.red[100], // Fond léger
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isCompensated ? Icons.check : Icons.close,
                          color: isCompensated ? Colors.green : Colors.red,
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