import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserListScreen extends StatefulWidget {
  static const String routeName = '/UserListScreen';

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await supabase
        .from('profiles')
        ; // Remove any `_execute()` method here

    if (response.error == null) {
      setState(() {
        users = response.data;
      });
    } else {
      print('Error fetching users: ${response.error?.message}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user['full_name']),
            subtitle: Text('User Type: ${user['user_type']}'),
            onTap: () {
              // Handle user click (optional)
              // You can navigate to a profile page or perform any action
            },
          );
        },
      ),
    );
  }
}
