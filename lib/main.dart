import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/advisor/advisor_dashboard.dart';
import 'pages/coordinator/coordinator_dashboard.dart';
import 'pages/hod/hod_dashboard.dart';
import 'pages/sign_in.dart';
import 'pages/sign_up.dart';
import 'pages/student/student_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAdvisor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'signin': (context) => const SignIn(),
        'signup': (context) => const SignUp(),
        'student': (context) => const StudentDashboard(),
        'hod': (context) => const HodDashboard(),
        'coordinator': (context) => const CoordinatorDashboard(),
        'advisor': (context) => const AdvisorDashboard(),
      },
      initialRoute: 'signin',
    );
  }
}
