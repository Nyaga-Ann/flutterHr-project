import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/custom_drawer.dart';

class ProfileScreen extends StatefulWidget {
  final int employeeId;
  final bool isHRManager;
  final String username;
  final int userId;

  const ProfileScreen({
    Key? key,
    required this.employeeId,
    required this.userId,
    required this.isHRManager,
    required this.username,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> employeeData;
  bool isEditing = false;
  late Map<String, dynamic> editableData;  // Define editableData

  @override
  void initState() {
    super.initState();
    employeeData = fetchEmployeeDetails();
  }

  Future<Map<String, dynamic>> fetchEmployeeDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/employee/${widget.userId}'),  // Use userId here
        headers: {
          "Role": "Employee",  // or "HR Manager"
          "Logged_In_User_ID": "1",  // Actual logged-in user ID
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load employee details: ${response.body}");
      }
    } catch (e) {
      return {};  // Handle errors gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.purple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(
        employeeId: widget.employeeId,
        isHRManager: widget.isHRManager,
        username: widget.username,
        userId: widget.userId,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: employeeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading profile: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            editableData = Map.from(snapshot.data!); // Initialize editableData here
            return buildProfileContent(editableData);
          }
        },
      ),
    );
  }

  Widget buildProfileContent(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              // Left side: Profile avatar and login details
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.grey),
                    Text(
                      'Employee ID: ${widget.employeeId}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right side: Employee details
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('First Name', data['First_Name']),
                      _buildDetailRow('Last Name', data['Last_Name']),
                      _buildDetailRow('Gender', data['Gender']),
                      _buildDetailRow('Date of Birth', data['DOB']),
                      _buildDetailRow('Marital Status', data['Marital_Status']),
                      _buildDetailRow('Address', data['Address']),
                      _buildDetailRow('Contact', data['Contact']),
                      _buildDetailRow('Job ID', data['Job_ID']),
                      _buildDetailRow('Department ID', data['Department_ID']),
                      _buildDetailRow('Start Date', data['Start_Date']),
                      _buildDetailRow('End Date', data['End_Date']),
                      _buildDetailRow('Employment Status', data['Employment_Status']),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isEditing) ...[
            Row(
              children: [
                ElevatedButton(
                  onPressed: saveChanges,
                  child: const Text('Save Changes'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  child: const Text('Cancel'),
                ),
              ],
            )
          ] else ...[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
              child: const Text('Edit Profile'),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: TextEditingController(text: value?.toString() ?? 'N/A'),
              readOnly: !isEditing,
              onChanged: (text) {
                setState(() {
                  editableData[label] = text;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void saveChanges() async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:5000/employee/employee/${widget.employeeId}'), // Replace with your API endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(editableData),
      );

      if (response.statusCode == 200) {
        setState(() {
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')));
      } else {
        throw Exception('Failed to save changes');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
    }
  }
}




