import 'package:flutter/material.dart';
import 'package:oo/view/screens/home_screen/MesCoursScreen.dart';
import 'package:oo/view/student/notifications_screen.dart';
import 'package:oo/view/teacher/CahierDeTexteScreen.dart';
import 'package:oo/view/teacher/ChangePasswordScreen.dart';
import 'package:oo/view/teacher/EmploiDuTempsScreen.dart';
import 'package:oo/view/teacher/ExamResultsScreen.dart';
import 'package:oo/view/teacher/ModifierProfilScreen.dart';

import 'package:oo/view/teacher/StudentsListScreen.dart';
import 'package:oo/view/teacher/SyllabusScreen.dart';
import 'package:oo/view/teacher/add_student_grade_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherHomeScreen extends StatefulWidget {
  static const String routeName = 'TeacherHomeScreen';

  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  String teacherName = "Enseignant";
  String school = "École";
  String photoUrl = 'https://via.placeholder.com/150';

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
  }

  Future<void> fetchTeacherData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await supabase
          .from('teachers')
          .select()
          .eq('id', userId)
          .single();

      if (mounted && response != null) {
        setState(() {
          teacherName = response['full_name'] ?? "Enseignant";
          school = response['school'] ?? "École";
          photoUrl = response['photo_url'] ?? 'https://via.placeholder.com/150';
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des données enseignant : $e');
    }
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                "Teacher Space",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Welcome, $teacherName 👋",
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    HomeCard(icon: Icons.account_circle, title: "Edit profile", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ModifierProfilScreen()));
                    }),
                    HomeCard(icon: Icons.book, title: "Cours", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddCoursePage()));
                    }),
                    HomeCard(icon: Icons.assignment, title: "HomeWork", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CahierDeTexteScreen()));
                    }),
                    HomeCard(icon: Icons.schedule, title: "Timetable", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EmploiDuTempsScreen()));
                    }),
                    HomeCard(icon: Icons.notifications, title: "Notifications", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
                    }),
                    HomeCard(icon: Icons.lock, title: "Passe Word", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                    }),
                    HomeCard(icon: Icons.logout, title: "Logout", onPress: _logout),
                    HomeCard(icon: Icons.school, title: "students list", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentListPage()));
                    }),
                    HomeCard(icon: Icons.assignment, title: "exam result", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudentGradeScreen()));
                    }),
                    HomeCard(icon: Icons.picture_as_pdf, title: "Download the syllabus", onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SyllabusScreen()));
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPress;

  const HomeCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:Colors.black.withOpacity(0.08),
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 3),
            )
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF345FB4)),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345FB4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


