import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:oo/components/custom_buttons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = 'SignUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime? _selectedDate;
  String? _gender;
  String? _userType;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1960),
      lastDate: DateTime(2024),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade900,
              onPrimary: Colors.blue.shade900,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final user = response.user;
        if (user != null) {
          final userId = user.id;
          final fullName = _fullNameController.text.trim();
          final gender = _gender;
          final dob = _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : null;
          final userType = _userType;

          final data = {
            'id': userId,
            'full_name': fullName,
            'gender': gender,
            'date_of_birth': dob,
          };

          if (userType == "Student") {
            await Supabase.instance.client.from('students').insert(data);
          } else if (userType == "Parent") {
            await Supabase.instance.client.from('parents').insert(data);
          } else if (userType == "Teacher") {
            await Supabase.instance.client.from('teachers').insert(data);
          } else if (userType == "Admin") {
            await Supabase.instance.client.from('admins').insert(data);
          }

          await Supabase.instance.client.from('profiles').insert({
            'id': userId,
            'user_type': userType,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-up successful!')),
          );

          if (userType == "Student") {
            Navigator.pushReplacementNamed(context, 'myprofile');
          } else {
            Navigator.pop(context);
          }
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 4,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildInput(_emailController, 'Email', Icons.email),
                  SizedBox(height: 2.h),
                  _buildInput(_fullNameController, 'Full Name', Icons.person),
                  SizedBox(height: 2.h),
                  _buildInput(_passwordController, 'Password', Icons.lock,
                      isPassword: true),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildInput(
                        TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        ),
                        'Date of Birth',
                        Icons.calendar_today,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0), // remplacé 2.h par valeur fixe pour cohérence

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey, // Texte noir
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white, // Fond blanc
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey), // Bordure noire
                        ),
                        child: DropdownButton<String>(
                          value: _gender,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          isExpanded: true,
                          underline: const SizedBox(), // Enlève la ligne par défaut
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black),
                          items: ['Male', 'Female'].map((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _gender = val!);
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                  DropdownButtonFormField<String>(
                    value: _userType,
                    style: const TextStyle(color: Colors.black),
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'User Type',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['Student', 'Teacher', 'Parent', 'Admin']
                        .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, style: const TextStyle(color: Colors.black)),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => _userType = val),
                    validator: (val) => val == null ? 'Please choose User Type' : null,
                  ),

                  SizedBox(height: 2.h),
                  DefaultButton(
                    title: 'Create Account',
                    iconData: Icons.person_add,
                    onPress: _signUp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade900),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items
          .map((item) =>
          DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Please choose $label' : null,
    );
  }
}
