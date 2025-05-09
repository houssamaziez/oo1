import 'package:flutter/material.dart';

class CahierDeTexteScreen extends StatefulWidget {
  @override
  _CahierDeTexteScreenState createState() => _CahierDeTexteScreenState();
}

class _CahierDeTexteScreenState extends State<CahierDeTexteScreen> {
  // Liste simulée des entrées du cahier de texte
  List<Map<String, String>> entries = [
    {
      'title': 'Chapitre 1 : Addition',
      'content': 'Contenu : Addition des nombres entiers',
    },
    {
      'title': 'Chapitre 2 : Multiplication',
      'content': 'Contenu : Multiplication des nombres entiers',
    },
  ];

  // Fonction pour ajouter une nouvelle entrée
  void _addEntry() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final contentController = TextEditingController();
        return AlertDialog(
          title: Text('Ajouter une entrée', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Titre'),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: 'Contenu'),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  entries.add({
                    'title': titleController.text,
                    'content': contentController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: Text('Ajouter', style: TextStyle(fontSize: 16, color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour modifier une entrée
  void _editEntry(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: entries[index]['title']);
        final contentController = TextEditingController(text: entries[index]['content']);
        return AlertDialog(
          title: Text('Modifier l\'entrée', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Titre'),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: 'Contenu'),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  entries[index] = {
                    'title': titleController.text,
                    'content': contentController.text,
                  };
                });
                Navigator.pop(context);
              },
              child: Text('Modifier', style: TextStyle(fontSize: 16, color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour supprimer une entrée
  void _deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cahier de texte', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Ajouter une entrée
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addEntry,
              child: Text('Ajouter une entrée', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
          // Liste des entrées
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  child: ListTile(
                    title: Text(entry['title']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(entry['content']!, style: TextStyle(fontSize: 16)),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'Modifier':
                            _editEntry(index);
                            break;
                          case 'Supprimer':
                            _deleteEntry(index);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'Modifier',
                          child: Text('Modifier', style: TextStyle(fontSize: 16)),
                        ),
                        PopupMenuItem<String>(
                          value: 'Supprimer',
                          child: Text('Supprimer', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
