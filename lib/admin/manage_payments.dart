import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManagePaymentsScreen extends StatefulWidget {
  static const String routeName = '/managePayments';
  const ManagePaymentsScreen({super.key});

  @override
  State<ManagePaymentsScreen> createState() => _ManagePaymentsScreenState();
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
      filteredPayments = payments.where((payment) {
        final studentName = (payment['students']['full_name'] ?? '').toLowerCase();
        return studentName.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _addPayment(String studentId, double amount, String status) async {
    await supabase.from('pyment').insert({
      'student_id': studentId,
      'amount': amount,
      'status': status,
      'pyment_date': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    });
    _fetchPayments();
  }

  Future<void> _deletePayment(String id) async {
    await supabase.from('pyment').delete().eq('id', id);
    _fetchPayments();
  }

  Future<void> _updatePayment(String id, String status) async {
    await supabase.from('pyment').update({'status': status}).eq('id', id);
    _fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("💳 Payment Management"),
        backgroundColor: const Color(0xFF345FB4),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddPaymentDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredPayments.length,
              itemBuilder: (context, index) {
                final payment = filteredPayments[index];
                final studentName = payment['students']['full_name'] ?? 'Inconnu';
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      "👤 Élève : $studentName",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "💰 Montant: ${payment['amount']} DA\n📌 Statut: ${payment['status']}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      payment['status'] == 'Paid' ? Icons.check_circle : Icons.cancel,
                      color: payment['status'] == 'Paid' ? Colors.green : Colors.red,
                    ),
                    onTap: () {
                      final newStatus = payment['status'] == 'Paid' ? 'No Paid' : 'Paid';
                      _updatePayment(payment['id'], newStatus);
                    },
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
          hintText: '🔍 Rechercher un élève...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _showAddPaymentDialog() {
    final studentController = TextEditingController();
    final amountController = TextEditingController();
    String status = 'No Paid';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("➕ Ajouter un paiement"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: studentController,
                  decoration: const InputDecoration(
                    labelText: "Nom de l'élève",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Montant",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(
                    labelText: "Statut",
                    border: OutlineInputBorder(),
                  ),
                  items: ['Paid', 'No Paid'].map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (val) => setState(() => status = val ?? 'No Paid'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Ajouter"),
              onPressed: () async {
                if (studentController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  try {
                    final response = await supabase
                        .from('students')
                        .select('id')
                        .eq('full_name', studentController.text)
                        .single();

                    if (response != null) {
                      await _addPayment(
                        response['id'],
                        double.parse(amountController.text),
                        status,
                      );
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("❌ Élève introuvable.")),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

