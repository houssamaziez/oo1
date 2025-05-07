import 'package:oo/parent/parent_home_screen.dart';
import 'package:oo/parent/parent_profile_screen.dart';
import 'package:oo/screens/admin/Manage_Users.dart';
import 'package:oo/screens/home_screen/parent_home_screen.dart';
import 'package:oo/screens/home_screen/teacher_home_screen.dart';
import 'package:oo/screens/login_screen/login_screen.dart';
import 'package:oo/screens/my_profile/profile.dart';
import 'package:oo/screens/splash_screen/splash_screen.dart';
import 'package:oo/student/student_attendance_screen.dart';
import 'package:oo/student/student_grades_screen.dart';
import 'package:oo/student/student_home_screen.dart';
import 'package:oo/student/student_profile_screen.dart';
import 'package:oo/student/student_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'admin/Admin Dashboard.dart';
import 'admin/add_student_grade_screen.dart';
import 'admin/manageStudents.dart';
import 'admin/manageSyllabus.dart';
import 'admin/manage_payments.dart';
import 'admin/manage_schools.dart';
import 'admin/manage_users.dart';
import 'admin/view_data.dart';
import 'screens/assignment_screen/assignment_screen.dart';
import 'screens/datesheet_screen/datesheet_screen.dart';
import 'screens/fee_screen/fee_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/my_profile/my_profile.dart';
import 'package:oo/screens/my_profile/teacher_profile.dart';
import 'package:flutter/material.dart';
import 'package:oo/screens/home_screen/student_profile_screen.dart';
import 'package:oo/screens/home_screen/teacher_home_screen.dart';
import 'package:oo/screens/home_screen/parent_profile_screen.dart';

Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MyProfileScreen.routeName: (context) => MyProfileScreen(),
  FeeScreen.routeName: (context) => FeeScreen(),
  AssignmentScreen.routeName: (context) => AssignmentScreen(),
  DateSheetScreen.routeName: (context) => DateSheetScreen(),
  ParentHomeScreen.routeName: (context) => ParentHomeScreen(),
  TeacherHomeScreen.routeName: (context) => TeacherHomeScreen(),
  ParentProfileScreen.routeName: (context) => ParentProfileScreen(),
  TeacherProfileScreen.routeName: (context) => TeacherProfileScreen(),
  'TeacherProfile': (context) => TeacherHomeScreen(),
  'ParentProfile': (context) => ParentProfileScreen(),
  'StudentProfileScreen': (context) => MyProfileScreen(),
  AdminDashboard.routeName: (context) => AdminDashboard(),
  ManageUsersScreen.routeName: (context) => ManageUsersScreen(),
  ManageSchoolsScreen.routeName: (context) => ManageSchoolsScreen(),
  ManagePaymentsScreen.routeName: (context) => ManagePaymentsScreen(),
  ViewDataScreen.routeName: (context) => ViewDataScreen(),
  ManageStudentsScreen.routeName: (context) => ManageStudentsScreen(),
  ManageSyllabusScreen.routeName: (context) => ManageSyllabusScreen(),
  MyProfileScreen.routeName: (context) => const MyProfileScreen(),
  'StudentHomeScreen': (context) => const StudentHomeScreen(),
  'StudentProfileScreen': (context) => const StudentProfileScreen(),
  StudentProfileScreen.routeName: (context) => const StudentProfileScreen(),
  StudentHomeScreen.routeName: (context) => const StudentHomeScreen(),
  '/student-home': (context) => StudentHomeScreen(),
  AddStudentGradeScreen.routeName: (_) => AddStudentGradeScreen(),

  StudentGradesScreen.routeName: (_) => StudentGradesScreen(),
  '/': (context) => HomeScreen(), // ton écran d'accueil
  AddStudentGradeScreen.routeName: (context) => const AddStudentGradeScreen(),
  '/grades': (context) => const StudentGradesScreen(),
  StudentAttendanceScreen.routeName: (context) => StudentAttendanceScreen(),
  StudentProfileScreen.routeName: (context) => const StudentProfileScreen(),
  StudentHomeScreen.routeName: (context) => const StudentHomeScreen(),
  StudentProfileScreen.routeName: (context) => const StudentProfileScreen(),
};
