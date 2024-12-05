import 'package:flutter/material.dart';
import 'package:hrm_frontend/screens/payroll_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/training_employee_screen.dart';
import 'screens/performance_employee.dart';
import 'screens/leave_request_form.dart';
import 'screens/training_screen.dart';
import 'screens/performance_screen.dart';
import 'screens/leave_screen.dart';
import 'screens/records_screen.dart';
import 'screens/report_screen.dart';

// Example of a dummy loggedInUser for testing
class LoggedInUser {
  final String role;
  final int employeeId;
  final String username;
  final int userId;

  LoggedInUser({required this.role, required this.employeeId, required this.username, required this.userId});
}

// Dummy user for demonstration
final LoggedInUser loggedInUser = LoggedInUser(role: 'HR Manager', employeeId: 1, username: 'username', userId: 401);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'HRMS Frontend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Initial screen of the app
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => HomeScreen(
              isHRManager: loggedInUser.role == 'HR Manager',
              employeeId: loggedInUser.employeeId,
              username: loggedInUser.username,
              userId: loggedInUser.userId,
            ),
        '/profile': (context) => ProfileScreen(
              employeeId: loggedInUser.employeeId,
              userId: loggedInUser.userId,
              isHRManager: loggedInUser.role == 'HR Manager',
              username: loggedInUser.username,
            ),
        '/training': (context) => EmployeeTrainingScreen(
              employeeId: loggedInUser.employeeId,
              username: loggedInUser.username,
              userId: loggedInUser.userId,
        ),
        '/performance': (context) => PerformanceScreen(
            employeeId: loggedInUser.employeeId,
            isHRManager: loggedInUser.role == 'HR Manager',
            username: loggedInUser.username,
            userId: loggedInUser.userId,
          ),
        '/payroll': (context) => PayrollScreen(
              isHRManager: loggedInUser.role == 'HR Manager',
              employeeId: loggedInUser.employeeId,
              username: loggedInUser.username,
              userId: loggedInUser.userId,
            ),
        '/leave': (context) => LeaveRequestForm(
              employeeId: loggedInUser.employeeId,
              isHRManager: loggedInUser.role == 'HR Manager',
              username: loggedInUser.username,
              userId: loggedInUser.userId,
            ),
        '/training_manager': (context) => HRTrainingScreen(
          userId: loggedInUser.userId,
        ),
        '/performance_manager': (context) => HRPerformanceScreen(
            employeeId: loggedInUser.employeeId,
            isHRManager: loggedInUser.role == 'HR Manager',
            username: loggedInUser.username,
            userId: loggedInUser.userId,
        ),
        '/leave_manager': (context) => LeaveScreen(
              isHRManager: true,
              employeeId: loggedInUser.employeeId,
              username: loggedInUser.username,
              userId: loggedInUser.userId,
            ),
        '/employee_records': (context) => RecordsScreen(
              employeeId: loggedInUser.employeeId,
              isHRManager: loggedInUser.role == 'HR Manager',
              username: loggedInUser.username,
              userId: loggedInUser.userId,
            ),
        '/report': (context) => ReportsScreen(
              employeeId: loggedInUser.employeeId,
              isHRManager: true,
              username: loggedInUser.username,
              userId: loggedInUser.userId,
        ),
      },
    );
  }
}
