import 'package:flutter/material.dart';
import 'package:oo/admin/ManageStudentsScreen.dart';
import 'package:oo/view/screens/login_screen/login_screen.dart';

import '../view/chat_view/chatscreen_list.dart';
import '../view/chat_view/list_user.dart';
import 'manageSyllabus.dart';

import 'manage_users.dart';
import 'manage_schools.dart';
import 'manage_payments.dart';
import 'view_data.dart';
import 'manage_notifications.dart';




class AdminDashboard extends StatelessWidget {
  static const String routeName = '/adminDashboard';

  final Gradient backgroundGradient = const LinearGradient(
    colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              height: 160,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Welcome, Admin 👋",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // CARTES
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.95, // ⬅️ Plus petit que 1 pour rétrécir
                children: [
                  AdminCard(icon: Icons.group, title: "Manage users", route: ManageUsersScreen.routeName),
                  AdminCard(icon: Icons.school, title: "Managing schools", route: ManageSchoolsScreen.routeName),
                  AdminCard(icon: Icons.payment, title: "Manage payments", route: ManagePaymentsScreen.routeName),
                  AdminCard(icon: Icons.bar_chart, title: "View the data", route: ViewDataScreen.routeName),
                  AdminCard(icon: Icons.notifications, title: "Manage notifications", route: ManageNotificationsScreen.routeName),
                  AdminCard(icon: Icons.people, title: "List of students", route: ManageStudentsScreen.routeName),
                  AdminCard(icon: Icons.book, title: "List of syllabuses", route: ManageSyllabusScreen.routeName),
                  AdminCard(icon: Icons.book, title: "chat", route: UserListScreen.routeName),




                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

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
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF345FB4)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF345FB4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

