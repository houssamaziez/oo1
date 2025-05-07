// TODO Implement this library.
import 'package:flutter/material.dart';

class ViewDataScreen extends StatelessWidget {
  static const String routeName = '/viewData';
  const ViewDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader("📊 Statistiques"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatCard("Nombre d'élèves", "42", Icons.school),
                  SizedBox(height: 10),
                  _buildStatCard("Présences ce mois", "350", Icons.check_circle_outline),
                  SizedBox(height: 10),
                  _buildStatCard("Paiements effectués", "39", Icons.credit_score),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF345FB4)),
        title: Text(title),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFF345FB4),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
