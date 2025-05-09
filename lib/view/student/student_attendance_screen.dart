import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentAttendanceScreen extends StatefulWidget {
  static const String routeName = 'StudentAttendanceScreen';




  @override
  _StudentAttendanceScreenState createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  static const String routeName = 'StudentAttendanceScreen';
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    final response = await supabase
        .from('attendance')
        .select('date, present')
        .order('date', ascending: false);

    setState(() {
      attendanceList = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Présence"), backgroundColor: Colors.blueAccent),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: attendanceList.length,
        itemBuilder: (context, index) {
          final item = attendanceList[index];
          final present = item['present'] as bool;
          final date = item['date'] as String;

          Color? cardColor;
          Color iconColor;
          IconData iconData;

          if (present) {
            cardColor = Colors.green[100];
            iconColor = Colors.green;
            iconData = Icons.check_circle;
          } else {
            cardColor = Colors.red[100];
            iconColor = Colors.red;
            iconData = Icons.cancel;
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: cardColor,
            child: ListTile(
              title: Text(date),
              trailing: Icon(
                iconData,
                color: iconColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
