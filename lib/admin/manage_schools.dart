import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageSchoolsScreen extends StatefulWidget {
  static const String routeName = '/manageSchools';
  const ManageSchoolsScreen({super.key});

  @override
  _ManageSchoolsScreenState createState() => _ManageSchoolsScreenState();
}

class _ManageSchoolsScreenState extends State<ManageSchoolsScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allSchools = [];
  List<Map<String, dynamic>> filteredSchools = [];

  @override
  void initState() {
    super.initState();
    fetchSchools();
  }

  Future<void> fetchSchools() async {
    final response = await supabase.from('school').select();
    setState(() {
      allSchools = List<Map<String, dynamic>>.from(response);
      filteredSchools = allSchools;
    });
  }

  void _searchSchools(String query) {
    final results = allSchools
        .where((school) => school['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredSchools = results;
    });
  }

  Future<void> _addSchool() async {
    String schoolName = '';
    String directorName = '';
    String schoolAddress = '';

    // Display form for adding a new school
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter une école'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  schoolName = value;
                },
                decoration: InputDecoration(labelText: 'Nom de l\'école'),
              ),
              TextField(
                onChanged: (value) {
                  directorName = value;
                },
                decoration: InputDecoration(labelText: 'Nom du directeur'),
              ),
              TextField(
                onChanged: (value) {
                  schoolAddress = value;
                },
                decoration: InputDecoration(labelText: 'Adresse'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (schoolName.isNotEmpty && directorName.isNotEmpty && schoolAddress.isNotEmpty) {
                  // Insert the new school into Supabase
                  await supabase.from('school').insert({
                    'name': schoolName,
                    'director': directorName,
                    'address': schoolAddress,
                  });
                  fetchSchools(); // Refresh the list of schools
                  Navigator.pop(context);
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editSchool(int id) async {
    String schoolName = filteredSchools[id]['name']!;
    String directorName = filteredSchools[id]['director']!;
    String schoolAddress = filteredSchools[id]['address']!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier une école'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: schoolName),
                onChanged: (value) {
                  schoolName = value;
                },
                decoration: InputDecoration(labelText: 'Nom de l\'école'),
              ),
              TextField(
                controller: TextEditingController(text: directorName),
                onChanged: (value) {
                  directorName = value;
                },
                decoration: InputDecoration(labelText: 'Nom du directeur'),
              ),
              TextField(
                controller: TextEditingController(text: schoolAddress),
                onChanged: (value) {
                  schoolAddress = value;
                },
                decoration: InputDecoration(labelText: 'Adresse'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (schoolName.isNotEmpty && directorName.isNotEmpty && schoolAddress.isNotEmpty) {
                  // Update the school in Supabase
                  await supabase.from('school').update({
                    'name': schoolName,
                    'director': directorName,
                    'address': schoolAddress,
                  }).eq('id', filteredSchools[id]['id']);
                  fetchSchools(); // Refresh the list of schools
                  Navigator.pop(context);
                }
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSchool(int id) async {
    await supabase.from('school').delete().eq('id', id);
    fetchSchools(); // Refresh the list of schools
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette école ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _deleteSchool(id); // Delete the school
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Gérer les écoles"),
        backgroundColor: Color(0xFF345FB4),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addSchool,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher une école',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchSchools,
            ),
          ),
          SizedBox(height: 20),

          // List of schools
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: filteredSchools.length,
                itemBuilder: (context, index) {
                  final school = filteredSchools[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(school['name'] ?? ''),
                      subtitle: Text("Directeur: ${school['director']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editSchool(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _showDeleteConfirmation(index),
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
