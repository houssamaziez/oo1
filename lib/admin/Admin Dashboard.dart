import 'package:flutter/material.dart';
import '../screens/Signup_Screen/Signup_Screen.dart';
import '../screens/login_screen/login_screen.dart';
import 'manageStudents.dart';
import 'manageSyllabus.dart';
import 'manage_users.dart';
import 'manage_schools.dart';
import 'manage_payments.dart';
import 'view_data.dart';
import 'manage_notifications.dart';
import 'add_student_grade_screen.dart'; // ✅ Import de l'écran d'ajout des notes

class AdminDashboard extends StatelessWidget {
  static const String routeName = '/adminDashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc comme le login
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
                Row(
                  children: [
                    Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },

                      icon: Icon(Icons.logout, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "Bienvenue, Admin 👋",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // ESPACE ENTRE LE HEADER ET LES BOUTONS
          SizedBox(height: 20),

          // BOUTONS ADMIN
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: 20),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                AdminCard(
                  icon: Icons.group,
                  title: "Gérer les utilisateurs",
                  route: ManageUsersScreen.routeName,
                ),
                AdminCard(
                  icon: Icons.school,
                  title: "Gérer les écoles",
                  route: ManageSchoolsScreen.routeName,
                ),
                AdminCard(
                  icon: Icons.payment,
                  title: "Gérer les paiements",
                  route: ManagePaymentsScreen.routeName,
                ),
                AdminCard(
                  icon: Icons.bar_chart,
                  title: "Voir les données",
                  route: ViewDataScreen.routeName,
                ),
                AdminCard(
                  icon: Icons.notifications,
                  title: "Gérer les notifications",
                  route: ManageNotificationsScreen.routeName,
                ),
                AdminCard(
                  icon: Icons.people,
                  title: "Liste des étudiants",
                  route: ManageStudentsScreen.routeName,
                ),
                AdminCard(
                  icon: Icons.book,
                  title: "Liste des syllabus",
                  route: ManageSyllabusScreen.routeName,
                ),
                AdminCard(
                  icon: Icons.grade,
                  title: "Ajouter Note Élève", // ✅ Nouvelle carte
                  route:
                      AddStudentGradeScreen
                          .routeName, // Assure-toi que ce routeName est bien défini
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

// WIDGET POUR LES BOUTONS
class AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const AdminCard({
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
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
