import 'package:flutter/material.dart';
import 'package:hrm_frontend/screens/login_screen.dart';
import '/screens/home_screen.dart';
import '/screens/leave_request_form.dart';
import '/screens/leave_screen.dart';
import '/screens/payroll_screen.dart';
import '/screens/performance_employee.dart';
import '/screens/performance_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/records_screen.dart';
import '/screens/report_screen.dart';
import '/screens/training_employee_screen.dart';
import '/screens/training_screen.dart';

class CustomDrawer extends StatelessWidget {
  final int employeeId;
  final bool isHRManager;
  final String username;
  final int userId;

  const CustomDrawer({Key? key, required this.employeeId, required this.isHRManager, required this.username, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.purple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue[700]),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            title: 'Home',
            icon: Icons.house,
            screen: HomeScreen(employeeId: employeeId, isHRManager: isHRManager, username: username, userId: userId),
          ),
          _buildDrawerItem(
            context,
            title: 'Profile',
            icon: Icons.person,
            screen: ProfileScreen(employeeId: employeeId, isHRManager: isHRManager, username: username, userId: userId),
          ),
          if (isHRManager) ...[
            _buildDrawerItem(
              context,
              title: 'Employee Records',
              icon: Icons.people,
              screen: RecordsScreen(employeeId: employeeId, isHRManager: true, username: username, userId: userId),
            ),
            _buildDrawerItem(
              context,
              title: 'Training',
              icon: Icons.school,
              screen: HRTrainingScreen(userId: userId),
            ),
            _buildDrawerItem(
              context,
              title: 'Performance',
              icon: Icons.bar_chart,
              screen: HRPerformanceScreen(isHRManager: true, employeeId: employeeId, username: username, userId: userId),
            ),
            _buildDrawerItem(
              context,
              title: 'Leave Management',
              icon: Icons.assignment,
              screen: LeaveScreen(isHRManager: true, employeeId: employeeId, username: username, userId: userId),
            ),
            _buildDrawerItem(
              context,
              title: 'Reports',
              icon: Icons.report,
              screen: ReportsScreen(isHRManager: true, employeeId: employeeId, username: username, userId: userId),
            ),
            _buildDrawerItem(
              context,
              title: 'Payroll',
              icon: Icons.payment,
              screen: PayrollScreen(isHRManager: true, employeeId: employeeId, username: username, userId: userId),
            ),
          ] else ...[
            _buildDrawerItem(
              context,
              title: 'Training',
              icon: Icons.school,
              screen: EmployeeTrainingScreen(employeeId: employeeId, username: username, userId: userId),
            ),
            _buildDrawerItem(
              context,
              title: 'Performance',
              icon: Icons.bar_chart,
              screen: PerformanceScreen(employeeId: employeeId, isHRManager: false, username: username, userId: userId),
            ),
            _buildDrawerItem(
              context,
              title: 'Leave',
              icon: Icons.assignment,
              screen: LeaveRequestForm(employeeId: employeeId, isHRManager: isHRManager, username: username,userId: userId),
            ),
            _buildDrawerItem(
              context,
              title: 'Payroll',
              icon: Icons.payment,
              screen: PayrollScreen(isHRManager: false, employeeId: employeeId, username: username, userId: userId),
            ),
          ],
          _buildDrawerItem(
            context,
            title: 'Logout',
            icon: Icons.logout,
            screen: const LoginScreen(), // Handle logout logic here
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required String title, required IconData icon, required Widget screen}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}


