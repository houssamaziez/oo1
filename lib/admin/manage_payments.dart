import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManagePaymentsScreen extends StatefulWidget {
  static const String routeName = '/managePayments';
  const ManagePaymentsScreen({super.key});

  @override
  _ManagePaymentsScreenState createState() => _ManagePaymentsScreenState();
}

class _ManagePaymentsScreenState extends State<ManagePaymentsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> payments = [];
  List<Map<String, dynamic>> filteredPayments = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    final response = await supabase
        .from('pyment')
        .select('id, amount, status, created_at, students(full_name)')
        .order('created_at', ascending: false);

    setState(() {
      payments = List<Map<String, dynamic>>.from(response);
      filteredPayments = payments;
    });
  }

  void _filterPayments(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredPayments =
          payments.where((payment) {
            final studentName =
                (payment['students']['full_name'] ?? '').toLowerCase();
            return studentName.contains(searchQuery);
          }).toList();
    });
  }

  Future<void> _addPayment(
    String studentId,
    double amount,
    String status,
  ) async {
    try {
      final response = await supabase.from('pyment').insert({
        'student_id': studentId,
        // 'id' : DateTime.now().toIso8601String(),
        'amount': amount,
        'status': status,
        'pyment_date':
            DateTime.now().toIso8601String(), // better format for timestamps
        'created_at': DateTime.now().toIso8601String(), // if required
      });
    } catch (e) {
      print(e);
    }
    _fetchPayments();
  }

  Future<void> _deletePayment(String id) async {
    await supabase.from('payments').delete().eq('id', id);
    _fetchPayments();
  }

  Future<void> _updatePayment(String id, String status) async {
    await supabase.from('payments').update({'status': status}).eq('id', id);
    _fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("💳 Gestion des paiements"),
        backgroundColor: Color(0xFF345FB4),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddPaymentDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: filteredPayments.length,
              itemBuilder: (context, index) {
                final payment = filteredPayments[index];
                final studentName =
                    payment['students']['full_name'] ?? 'Inconnu';
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      "Élève: $studentName",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Montant: ${payment['amount']} | Statut: ${payment['status']}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing:
                        payment['status'] == 'Payé'
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.cancel, color: Colors.red),
                    onTap:
                        () => _updatePayment(
                          payment['id'],
                          payment['status'] == 'Payé' ? 'Non payé' : 'Payé',
                        ),
                    onLongPress: () => _deletePayment(payment['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: _filterPayments,
        decoration: InputDecoration(
          hintText: 'Rechercher par nom...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  void _showAddPaymentDialog() {
    final studentController = TextEditingController();
    final amountController = TextEditingController();
    String status = 'Non payé';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text(
                  "Ajouter un paiement",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: studentController,
                      decoration: InputDecoration(
                        labelText: "Nom de l'élève",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: "Montant",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: status,
                      style: TextStyle(color: Colors.black),
                      onChanged: (newValue) {
                        setState(() {
                          status = newValue!;
                        });
                      },
                      items:
                          ['Payé', 'Non payé']
                              .map(
                                (statusOption) => DropdownMenuItem<String>(
                                  value: statusOption,
                                  child: Text(statusOption),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Annuler"),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (studentController.text.isNotEmpty &&
                          amountController.text.isNotEmpty) {
                        var response;
                        try {
                          response =
                              await supabase
                                  .from('students')
                                  .select('id')
                                  .eq('full_name', studentController.text)
                                  .single();
                        } catch (e) {
                          print(e);
                        }

                        if (response != null) {
                          final studentId = response['id'];
                          try {
                            await _addPayment(
                              studentId,
                              double.parse(amountController.text),
                              status,
                            );
                          } catch (e) {
                            print(e);
                          }
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Étudiant non trouvé.")),
                          );
                        }
                      }
                    },
                    child: Text("Ajouter"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
