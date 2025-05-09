import 'package:flutter/material.dart';

class StudentContactScreen extends StatefulWidget {
  static const String routeName = 'StudentContactScreen';

  final String? contactType; // optionnel, peut être utilisé pour pré-sélectionner
  const StudentContactScreen({this.contactType});

  @override
  _StudentContactScreenState createState() => _StudentContactScreenState();
}

class _StudentContactScreenState extends State<StudentContactScreen> {
  final _formKey = GlobalKey<FormState>();
  String _recipient = 'admin';
  String _subject = '';
  String _message = '';

  @override
  void initState() {
    super.initState();
    if (widget.contactType != null) {
      _recipient = widget.contactType!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacter ${_recipient == 'teacher' ? 'un enseignant' : 'l\'administration'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _recipient,
                decoration: InputDecoration(
                  labelText: 'Destinataire',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'admin', child: Text('Administration')),
                  DropdownMenuItem(value: 'teacher', child: Text('Enseignant')),
                ],
                onChanged: (value) {
                  setState(() {
                    _recipient = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Sujet',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un sujet';
                  }
                  return null;
                },
                onSaved: (value) => _subject = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un message';
                  }
                  return null;
                },
                onSaved: (value) => _message = value!,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.send),
                label: Text('Envoyer'),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Exemple : envoyer le message à Supabase ou autre système
      print('Destinataire : $_recipient');
      print('Sujet : $_subject');
      print('Message : $_message');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message envoyé à $_recipient avec succès !')),
      );

      // Tu peux aussi fermer l'écran après envoi
      // Navigator.pop(context);
    }
  }
}
