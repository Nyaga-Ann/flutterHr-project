import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/widgets/custom_drawer.dart';  // Import the CustomDrawer widget

class RecordsScreen extends StatefulWidget {
  final int employeeId;
  final bool isHRManager;
  final String username;
  final int userId;

  const RecordsScreen({Key? key, required this.employeeId, required this.isHRManager, required this.username, required this.userId}) : super(key: key);

  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  // Variables for filter and search
  String selectedFilter = 'Personal';  // Default filter type
  TextEditingController searchController = TextEditingController();

  // Dummy data for testing
  List<String> filters = ['Personal', 'Department', 'Job', 'Medical'];

  // Dummy records data for the table (will be replaced with actual data from backend)
  List<Map<String, dynamic>> records = [
    {'Employee_ID': 1, 'First_Name': 'John', 'Last_Name': 'Doe', 'Job_Title': 'Manager'},
    {'Employee_ID': 2, 'First_Name': 'Jane', 'Last_Name': 'Smith', 'Job_Title': 'Developer'},
    // Add more records as needed
  ];

  // Column headers for the records table
  List<String> headers = ['Employee_ID', 'First_Name', 'Last_Name', 'Job_Title'];

  // Method to apply the filters (you'll need backend integration later)
  void applyFilters() {
    print('Filters Applied');
    print('Selected Filter: $selectedFilter');
    print('Search Query: ${searchController.text}');
    // You would fetch filtered data here based on the selected filter and search query
  }

  // Build the records table dynamically
  Widget buildRecordsTable(List<dynamic> records, List<String> headers) {
    return DataTable(
      columns: headers
          .map((header) => DataColumn(label: Text(header)))
          .toList(),
      rows: records.map((record) {
        return DataRow(
          cells: headers.map((header) {
            return DataCell(Text(record[header].toString()));
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records Management'),
        backgroundColor: Colors.blue, // Blue color for the appbar
      ),
      drawer: CustomDrawer(
        employeeId: widget.employeeId,
        isHRManager: widget.isHRManager,
        username: widget.username,
        userId: widget.userId,
      ), // Add the CustomDrawer here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Panel
            buildFilterPanel(),
            SizedBox(height: 20), // Space between filter panel and records
            // Display the records table
            Expanded(child: buildRecordsTable(records, headers)),
          ],
        ),
      ),
    );
  }

  // Build the filter panel
  Widget buildFilterPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Type Dropdown
        DropdownButton<String>(
          value: selectedFilter,
          items: filters
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedFilter = value!;
            });
          },
        ),
        SizedBox(height: 10),
        // Search Field
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search by Name, Department, or Job',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                applyFilters();
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        // Apply Filters Button
        ElevatedButton(
          onPressed: applyFilters,
          child: Text('Apply Filters'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Corrected to backgroundColor
          ),
        ),
      ],
    );
  }
}

Future<List<dynamic>> fetchRecords(String recordType, String searchQuery, int page, int limit) async {
  final response = await http.get(
    Uri.parse('http://your-api-url/records?type=$recordType&search=$searchQuery&page=$page&limit=$limit'),
  );

  if (response.statusCode == 200) {
    // If the server returns a successful response
    List<dynamic> records = json.decode(response.body);
    return records;
  } else {
    // If the server returns an error
    throw Exception('Failed to load records');
  }
}

