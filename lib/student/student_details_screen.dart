// TODO Implement this library.
import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatelessWidget {
  static const String routeName = 'StudentDetailsScreen';
  final String email;
  final String phone;
  final String birthDate;
  final String academicLevel;
  final List<String> courses;
  final double average;
  final int absences;

  const StudentDetailsScreen({
    Key? key,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.academicLevel,
    required this.courses,
    required this.average,
    required this.absences,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails Étudiant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetail('Email', email),
            _buildDetail('Téléphone', phone),
            _buildDetail('Date de naissance', birthDate),
            _buildDetail('Niveau scolaire', academicLevel),
            _buildDetail('Cours suivis', courses.join(', ')),
            _buildDetail('Moyenne générale', '$average / 20'),
            _buildDetail('Nombre d\'absences', '$absences'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blueGrey),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label : $value',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
