import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/widgets/custom_drawer.dart'; // Import the custom drawer

class HRPerformanceScreen extends StatefulWidget {
  final int employeeId;
  final bool isHRManager;
  final String username;
  final int userId;

  const HRPerformanceScreen({Key? key, required this.employeeId, required this.username, required this.isHRManager, required this.userId}) : super(key: key);

  @override
  _HRPerformanceScreenState createState() => _HRPerformanceScreenState();
}

class _HRPerformanceScreenState extends State<HRPerformanceScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> reviewList = [];
  String filter = "all";

  @override
  void initState() {
    super.initState();
    fetchAllReviews();
  }

  Future<void> fetchAllReviews() async {
    try {
      final response = await http.get(
        Uri.parse('http://your-api-url/performance'),
      );

      if (response.statusCode == 200) {
        setState(() {
          reviewList = json.decode(response.body);
        });
      } else {
        setState(() {
          reviewList = [];
        });
      }
    } catch (e) {
      setState(() {
        reviewList = [];
      });
      print('Error fetching reviews: $e');
    }
  }

  void applyFilter(String filterType) {
    setState(() {
      filter = filterType;
    });
  }

  List<dynamic> getFilteredReviews() {
    if (filter == "all") {
      return reviewList;
    } else if (filter == "pending") {
      return reviewList.where((review) => review['Rating'] == null).toList();
    } else if (filter == "completed") {
      return reviewList.where((review) => review['Rating'] != null).toList();
    }
    return reviewList;
  }

  @override
  Widget build(BuildContext context) {
    var filteredReviews = getFilteredReviews();

    return Scaffold(
      drawer: CustomDrawer(
        employeeId: widget.employeeId,
        isHRManager: true,
        username: widget.username,
        userId: widget.userId,
      ),
      body: Column(
        children: [
          // Custom Gradient AppBar
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
              title: const Text("Performance Reviews"),
              centerTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search Employee by Name or ID",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Implement search logic if needed
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => applyFilter("all"),
                child: const Text("All"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => applyFilter("pending"),
                child: const Text("Pending"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => applyFilter("completed"),
                child: const Text("Completed"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredReviews.length,
              itemBuilder: (context, index) {
                var review = filteredReviews[index];
                return ListTile(
                  title: Text("Employee ID: ${review['Employee_ID']}"),
                  subtitle: Text("Objective: ${review['Objective']}"),
                  onTap: () {
                    // Navigate to detailed review screen
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

