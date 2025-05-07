import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oo/parent/parent_profile_screen.dart';
import 'package:oo/parent/payment_status_screen.dart';
import 'attendance_screen.dart';
import 'lesson_compensation_screen.dart';

class ParentHomeScreen extends StatefulWidget {
  static String routeName = 'ParentHomeScreen';
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  String parentName = "";
  String childName = "";
  String photoUrl = 'https://via.placeholder.com/150'; // Valeur par défaut

  @override
  void initState() {
    super.initState();
    fetchParentData();
  }

  Future<void> fetchParentData() async {
    final response =
        await supabase
            .from('parents')
            .select()
            .eq('id', supabase.auth.currentUser!.id)
            .single();

    if (response != null) {
      setState(() {
        parentName = response['name'] ?? "Parent";
        childName = response['child_name'] ?? "Enfant";
        photoUrl = response['photo_url'] ?? 'https://via.placeholder.com/150';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER BLEU AVEC PHOTO
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Color(0xFF345FB4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Texte de bienvenue
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Tableau de bord Parent",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Bienvenue, $parentName 👋",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),

                // Photo de profil
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ParentProfileScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(photoUrl),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // GRID DE CARTES
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: 20),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                ParentCard(
                  icon: Icons.payment,
                  title: "Statut du paiement",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentStatusScreen(),
                        ),
                      ),
                ),
                ParentCard(
                  icon: Icons.book_online,
                  title: "Compensation leçons",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonCompensationScreen(),
                        ),
                      ),
                ),
                ParentCard(
                  icon: Icons.check_circle,
                  title: "Assiduité",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AttendanceScreen()),
                      ),
                ),
                ParentCard(
                  icon: Icons.message,
                  title: "Messages",
                  onTap:
                      () =>
                          Navigator.pushNamed(context, 'ChatWithSchoolScreen'),
                ),
                ParentCard(
                  icon: Icons.assignment,
                  title: "Devoirs",
                  onTap: () => Navigator.pushNamed(context, 'HomeworkScreen'),
                ),
                ParentCard(
                  icon: Icons.grade,
                  title: "Notes",
                  onTap: () => Navigator.pushNamed(context, 'GradesScreen'),
                ),
                ParentCard(
                  icon: Icons.support_agent,
                  title: "Support",
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        'TechnicalSupportScreen',
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET DE CARTE STYLE ADMIN
class ParentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ParentCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF345FB4)),
            SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345FB4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
