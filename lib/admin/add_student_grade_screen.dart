import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddStudentGradeScreen extends StatefulWidget {
  static const String routeName = '/addStudentGrade';
  const AddStudentGradeScreen({Key? key}) : super(key: key);

  @override
  _AddStudentGradeScreenState createState() => _AddStudentGradeScreenState();
}

class _AddStudentGradeScreenState extends State<AddStudentGradeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _gradeController = TextEditingController();
  final _evaluationController = TextEditingController();
  DateTime? _selectedDate;

  List<Map<String, dynamic>> _students = [];
  String? _selectedStudentId;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final response = await Supabase.instance.client.from('students').select('id, full_name');
      setState(() {
        _students = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement des étudiants : $e')),

      );
    }
  }
  


  Future<void> _submitGrade() async {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedStudentId != null) {
      final subject = _subjectController.text.trim();
      final grade = double.tryParse(_gradeController.text.trim());
      final evaluation = _evaluationController.text.trim();
      final date = _selectedDate!.toIso8601String();

      if (grade == null || grade < 0 || grade > 20) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid score between 0 and 20.')),
        );
        return;
      }

      try {
        await Supabase.instance.client.from('grades').insert({
          'student_id': _selectedStudentId,
          'subject': subject,
          'grade': grade,
          'evaluation': evaluation,
          'date': date,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note ajoutée avec succès.')),
        );

        _formKey.currentState!.reset();
        _subjectController.clear();
        _gradeController.clear();
        _evaluationController.clear();
        setState(() {
          _selectedDate = null;
          _selectedStudentId = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une date.')),
      );
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _gradeController.dispose();
    _evaluationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Colors.blue[900];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add a note'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildStudentDropdown(),
              _buildTextField(_subjectController, 'Matter'),
              _buildTextField(_gradeController, 'Rating (/20)', TextInputType.number),
              _buildTextField(_evaluationController, 'Type of assessment (e.g. Examination, Control)'),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : 'Date : ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today, color: primaryBlue),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitGrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Required field' : null,
      ),
    );
  }

  Widget _buildStudentDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedStudentId,
        items: _students.map((student) {
          return DropdownMenuItem<String>(
            value: student['id'],
            child: Text(student['full_name']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedStudentId = value;
          });
        },

        decoration: InputDecoration(
          labelText: 'Select Student',
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (value) => value == null ? 'Please select a student' : null,
      ),
    );
  }
}

