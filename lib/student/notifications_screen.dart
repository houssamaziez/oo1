import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = 'NotificationsScreen';
  final List<Map<String, String>> notifications = [
    {'title': 'Devoir de maths pour lundi', 'source': 'Professeur'},
    {'title': 'Réunion parents-prof', 'source': 'Administration'},
    {'title': 'Mise à jour de l\'emploi du temps', 'source': 'Professeur'},
    {'title': 'Résultats disponibles', 'source': 'Admin'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue.shade600,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.notifications, color: Colors.blue.shade700),
              ),
              title: Text(
                notif['title'] ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Par : ${notif['source']}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // TODO: Ajouter navigation ou détails si besoin
              },
            ),
          );
        },
      ),
    );
  }
}
