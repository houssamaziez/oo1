import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // Pour sélectionner une image depuis la galerie ou la caméra
import 'dart:io';

class ModifierProfilScreen extends StatefulWidget {
  @override
  _ModifierProfilScreenState createState() => _ModifierProfilScreenState();
}

class _ModifierProfilScreenState extends State<ModifierProfilScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  File? _image;

  // Fonction pour choisir une image depuis la galerie ou la caméra
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);  // Utilise 'ImageSource.camera' pour la caméra

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);  // Stocke l'image dans le fichier
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le Profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo de profil
              Center(
                child: GestureDetector(
                  onTap: _pickImage,  // Lorsque l'utilisateur clique sur la photo
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : null,  // Affiche l'image si elle existe
                    child: _image == null
                        ? Icon(Icons.camera_alt, color: Colors.white, size: 40)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Champ pour le nom
              Text('Nom', style: TextStyle(fontSize: 18)),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Entrez votre nom'),
              ),
              SizedBox(height: 20),

              // Champ pour l'email
              Text('Email', style: TextStyle(fontSize: 18)),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Entrez votre email'),
              ),
              SizedBox(height: 20),

              // Champ pour le téléphone
              Text('Téléphone', style: TextStyle(fontSize: 18)),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(hintText: 'Entrez votre téléphone'),
              ),
              SizedBox(height: 20),

              // Champ pour l'adresse
              Text('Adresse', style: TextStyle(fontSize: 18)),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(hintText: 'Entrez votre adresse'),
              ),
              SizedBox(height: 20),

              // Bouton pour sauvegarder les informations
              ElevatedButton(
                onPressed: () {
                  // Logique pour sauvegarder les modifications
                  String name = _nameController.text;
                  String email = _emailController.text;
                  String phone = _phoneController.text;
                  String address = _addressController.text;

                  // Affichage des informations modifiées (ou toute autre logique, par exemple, sauvegarde dans la base de données)
                  print('Nom: $name');
                  print('Email: $email');
                  print('Téléphone: $phone');
                  print('Adresse: $address');

                  // Retourner à l'écran précédent après la sauvegarde
                  Navigator.pop(context);
                },
                child: Text('Sauvegarder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
