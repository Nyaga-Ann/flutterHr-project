import 'package:flutter/material.dart';
import 'package:hrm_frontend/services/api_service.dart';
import '/widgets/custom_drawer.dart'; // Import the custom drawer

class LeaveRequestForm extends StatefulWidget {
  final int employeeId;
  final String username; // Added username to match the drawer parameters
  final bool isHRManager;
  final int userId;

  const LeaveRequestForm({
    required this.employeeId,
    required this.username,
    required this.isHRManager,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  _LeaveRequestFormState createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Form fields
  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _remarks;

  // Handle leave form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare leave request data
      Map<String, dynamic> leaveData = {
        'Employee_ID': widget.employeeId,
        'Leave_Type': _leaveType,
        'Start_Date': _startDate?.toIso8601String(),
        'End_Date': _endDate?.toIso8601String(),
        'Remarks': _remarks,
      };

      try {
        // Call the API to create leave request
        final response = await _apiService.createLeaveRequest(leaveData);

        if (response['status'] == 'success') {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Leave request submitted successfully!')),
          );
          Navigator.pop(context); // Close the form and return to the previous screen
        } else {
          throw Exception('Failed to submit leave request');
        }
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit leave request: $e')),
        );
      }
    }
  }

  // Date picker for selecting start and end dates
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime(2100);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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
              title: const Text("Leave Request Form"),
              centerTitle: true,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      value: _leaveType,
                      decoration: InputDecoration(labelText: 'Leave Type'),
                      items: ['Sick', 'Casual', 'Annual', 'Maternity']
                          .map((type) => DropdownMenuItem(
                                child: Text(type),
                                value: type,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _leaveType = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a leave type' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Start Date'),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _startDate != null ? _formatDate(_startDate!) : '',
                      ),
                      onTap: () => _selectDate(context, true),
                      validator: (value) => value == null || value.isEmpty ? 'Please select a start date' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'End Date (Optional)'),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _endDate != null ? _formatDate(_endDate!) : '',
                      ),
                      onTap: () => _selectDate(context, false),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Remarks (Optional)'),
                      maxLines: 3,
                      onSaved: (value) {
                        _remarks = value;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit Request'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Theme color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

