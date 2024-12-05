import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/widgets/custom_drawer.dart';

class ReportsScreen extends StatefulWidget {
  final int employeeId;
  final String username;
  final bool isHRManager;
  final int userId;

  ReportsScreen({
    required this.employeeId,
    required this.username,
    required this.isHRManager,
    required this.userId,
  });

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<dynamic> reports = [];
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController reportTypeController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController createdByController = TextEditingController();
  final TextEditingController reportDateController = TextEditingController();
  final TextEditingController reportContentController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/reports'));
      if (response.statusCode == 200) {
        setState(() {
          reports = jsonDecode(response.body);
        });
      } else {
        print("Failed to load reports: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching reports: $e");
    }
  }

  Future<void> addOrUpdateReport({int? reportId}) async {
    try {
      final url = reportId == null
          ? Uri.parse('http://localhost:5000/reports')
          : Uri.parse('http://localhost:5000/reports/$reportId');
      final method = reportId == null ? http.post : http.put;

      final response = await method(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Report_Type': reportTypeController.text,
          'Employee_ID': employeeIdController.text,
          'Created_By': createdByController.text,
          'Report_Date': reportDateController.text,
          'Report_Content': reportContentController.text,
          'Status': statusController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchReports();
        Navigator.pop(context);
      } else {
        print("Failed to save report: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saving report: $e");
    }
  }

  Future<void> deleteReport(int reportId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:5000/reports/$reportId'));
      if (response.statusCode == 200) {
        fetchReports();
      } else {
        print("Failed to delete report: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting report: $e");
    }
  }

  void showReportForm({int? reportId}) {
    if (reportId != null) {
      // Prefill fields for editing
      final report = reports.firstWhere((report) => report['Report_ID'] == reportId);
      reportTypeController.text = report['Report_Type'];
      employeeIdController.text = report['Employee_ID'].toString();
      createdByController.text = report['Created_By'].toString();
      reportDateController.text = report['Report_Date'];
      reportContentController.text = report['Report_Content'];
      statusController.text = report['Status'];
    } else {
      // Clear fields for new report
      reportTypeController.clear();
      employeeIdController.clear();
      createdByController.clear();
      reportDateController.clear();
      reportContentController.clear();
      statusController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(reportId == null ? 'Add Report' : 'Edit Report'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: reportTypeController,
                  decoration: InputDecoration(labelText: 'Report Type'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter report type' : null,
                ),
                TextFormField(
                  controller: employeeIdController,
                  decoration: InputDecoration(labelText: 'Employee ID'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter employee ID' : null,
                ),
                TextFormField(
                  controller: createdByController,
                  decoration: InputDecoration(labelText: 'Created By'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter creator ID' : null,
                ),
                TextFormField(
                  controller: reportDateController,
                  decoration: InputDecoration(labelText: 'Report Date (YYYY-MM-DD)'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter report date' : null,
                ),
                TextFormField(
                  controller: reportContentController,
                  decoration: InputDecoration(labelText: 'Report Content'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter report content' : null,
                ),
                TextFormField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Status'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter status' : null,
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
                addOrUpdateReport(reportId: reportId);
              }
            },
            child: Text(reportId == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.purple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(
        employeeId: widget.employeeId,
        username: widget.username,
        isHRManager: widget.isHRManager,
        userId: widget.userId,
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(report['Report_Type']),
              subtitle: Text(report['Report_Content']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => showReportForm(reportId: report['Report_ID']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteReport(report['Report_ID']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showReportForm(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}



