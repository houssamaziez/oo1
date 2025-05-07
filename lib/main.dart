import 'package:oo/parent/chat_with_school_screen.dart';
import 'package:oo/parent/grades_screen.dart';
import 'package:oo/parent/homework_screen.dart';
import 'package:oo/parent/technical_support_screen.dart';
import 'package:oo/routes.dart';
import 'package:oo/screens/Signup_Screen/Signup_Screen.dart';
import 'package:oo/screens/my_profile/my_profile.dart';
import 'package:oo/screens/password/CreateNewPasswordScreen.dart';
import 'package:oo/student/edit_student_profile_screen.dart';
import 'package:oo/student/notifications_screen.dart';
import 'package:oo/student/student_attendance_screen.dart';
import 'package:oo/student/student_contact_screen.dart';
import 'package:oo/student/student_details_screen.dart';
import 'package:oo/student/student_profile_screen.dart';
import 'package:oo/student/student_results_screen.dart';
import 'package:oo/student/student_support_screen.dart';
import 'package:oo/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin/Admin Dashboard.dart';

import 'admin/manage_users.dart';
import 'admin/manageStudents.dart';
import 'admin/manage_notifications.dart';
import 'admin/manage_payments.dart';
import 'admin/manage_schools.dart';
import 'admin/view_data.dart';
import 'screens/student_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tzitjtxfxpehavjnemka.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6aXRqdHhmeHBlaGF2am5lbWthIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUyNjc3MjYsImV4cCI6MjA2MDg0MzcyNn0.81-9b5-IBtW_cOGw8o0NzMVGG5v91xJ9XylgMA0zUeY',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, device) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'School Brain',
          theme: CustomTheme().baseTheme,
          initialRoute: SplashScreen.routeName,
          routes: {
            ...routes,
            SignUpScreen.routeName: (context) => SignUpScreen(),
            AdminDashboard.routeName: (context) => AdminDashboard(),
            ManageNotificationsScreen.routeName:
                (context) => ManageNotificationsScreen(),
            ManageUsersScreen.routeName: (context) => ManageUsersScreen(),
            ManageSchoolsScreen.routeName: (context) => ManageSchoolsScreen(),
            ManagePaymentsScreen.routeName: (context) => ManagePaymentsScreen(),
            ViewDataScreen.routeName: (context) => ViewDataScreen(),
            ManageStudentsScreen.routeName: (context) => ManageStudentsScreen(),
            MyProfileScreen.routeName: (context) => MyProfileScreen(),
            MyProfileScreen.routeName: (context) => const MyProfileScreen(),
            'StudentProfile': (context) => StudentProfileScreen(),
            'SignUpScreen': (_) => SignUpScreen(),
            'HomeworkScreen': (context) => const HomeworkScreen(),
            'GradesScreen': (context) => const GradesScreen(),
            'ChatWithSchoolScreen': (context) => const ChatWithSchoolScreen(),
            'TechnicalSupportScreen':
                (context) => const TechnicalSupportScreen(),
            StudentContactScreen.routeName: (context) => StudentContactScreen(),
            StudentResultsScreen.routeName:
                (context) => StudentResultsScreen(studentId: ''),
            EditStudentProfileScreen.routeName:
                (context) =>
                    EditStudentProfileScreen(name: '', email: '', phone: ''),
            NotificationsScreen.routeName: (context) => NotificationsScreen(),
            StudentAttendanceScreen.routeName:
                (context) => StudentAttendanceScreen(),
            StudentDetailsScreen.routeName:
                (context) => StudentDetailsScreen(
                  email: '',
                  phone: '',
                  birthDate: '',
                  academicLevel: '',
                  courses: [],
                  absences: 0, // Default value
                  average: 0.0,
                ),
            StudentSupportScreen.routeName: (context) => StudentSupportScreen(),
          },
        );
      },
    );
  }
}
