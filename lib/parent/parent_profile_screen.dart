import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'parent_home_screen.dart';

class ParentProfileScreen extends StatefulWidget {
  static const String routeName = 'ParentProfileScreen';

  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;
  final _scrollController = ScrollController();
  final Uuid _uuid = const Uuid();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  int _numberOfChildren = 1;
  final List<TextEditingController> _childNameControllers = [];
  final List<TextEditingController> _studyYearControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeChildrenFields(_numberOfChildren);
  }

  void _initializeChildrenFields(int count) {
    for (var controller in _childNameControllers) {
      controller.dispose();
    }
    for (var controller in _studyYearControllers) {
      controller.dispose();
    }
    _childNameControllers.clear();
    _studyYearControllers.clear();

    for (int i = 0; i < count; i++) {
      _childNameControllers.add(TextEditingController());
      _studyYearControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _scrollController.dispose();
    _initializeChildrenFields(0);
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      await _scrollToTop();
      return;
    }

    try {
      if (_fullNameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneController.text.isEmpty) {
        throw Exception('Veuillez remplir tous les champs du parent.');
      }

      bool hasValidChild = _childNameControllers.any(
            (controller) => controller.text.trim().isNotEmpty,
      );
      if (!hasValidChild) {
        throw Exception('Veuillez ajouter au moins un enfant.');
      }

      final parentId = _uuid.v4();

      final parentResponse = await _supabase.from('parents').insert({
        'id': parentId,
        'full_name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      }).select();

      if (parentResponse.isEmpty) {
        throw Exception('Échec lors de la création du parent.');
      }

      final childrenData = <Map<String, dynamic>>[];
      for (int i = 0; i < _childNameControllers.length; i++) {
        final name = _childNameControllers[i].text.trim();
        if (name.isEmpty) continue;

        childrenData.add({
          'parent_id': parentId,
          'child_name': name,
          'study_year': int.tryParse(_studyYearControllers[i].text) ?? 0,
        });
      }

      if (childrenData.isNotEmpty) {
        await _supabase.from('children').insert(childrenData);
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, ParentHomeScreen.routeName);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
      await _scrollToTop();
    }
  }

  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profil du Parent"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCard(
                title: "Informations du parent",
                children: [
                  _buildTextField(
                    label: 'Nom complet',
                    icon: Icons.person,
                    controller: _fullNameController,
                    isRequired: true,
                  ),
                  _buildTextField(
                    label: 'Email',
                    icon: Icons.email,
                    controller: _emailController,
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    label: 'Téléphone',
                    icon: Icons.phone,
                    controller: _phoneController,
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                title: "Informations des enfants",
                children: [
                  _buildTextField(
                    label: 'Nombre d’enfants',
                    icon: Icons.child_care,
                    controller: TextEditingController(text: _numberOfChildren.toString()),
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    onChanged: (value) {
                      final count = int.tryParse(value) ?? 1;
                      if (count > 0 && count <= 10) {
                        setState(() {
                          _numberOfChildren = count;
                          _initializeChildrenFields(count);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_numberOfChildren, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enfant ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          label: 'Nom de l’enfant',
                          icon: Icons.badge,
                          controller: _childNameControllers[index],
                          isRequired: true,
                        ),
                        _buildTextField(
                          label: 'Année d’étude',
                          icon: Icons.school,
                          controller: _studyYearControllers[index],
                          keyboardType: TextInputType.number,
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                child: const Text(
                  'Valider l’inscription',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.indigo),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'Ce champ est requis';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}