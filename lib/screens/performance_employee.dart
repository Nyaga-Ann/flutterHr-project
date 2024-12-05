import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/widgets/custom_drawer.dart'; // Import the custom drawer

class PerformanceScreen extends StatefulWidget {
  final int employeeId;
  final bool isHRManager;
  final String username;
  final int userId;

  PerformanceScreen({required this.employeeId, required this.isHRManager, required this.username, required this.userId});

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  List<dynamic> performanceData = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchPerformance();
  }

  Future<void> fetchPerformance() async {
    try {
      final response = await http.get(
        Uri.parse('http://your-api-url/performance/employee/${widget.employeeId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          performanceData = json.decode(response.body);
        });
      } else {
        setState(() {
          performanceData = [];
        });
      }
    } catch (e) {
      setState(() {
        performanceData = [];
      });
      print('Error fetching performance data: $e');
    }
  }

  Future<void> deletePerformance(int performanceId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://your-api-url/performance/$performanceId'),
      );

      if (response.statusCode == 200) {
        fetchPerformance(); // Refresh the data after deletion
      } else {
        print('Error deleting performance record');
      }
    } catch (e) {
      print('Error deleting performance record: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        employeeId: widget.employeeId,
        isHRManager: widget.isHRManager,
        username: widget.username,
        userId: widget.userId,
        ), // Add the navigation drawer
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
              title: Text("Performance Review"),
              centerTitle: true,
            ),
          ),
          Expanded(
            child: performanceData.isEmpty
                ? Center(child: Text("No performance records available"))
                : ListView.builder(
                    itemCount: performanceData.length,
                    itemBuilder: (context, index) {
                      var record = performanceData[index];
                      TextEditingController objectiveController =
                          TextEditingController(text: record['Objective']);
                      TextEditingController ratingController =
                          TextEditingController(text: record['Rating'].toString());
                      TextEditingController commentsController =
                          TextEditingController(text: record['Comments']);

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isEditing
                                  ? TextField(
                                      controller: objectiveController,
                                      decoration: InputDecoration(labelText: "Objective"),
                                    )
                                  : Text("Objective: ${record['Objective']}"),
                              SizedBox(height: 10),
                              isEditing
                                  ? TextField(
                                      controller: ratingController,
                                      decoration: InputDecoration(labelText: "Rating"),
                                      keyboardType: TextInputType.number,
                                    )
                                  : Text("Rating: ${record['Rating']}"),
                              SizedBox(height: 10),
                              isEditing
                                  ? TextField(
                                      controller: commentsController,
                                      decoration: InputDecoration(labelText: "Comments"),
                                    )
                                  : Text("Comments: ${record['Comments']}"),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (isEditing)
                                    ElevatedButton(
                                      onPressed: () {
                                        // Update logic here
                                      },
                                      child: Text("Save"),
                                    ),
                                  if (isEditing)
                                    ElevatedButton(
                                      onPressed: () => setState(() => isEditing = false),
                                      child: Text("Cancel"),
                                    ),
                                  if (!isEditing)
                                    ElevatedButton(
                                      onPressed: () => setState(() => isEditing = true),
                                      child: Text("Edit"),
                                    ),
                                  ElevatedButton(
                                    onPressed: () => deletePerformance(record['Performance_ID']),
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

