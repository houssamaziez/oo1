import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageUsersScreen extends StatefulWidget {
  static const String routeName = '/manageUsers';

  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  String? selectedRole = 'student'; // Valeur par défaut pour le rôle
  String genderController = 'Homme'; // ✅ Valeur par défaut pour le genre

  @override
  void initState() {
    super.initState();
    fetchUsers();
    searchController.addListener(_filterUsers);
  }

  // Récupérer les utilisateurs depuis Supabase
  Future<void> fetchUsers() async {
    final response = await supabase.from('users').select();
    setState(() {
      allUsers = List<Map<String, dynamic>>.from(response);
      filteredUsers = allUsers;
    });
  }

  // Filtrer les utilisateurs selon le texte de recherche
  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers.where((user) {
        final name = user['name']?.toLowerCase() ?? '';
        final role = user['role']?.toLowerCase() ?? '';
        return name.contains(query) || role.contains(query);
      }).toList();
    });
  }

  // Ajouter un utilisateur
  Future<void> addUser(String name, String email, String role) async {
    if (name.isEmpty || email.isEmpty) {
      // Validation pour s'assurer que le nom et l'email ne sont pas vides
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nom et email sont requis')),
      );
      return;
    }

    final data = {
      'name': name,
      'email': email,
      'role': role,
      'gender': genderController, // ✅ Utilisation correcte
    };

    if (role == 'student') {
      final res = await supabase.from('students').insert(data);
      print("Added student: $res");
    } else if (role == 'teacher') {
      final res = await supabase.from('teachers').insert(data);
      print("Added teacher: $res");
    } else if (role == 'parent') {
      final res = await supabase.from('parents').insert(data);
      print("Added parent: $res");
    }

    fetchUsers();
  }

  // Modifier un utilisateur
  Future<void> editUser(int id, String name, String role) async {
    if (name.isEmpty) {
      // Validation pour s'assurer que le nom n'est pas vide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le nom ne peut pas être vide')),
      );
      return;
    }

    await supabase.from('users').update({
      'name': name,
      'role': role,
    }).eq('id', id);
    fetchUsers();
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(int id) async {
    await supabase.from('users').delete().eq('id', id);
    fetchUsers();
  }

  // Afficher la boîte de dialogue pour ajouter ou modifier un utilisateur
  void showUserDialog({Map<String, dynamic>? user}) {
    final nameController = TextEditingController(text: user?['name']);
    final emailController = TextEditingController(text: user?['email']);
    selectedRole = user?['role'] ?? 'student'; // Par défaut 'student' si non défini
    genderController = user?['gender'] ?? 'Homme'; // Récupérer le genre existant s’il existe

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? 'Ajouter un utilisateur' : 'Modifier utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nom')),
            if (user == null)
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            DropdownButtonFormField<String>(
              value: genderController,
              onChanged: (val) => setState(() => genderController = val!),
              items: ['Homme', 'Femme']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              decoration: InputDecoration(labelText: 'Genre'),
            ),
            DropdownButton<String>(
              value: selectedRole,
              onChanged: (val) => setState(() => selectedRole = val!),
              items: ['student', 'teacher', 'parent']
                  .map((r) => DropdownMenuItem(
                  value: r, child: Text(r[0].toUpperCase() + r.substring(1))))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (user == null) {
                addUser(nameController.text, emailController.text, selectedRole!);
              } else {
                editUser(user['id'], nameController.text, selectedRole!);
              }
              Navigator.pop(context);
            },
            child: Text(user == null ? 'Ajouter' : 'Modifier'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("👥 Gestion des utilisateurs"),
        backgroundColor: Color(0xFF345FB4),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showUserDialog(),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF345FB4),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Rechercher par nom ou rôle...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(child: Text('Aucun utilisateur trouvé'))
                  : ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    width: screenWidth * 0.9,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: user['gender'] == 'Homme'
                            ? Icon(Icons.man, color: Colors.blue)
                            : Icon(Icons.woman, color: Colors.pink),
                        title: Text(user['name'], style: TextStyle(fontSize: 16)),
                        subtitle: Text("Rôle: ${user['role']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => showUserDialog(user: user),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteUser(user['id']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
