import 'package:flutter/material.dart';
import '/widgets/custom_drawer.dart'; // Import the custom drawer
import 'leave_screen.dart';
import 'training_employee_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isHRManager;
  final int employeeId;
  final String username;
  final int userId;

  const HomeScreen({
    super.key,
    required this.isHRManager,
    required this.employeeId,
    required this.username,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        isHRManager: isHRManager,
        employeeId: employeeId,
        username: username,
        userId: userId,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Add functionality for notifications
            },
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Dashboard Section with Gradient Background
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade100, Colors.purple.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Home > Dashboard',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5), // Space between Dashboard and Image

              // Background Image Section
              Container(
                height: 100, // Adjust height as needed
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/hr7.png'), // Your background image
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              // Content Cards Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade100, Colors.purple.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  children: [
                    _buildFeatureCard('Notifications', Icons.notifications, context),
                    _buildFeatureCard('Training Schedule', Icons.schedule, context),
                    _buildFeatureCard('Leaves', Icons.beach_access, context),
                    _buildFeatureCard('Tasks', Icons.task, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Feature Card Widget
  Widget _buildFeatureCard(String title, IconData icon, BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate based on feature
          switch (title) {
            case 'Notifications':
              // Implement navigation to Notifications screen
              break;
            case 'Training Schedule':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeTrainingScreen(employeeId: employeeId, username: username, userId: userId)),
              );
              break;
            case 'Leaves':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaveScreen(
                    isHRManager: isHRManager,
                    employeeId: employeeId,
                    username: username,
                    userId: userId
                  ),
                ),
              );
              break;
            case 'Tasks':
              // Implement navigation to Tasks screen
              break;
            default:
              break;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue[700]),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











