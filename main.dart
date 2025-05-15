import 'dart:developer'; // Import the logging package
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb check

//  all necessary pages
import 'splash_screen.dart';
import 'Pages/student_module/home.dart';
import 'Pages/student_module/attendance.dart';
import 'Pages/student_module/daily_attendance_list.dart';
import 'Pages/student_module/enrolled_courses.dart';
import 'Pages/student_module/student_help.dart';
import 'Pages/student_module/account.dart';
import 'Pages/student_module/course_code.dart';
import 'Pages/student_module/registration.dart';
import 'Pages/student_module/select_option.dart';
import 'Pages/login/login.dart'; // Student login page
import 'Pages/login/admin_login.dart'; // Admin login page
import 'Pages/student_module/menu.dart';
import 'Pages/student_module/notification.dart';
import 'Pages/student_module/search.dart';
import 'Pages/teacher_module/mark_attendance.dart';
import 'Pages/teacher_module/view_record.dart';
import 'Pages/teacher_module/profile.dart';
import 'Pages/teacher_module/alert.dart';
import 'Pages/teacher_module/more.dart';
import 'Pages/teacher_module/manage_courses.dart';
import 'Pages/teacher_module/session.dart';
import 'Pages/teacher_module/teacher_help.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, //  Fixed Placement
  );

  log("Firebase Initialized Successfully!"); //  Log message

  runApp(const BioSentinelApp());
}

class BioSentinelApp extends StatelessWidget {
  const BioSentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: kIsWeb
          ? const AdminLogin()
          : const SplashScreen(), // Conditional rendering
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const Login(), // Student login page
        '/attendance': (context) => const AttendancePage(),
        '/dailyAttendance': (context) => const DailyAttendancePage(),
        '/enterCourseCode': (context) => const EnterCourseCode(),
        '/enrolledCourses': (context) => const EnrolledCoursesList(),
        '/registration': (context) => const RegistrationPage(),
        '/roleSelection': (context) => const RoleSelectionPage(),
        '/teacher_help': (context) => const TeacherHelpPage(),
        '/student_help': (context) => const StudentHelpPage(),
        '/menu': (context) => const MenuPage(),
        '/account': (context) => const AccountPage(),
        '/search': (context) => const SearchPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/manual-attendance': (context) => const ManualAttendancePage(),
        '/attendance-records': (context) => const TeacherReportsPage(),
        '/teacher-profile': (context) => const Profile(),
        '/alerts': (context) => const Alert(),
        '/more': (context) => const TeacherMenuPage(),
        '/manage-courses': (context) => const ManageCoursesPage(),
        '/session': (context) => const Session(),
        '/teacher-menu': (context) => const TeacherMenuPage(),
      },
    );
  }
}
