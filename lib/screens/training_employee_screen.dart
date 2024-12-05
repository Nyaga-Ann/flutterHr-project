import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/widgets/custom_drawer.dart'; // Import the custom drawer

class EmployeeTrainingScreen extends StatefulWidget {
  final int employeeId;
  final String username;
  final int userId;

  const EmployeeTrainingScreen({Key? key, required this.employeeId, required this.username, required this.userId})
      : super(key: key);

  @override
  _EmployeeTrainingScreenState createState() => _EmployeeTrainingScreenState();
}

class _EmployeeTrainingScreenState extends State<EmployeeTrainingScreen> {
  List<dynamic> trainingRecords = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchEmployeeTrainings();
  }

  Future<void> fetchEmployeeTrainings() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/employee-training?Employee_ID=${widget.employeeId}'));
      if (response.statusCode == 200) {
        setState(() {
          trainingRecords = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load training records');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching training records. Please try again later.";
      });
    }
  }

  Widget buildTrainingCard(dynamic record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 2,
      child: ListTile(
        title: Text(
          'Training ID: ${record['Training_ID']}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('Status: ${record['Completion_Status']}'),
            Text('Certification: ${record['Certification'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        employeeId: widget.employeeId,
        isHRManager: false,
        username: widget.username,
        userId: widget.userId,
      ),
      body: Column(
        children: [
          // Gradient App Bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.purple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text("My Trainings"),
              centerTitle: true,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : trainingRecords.isEmpty
                        ? Center(
                            child: Text(
                              'No training records found.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: trainingRecords.length,
                              itemBuilder: (context, index) {
                                final record = trainingRecords[index];
                                return buildTrainingCard(record);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}



