import 'package:flutter/material.dart';
import 'package:hrm_frontend/screens/leave_request_form.dart';
import 'package:hrm_frontend/widgets/custom_drawer.dart'; // Ensure the custom_drawer.dart is imported

class LeaveScreen extends StatelessWidget {
  final bool isHRManager;
  final int employeeId;
  final String username;
  final int userId;

  const LeaveScreen({required this.isHRManager, required this.employeeId, required this.username, required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isHRManager ? 'Leave Management' : 'My Leaves'),
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
      drawer: CustomDrawer(employeeId: employeeId, isHRManager: isHRManager, username: username, userId: userId,),
      body: LeaveBody(isManager: isHRManager, employeeId: employeeId, username: username, userId: userId,),
    );
  }
}

class LeaveBody extends StatefulWidget {
  final bool isManager;
  final int employeeId;
  final String username;
  final int userId;

  const LeaveBody({required this.isManager, required this.employeeId, required this.username, required this.userId,  Key? key}) : super(key: key);

  @override
  _LeaveBodyState createState() => _LeaveBodyState();
}

class _LeaveBodyState extends State<LeaveBody> {
  List<dynamic> leaveRecords = []; // Holds fetched leave records
  bool isLoading = true; // Loading indicator

  @override
  void initState() {
    super.initState();
    fetchLeaveRecords();
  }

  Future<void> fetchLeaveRecords() async {
    // Simulate fetching records from an API or database
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      leaveRecords = [
        {'Leave_Type': 'Sick', 'Status': 'Pending', 'Remarks': 'Flu', 'Leave_ID': 1},
        {'Leave_Type': 'Casual', 'Status': 'Approved', 'Remarks': 'Family event', 'Leave_ID': 2},
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.isManager)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _openLeaveRequestForm(context),
              child: const Text('Request Leave'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Theme color
              ),
            ),
          ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : leaveRecords.isNotEmpty
                  ? ListView.builder(
                      itemCount: leaveRecords.length,
                      itemBuilder: (context, index) {
                        final record = leaveRecords[index];
                        return Card(
                          child: ListTile(
                            title: Text(record['Leave_Type']),
                            subtitle: Text("Status: ${record['Status']} \nRemarks: ${record['Remarks']}"),
                            trailing: widget.isManager && record['Status'] == 'Pending'
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.check, color: Colors.green),
                                        onPressed: () => _updateLeaveStatus(record['Leave_ID'], 'Approved'),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () => _openDeclineForm(context, record['Leave_ID']),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No leave records found.'),
                    ),
        ),
      ],
    );
  }

  void _openLeaveRequestForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaveRequestForm(employeeId: widget.employeeId, isHRManager: widget.isManager, username: widget.username, userId: widget.userId,)),
    );
  }

  void _openDeclineForm(BuildContext context, int leaveId) {
    String remarks = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Decline Leave Request'),
          content: TextField(
            onChanged: (value) {
              remarks = value;
            },
            decoration: const InputDecoration(labelText: 'Remarks'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateLeaveStatus(leaveId, 'Declined', remarks);
                Navigator.pop(context);
              },
              child: const Text('Decline'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateLeaveStatus(int leaveId, String status, [String? remarks]) async {
    setState(() {
      leaveRecords = leaveRecords.map((record) {
        if (record['Leave_ID'] == leaveId) {
          record['Status'] = status;
          if (remarks != null) {
            record['Remarks'] = remarks;
          }
        }
        return record;
      }).toList();
    });
  }
}


