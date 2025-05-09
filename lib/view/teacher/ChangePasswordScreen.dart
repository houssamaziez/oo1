import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _oldPassword = "ancienMotDePasse"; // Exemple de mot de passe actuel (à remplacer par une logique d'authentification réelle)

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Fonction pour changer le mot de passe
  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Vérification de l'ancien mot de passe
      if (_oldPasswordController.text == _oldPassword) {
        // Vérification que le nouveau mot de passe et la confirmation sont identiques
        if (_newPasswordController.text == _confirmPasswordController.text) {
          // Logique pour changer le mot de passe (par exemple, mise à jour dans la base de données)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mot de passe changé avec succès')));
          Navigator.pop(context); // Retour à l'écran précédent après la réussite
        } else {
          // Afficher un message si les mots de passe ne correspondent pas
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Les mots de passe ne correspondent pas')));
        }
      } else {
        // Afficher un message si l'ancien mot de passe est incorrect
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('L\'ancien mot de passe est incorrect')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Changer le mot de passe'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champ pour l'ancien mot de passe
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: _obscureOldPassword,
                  decoration: InputDecoration(
                    labelText: 'Ancien mot de passe',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blueGrey),
                      onPressed: () {
                        setState(() {
                          _obscureOldPassword = !_obscureOldPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'ancien mot de passe';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Champ pour le nouveau mot de passe
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'Nouveau mot de passe',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blueGrey),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nouveau mot de passe';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Champ pour confirmer le nouveau mot de passe
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blueGrey),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre nouveau mot de passe';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Changer le mot de passe',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
