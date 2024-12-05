import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/widgets/custom_drawer.dart';

class HRTrainingScreen extends StatefulWidget {
  final int userId; // Add this field

  // Constructor to accept userId
  HRTrainingScreen({required this.userId});

  @override
  _HRTrainingScreenState createState() => _HRTrainingScreenState();
}

class _HRTrainingScreenState extends State<HRTrainingScreen> {
  List<dynamic> trainingSessions = [];
  final _formKey = GlobalKey<FormState>();
  final trainingTypeController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final requirementsController = TextEditingController();
  final pointsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTrainings();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    trainingTypeController.dispose();
    locationController.dispose();
    dateController.dispose();
    timeController.dispose();
    requirementsController.dispose();
    pointsController.dispose();
    super.dispose();
  }

  Future<void> fetchTrainings() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/training'));
      if (response.statusCode == 200) {
        setState(() {
          trainingSessions = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Error fetching trainings: $e");
    }
  }

  Future<void> addOrUpdateTraining({int? trainingId}) async {
    final url = trainingId == null
        ? Uri.parse('http://localhost:5000/training')
        : Uri.parse('http://localhost:5000/training/$trainingId');

    final method = trainingId == null ? http.post : http.put;
    final body = jsonEncode({
      'Training_Type': trainingTypeController.text,
      'Location': locationController.text,
      'Date': dateController.text,
      'Time': timeController.text,
      'Requirements': requirementsController.text,
      'Points': pointsController.text,
    });

    try {
      final response = await method(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchTrainings();
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error adding/updating training: $e");
    }
  }

  Future<void> deleteTraining(int trainingId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:5000/training/$trainingId'));
      if (response.statusCode == 200) {
        fetchTrainings();
      }
    } catch (e) {
      print("Error deleting training: $e");
    }
  }

  void showTrainingForm({int? trainingId}) {
    // Pre-fill fields for update
    if (trainingId != null) {
      final training = trainingSessions.firstWhere((t) => t['Training_ID'] == trainingId);
      trainingTypeController.text = training['Training_Type'];
      locationController.text = training['Location'];
      dateController.text = training['Date'];
      timeController.text = training['Time'];
      requirementsController.text = training['Requirements'];
      pointsController.text = training['Points'].toString();
    } else {
      trainingTypeController.clear();
      locationController.clear();
      dateController.clear();
      timeController.clear();
      requirementsController.clear();
      pointsController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(trainingId == null ? 'Add Training' : 'Edit Training'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: trainingTypeController,
                  decoration: InputDecoration(labelText: 'Training Type'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter training type' : null,
                ),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter location' : null,
                ),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter date' : null,
                ),
                TextFormField(
                  controller: timeController,
                  decoration: InputDecoration(labelText: 'Time (HH:MM)'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter time' : null,
                ),
                TextFormField(
                  controller: requirementsController,
                  decoration: InputDecoration(labelText: 'Requirements'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter requirements' : null,
                ),
                TextFormField(
                  controller: pointsController,
                  decoration: InputDecoration(labelText: 'Points'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Enter points' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                addOrUpdateTraining(trainingId: trainingId);
              }
            },
            child: Text(trainingId == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Management'),
        backgroundColor: Colors.blue,
      ),
      drawer: CustomDrawer(
        employeeId: 0,
        isHRManager: true,
        username: 'HR Manager',
        userId: widget.userId, // Correctly reference userId from widget
      ),
      body: ListView.builder(
        itemCount: trainingSessions.length,
        itemBuilder: (context, index) {
          final training = trainingSessions[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(training['Training_Type']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${training['Location']}'),
                  Text('Date: ${training['Date']}'),
                  Text('Time: ${training['Time']}'),
                  Text('Points: ${training['Points']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => showTrainingForm(trainingId: training['Training_ID']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteTraining(training['Training_ID']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTrainingForm(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}





