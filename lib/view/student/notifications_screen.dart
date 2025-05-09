import 'package:flutter/material.dart';
import 'package:oo/admin/manage_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 // Assure-toi d'importer l'écran d'envoi

class NotificationsScreen extends StatefulWidget {
  static const String routeName = 'NotificationsScreen';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> notifications = [];
  bool isLoading = true;

  // Tu peux utiliser une variable globale ou vérifier le user_type Supabase ici
  final bool isAdmin = true; // Remplace par une vraie vérification plus tard

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await supabase
          .from('notifications')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        notifications = response;
        isLoading = false;
      });
    } catch (error) {
      print('Erreur lors de la récupération: $error');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des notifications')),
      );
    }
  }

  void _showNotificationDetails(BuildContext context, Map<String, dynamic> notif) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notif['title'] ?? ''),
          content: Text(notif['message'] ?? 'Aucun message'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _goToManageNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ManageNotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue.shade600,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('Aucune notification trouvée.'))
              : ListView.builder(
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
                        onTap: () => _showNotificationDetails(context, notif),
                      ),
                    );
                  },
                ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: _goToManageNotifications,
              backgroundColor: Colors.blue.shade600,
              child: Icon(Icons.add),
              tooltip: 'Ajouter une notification',
            )
          : null,
    );
  }
}
