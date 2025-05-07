import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:printing/printing.dart';

class EmploiDuTempsScreen extends StatefulWidget {
  @override
  _EmploiDuTempsScreenState createState() => _EmploiDuTempsScreenState();
}

class _EmploiDuTempsScreenState extends State<EmploiDuTempsScreen> {
  final Map<String, List<Map<String, String>>> emploiDuTemps = {
    'Lundi': [
      {'matière': 'Mathématiques', 'horaire': '8h00 - 9h30', 'classe': '3ème A'},
      {'matière': 'Français', 'horaire': '10h00 - 11h30', 'classe': '4ème B'},
    ],
    'Mardi': [
      {'matière': 'Histoire', 'horaire': '8h00 - 9h30', 'classe': '2ème C'},
      {'matière': 'Anglais', 'horaire': '10h00 - 11h30', 'classe': '3ème A'},
    ],
    'Mercredi': [
      {'matière': 'Sciences', 'horaire': '8h00 - 9h30', 'classe': '5ème D'},
    ],
    'Jeudi': [
      {'matière': 'Informatique', 'horaire': '9h00 - 10h30', 'classe': 'Terminale S'},
    ],
    'Vendredi': [
      {'matière': 'Philosophie', 'horaire': '8h30 - 10h00', 'classe': 'Première L'},
    ],
  };

  int currentWeekOffset = 0;

  void _showNotification(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text(message, style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(fontSize: 16, color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Emploi du Temps', style: pw.TextStyle(fontSize: 24)),
          ...emploiDuTemps.entries.map((entry) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(entry.key, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ...entry.value.map((cours) => pw.Text(
                '${cours['matière']} - ${cours['horaire']} - Classe: ${cours['classe']}',
                style: pw.TextStyle(fontSize: 16),
              )),
              pw.SizedBox(height: 10),
            ],
          )),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  String getWeekLabel() {
    DateTime now = DateTime.now().add(Duration(days: currentWeekOffset * 7));
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 4));
    return '${DateFormat('dd MMM').format(startOfWeek)} - ${DateFormat('dd MMM').format(endOfWeek)}';
  }

  void _nextWeek() {
    setState(() {
      currentWeekOffset++;
    });
  }

  void _previousWeek() {
    setState(() {
      currentWeekOffset--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emploi du temps', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _exportToPDF,
            tooltip: 'Exporter en PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: _previousWeek, icon: Icon(Icons.arrow_back)),
                Text('Semaine: ${getWeekLabel()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                IconButton(onPressed: _nextWeek, icon: Icon(Icons.arrow_forward)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: emploiDuTemps.keys.map((jour) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        jour,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    Column(
                      children: emploiDuTemps[jour]!.map((item) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.schedule, color: Colors.indigo),
                            title: Text(
                              '${item['matière']}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Horaire: ${item['horaire']} - Classe: ${item['classe']}',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.notifications, size: 25, color: Colors.blue),
                              onPressed: () {
                                _showNotification('Le cours de ${item['matière']} a été modifié.');
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
