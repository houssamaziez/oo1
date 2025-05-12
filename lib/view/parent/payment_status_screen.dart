import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentStatusScreen extends StatefulWidget {
  final List<Map<String, dynamic>> children;
  const PaymentStatusScreen({required this.children});

  @override
  _PaymentStatusScreenState createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<int, bool> paymentStatus = {};
  Map<int, List<Map<String, dynamic>>> paymentHistory = {};

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    for (var child in widget.children) {
      final childId = child['id'];

      // Dernier paiement
      final latest = await supabase
          .from('payments')
          .select('is_paid')
          .eq('child_id', childId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      // Historique
      final history = await supabase
          .from('payments')
          .select()
          .eq('child_id', childId)
          .order('created_at', ascending: false);

      setState(() {
        paymentStatus[childId] = latest?['is_paid'] ?? false;
        paymentHistory[childId] = List<Map<String, dynamic>>.from(history);
      });
    }
  }

  void showHistoryDialog(String childName, List<Map<String, dynamic>> history) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Historique des paiements - $childName'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              final isPaid = entry['is_paid'] == true;
              final date = entry['created_at'];
              final montant = entry['amount'] ?? '---';
              return ListTile(
                title: Text("Montant : $montant DA"),
                subtitle: Text("Date : ${date.toString().split('T')[0]}"),
                trailing: Text(isPaid ? "✅" : "❌"),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void showPaymentForm(String childName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Effectuer un paiement pour $childName"),
        content: Text("Intégration du module de paiement ici."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simuler le paiement ici
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Paiement simulé pour $childName.")),
              );
            },
            child: Text("Payer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statut du paiement"),
        backgroundColor: Color(0xFF345FB4),
      ),
      body: ListView.builder(
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          final child = widget.children[index];
          final name = child['name'] ?? 'Enfant';
          final id = child['id'];
          final isPaid = paymentStatus[id] == true;
          final history = paymentHistory[id] ?? [];

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.child_care, color: Color(0xFF345FB4)),
              title: Text(name),
              subtitle: Text(isPaid
                  ? '✅ Paiement effectué'
                  : '❌ Paiement non effectué'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'historique') {
                    showHistoryDialog(name, history);
                  } else if (value == 'payer') {
                    showPaymentForm(name);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'historique',
                    child: Row(
                      children: [
                        Icon(Icons.history, color: Colors.black54),
                        SizedBox(width: 8),
                        Text("Voir l'historique"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'payer',
                    child: Row(
                      children: [
                        Icon(Icons.payment, color: Colors.black54),
                        SizedBox(width: 8),
                        Text("Effectuer un paiement"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
