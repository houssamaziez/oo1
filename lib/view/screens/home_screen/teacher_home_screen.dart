import 'package:flutter/material.dart';
import 'package:oo/view/student/notifications_screen.dart';
import 'package:oo/view/teacher/CahierDeTexteScreen.dart';
import 'package:oo/view/teacher/ChangePasswordScreen.dart';
import 'package:oo/view/teacher/EmploiDuTempsScreen.dart';
import 'package:oo/view/teacher/ExamResultsScreen.dart';
import 'package:oo/view/teacher/ModifierProfilScreen.dart';
import 'package:oo/view/teacher/MyCoursesScreen.dart';
import 'package:oo/view/teacher/StudentsListScreen.dart';
import 'package:oo/view/teacher/SyllabusScreen.dart';
 // ✅ Import ajouté

import 'MesCoursScreen.dart';
import 'emploi_du_temps_screen.dart';
import 'NotificationsScreen.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);
  static String routeName = 'TeacherHomeScreen';

  @override
  Widget build(BuildContext context) {
    String teacherName = 'Mr. Karim B.';

    // Fonction pour déconnecter l'utilisateur
    void _logout() {
      Navigator.pushReplacementNamed(context, '/login');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER BLEU
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Color(0xFF345FB4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Espace Professeur",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Bienvenue, $teacherName 👋",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // BOUTONS
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: 20),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                HomeCard(
                  icon: Icons.account_circle,
                  title: "Modifier le profil",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ModifierProfilScreen()),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.book,
                  title: "Mes Cours",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MesCoursScreen()),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.assignment,
                  title: "Cahier de texte",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CahierDeTexteScreen()),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.schedule,
                  title: "Emploi du temps",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmploiDuTempsScreen()),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.notifications,
                  title: "Notifications",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsScreen()),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.lock,
                  title: "Mot de Passe",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.logout,
                  title: "Déconnexion",
                  onPress: _logout,
                ),
                HomeCard(
                  icon: Icons.school,
                  title: "Voir les élèves inscrits",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentsListScreen()),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.assignment,
                  title: "Consulter les résultats des examens",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExamResultsScreen()),
                    );
                  },
                ),
                HomeCard(
                  icon: Icons.picture_as_pdf, // ✅ Icône PDF
                  title: "Télécharger le syllabus",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SyllabusScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
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
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF345FB4)),
            SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
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
