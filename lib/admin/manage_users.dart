import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageUsersScreen extends StatefulWidget {
  static const String routeName = '/manageusers';
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);
    final response = await supabase.from('users').select();
    setState(() {
      users = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  Future<void> deleteUser(String id) async {
    await supabase.from('users').delete().eq('id', id);
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage users'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['email']),
                  subtitle: Text('Rôle: ${user['role']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteUser(user['id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter la logique pour créer un nouvel utilisateur
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
