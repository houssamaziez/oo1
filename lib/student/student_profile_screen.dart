

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentProfileScreen extends StatefulWidget {
  static const routeName = '/student-profile';

  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? studentData;
  bool isEditing = false;

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final gradeController = TextEditingController();
  String? selectedSchoolId;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur non connecté'), backgroundColor: Colors.red),
      );
      return;
    }

    final response = await supabase
        .from('students')
        .select('*, school(name, id)')
        .eq('id', userId)
        .single();

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucune donnée trouvée pour cet utilisateur'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      studentData = response;
      phoneController.text = studentData?['phone'] ?? '';
      emailController.text = studentData?['email'] ?? '';
      gradeController.text = studentData?['grade'] ?? '';
      selectedSchoolId = studentData?['school_id'];
    });
  }

  Future<void> updateStudentData() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur non connecté'), backgroundColor: Colors.red),
      );
      return;
    }

    await supabase
        .from('students')
        .update({
      'phone': phoneController.text,
      'email': emailController.text,
      'grade': gradeController.text,
      'school_id': selectedSchoolId,
    })
        .eq('id', userId);

    await fetchStudentData();

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil mis à jour avec succès'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (studentData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil Élève'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                updateStudentData();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTextField('Téléphone', phoneController),
            buildTextField('Email', emailController),
            buildTextField('Niveau', gradeController),
            const SizedBox(height: 20),
            Text('École', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            if (isEditing)
              DropdownButtonFormField<String>(
                value: selectedSchoolId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: '1', child: Text('École A')),
                  DropdownMenuItem(value: '2', child: Text('École B')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSchoolId = value;
                  });
                },
              )
            else
              Text(
                studentData?['school']?['name'] ?? 'Aucune école',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: isEditing,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrez $label',
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
