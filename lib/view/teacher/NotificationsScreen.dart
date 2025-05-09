import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: NotificationsScreen(),
    routes: {
      '/alerts': (context) => AlertScreen(),
      '/settings': (context) => SettingsScreen(),
    },
  ));
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, String>> notifications = [
    {
      'titre': 'Changement d’horaire',
      'contenu': 'Le cours de Math est déplacé à 10h.',
      'date': '11 Avril',
      'status': 'Non lu',
      'category': 'Cours',
    },
    {
      'titre': 'Résultats disponibles',
      'contenu': 'Vos résultats du semestre sont disponibles.',
      'date': '10 Avril',
      'status': 'Lu',
      'category': 'Annonces',
    },
    {
      'titre': 'Rappel devoir',
      'contenu': 'Remettez votre devoir d’histoire avant le 15 Avril.',
      'date': '08 Avril',
      'status': 'Non lu',
      'category': 'Devoirs',
    },
    {
      'titre': 'Nouvel examen',
      'contenu': 'Examen de physique prévu le 20 Avril à 14h.',
      'date': '07 Avril',
      'status': 'Lu',
      'category': 'Examen',
    },
  ];

  bool _pushNotificationEnabled = true;
  bool _emailNotificationEnabled = false;

  void _showNotificationDetails(Map<String, String> notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification['titre']!, style: TextStyle(fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contenu: ${notification['contenu']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Date: ${notification['date']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Statut: ${notification['status']}', style: TextStyle(fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  notification['status'] = 'Lu';
                });
                Navigator.of(context).pop();
              },
              child: Text('Marquer comme lu', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _sendNotification(String message, String recipientType) {
    print('Envoyer notification à $recipientType : $message');
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void _archiveNotification(int index) {
    print('Notification archivée : ${notifications[index]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontSize: 22)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: notif['status'] == 'Lu'
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: Icon(
                        notif['category'] == 'Cours'
                            ? Icons.book
                            : notif['category'] == 'Examen'
                            ? Icons.event
                            : Icons.notifications,
                        color: notif['status'] == 'Lu'
                            ? Colors.green
                            : Colors.red,
                        size: 32,
                      ),
                      title: Text(
                        notif['titre']!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          notif['contenu']!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      trailing: Text(
                        notif['date']!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      onTap: () => _showNotificationDetails(notif),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Notifications Push', style: TextStyle(fontSize: 16)),
                    value: _pushNotificationEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _pushNotificationEnabled = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Notifications par Email', style: TextStyle(fontSize: 16)),
                    value: _emailNotificationEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _emailNotificationEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              String selectedRecipient = 'Classe entière';
              String selectedType = 'Rappel de devoir';
              String message = '';

              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 20,
                    right: 20,
                    top: 20),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Envoyer une notification',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedRecipient,
                          decoration:
                          InputDecoration(labelText: 'Destinataires'),
                          items: ['Classe entière', 'Élève spécifique', 'Parents']
                              .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedRecipient = value!;
                            });
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedType,
                          decoration:
                          InputDecoration(labelText: 'Type de notification'),
                          items: [
                            'Rappel de devoir',
                            'Changement d’horaire',
                            'Absence',
                            'Annonces'
                          ]
                              .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                        TextField(
                          decoration:
                          InputDecoration(labelText: 'Contenu'),
                          maxLines: 3,
                          onChanged: (value) {
                            message = value;
                          },
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: Icon(Icons.send),
                          label: Text('Envoyer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _sendNotification(
                                '[$selectedType] $message', selectedRecipient);
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
        child: Icon(Icons.send),
        backgroundColor: Colors.blueAccent,
        tooltip: 'Envoyer Notification',
      ),
    );
  }
}

class AlertScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une Alerte', style: TextStyle(fontSize: 22)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Titre de l\'alerte'),
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description de l\'alerte'),
              style: TextStyle(fontSize: 16),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Choisir les destinataires'),
              items: ['Classe entière', 'Élève spécifique', 'Parents']
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(fontSize: 16)),
              ))
                  .toList(),
              onChanged: (value) {},
            ),
            ElevatedButton(
              onPressed: () {
                print('Alerte envoyée');
              },
              child: Text('Envoyer l\'alerte', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotificationEnabled = true;
  bool _emailNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres', style: TextStyle(fontSize: 22)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Notifications Push', style: TextStyle(fontSize: 16)),
              value: _pushNotificationEnabled,
              onChanged: (bool value) {
                setState(() {
                  _pushNotificationEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Notifications par Email', style: TextStyle(fontSize: 16)),
              value: _emailNotificationEnabled,
              onChanged: (bool value) {
                setState(() {
                  _emailNotificationEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}