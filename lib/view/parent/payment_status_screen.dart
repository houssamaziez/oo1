import 'package:flutter/material.dart';


class PaymentStatusScreen extends StatefulWidget {
  static String routeName = 'PaymentStatusScreen';

  const PaymentStatusScreen({super.key, required List payments, required payment});

  @override
  _PaymentStatusScreenState createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  TextEditingController searchController = TextEditingController();

  // 📜 Liste des cours avec statut de paiement
  List<Map<String, dynamic>> courses = [
    {"name": "Maths", "isPaid": true},
    {"name": "Physique", "isPaid": false},
    {"name": "Informatique", "isPaid": true},
    {"name": "Chimie", "isPaid": false},
  ];
  List<Map<String, dynamic>> filteredCourses = [];

  @override
  void initState() {
    super.initState();
    filteredCourses = courses;
  }

  void filterCourses(String query) {
    setState(() {
      filteredCourses =
          courses
              .where(
                (course) =>
                    course["name"].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // 🌫️ Fond plus doux
      appBar: AppBar(
        title: const Text(
          'Statut du paiement',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo, // 🎨 Harmonisation des couleurs
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔎 Barre de recherche stylisée
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Rechercher un cours",
                labelStyle: TextStyle(color: Colors.grey[800]),
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: filterCourses,
            ),
            const SizedBox(height: 20),

            // 📜 Liste des cours avec le design harmonisé
            Expanded(
              child: ListView.builder(
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  bool isPaid = filteredCourses[index]["isPaid"];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    color: Colors.white, // 🏷️ Fond doux
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      title: Text(
                        filteredCourses[index]["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              isPaid
                                  ? Colors.green[100]
                                  : Colors.red[100], // 🌟 Fond léger
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isPaid ? Icons.check_circle : Icons.cancel,
                          color: isPaid ? Colors.green : Colors.red,
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
