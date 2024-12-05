import 'package:flutter/material.dart';
import '/widgets/custom_drawer.dart'; // Import the custom drawer

class PayrollScreen extends StatefulWidget {
  final bool isHRManager; // Pass this flag to differentiate roles
  final int employeeId;
  final String username;
  final int userId;

  const PayrollScreen({Key? key, required this.isHRManager, required this.employeeId, required this.username, required this.userId}) : super(key: key);

  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  final List<Map<String, dynamic>> payrollRecords = []; // Mock data source
  final TextEditingController basicSalaryController = TextEditingController();
  final TextEditingController deductionsController = TextEditingController();
  double netPay = 0.0;

  void calculateNetPay() {
    double basicSalary = double.tryParse(basicSalaryController.text) ?? 0.0;
    double deductions = double.tryParse(deductionsController.text) ?? 0.0;
    setState(() {
      netPay = basicSalary - deductions;
    });
  }

  Widget buildPayrollTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Payroll ID')),
        DataColumn(label: Text('Employee ID')),
        DataColumn(label: Text('Basic Salary')),
        DataColumn(label: Text('Deductions')),
        DataColumn(label: Text('Net Pay')),
        DataColumn(label: Text('Pay Date')),
      ],
      rows: payrollRecords.map((record) {
        return DataRow(
          cells: [
            DataCell(Text(record['Payroll_ID'].toString())),
            DataCell(Text(record['Employee_ID'].toString())),
            DataCell(Text(record['Basic_Salary'].toString())),
            DataCell(Text(record['Deductions'].toString())),
            DataCell(Text(record['Net_Pay'].toString())),
            DataCell(Text(record['Pay_Date'].toString())),
          ],
        );
      }).toList(),
    );
  }

  void showPayrollForm({Map<String, dynamic>? record}) {
    if (record != null) {
      basicSalaryController.text = record['Basic_Salary'].toString();
      deductionsController.text = record['Deductions'].toString();
      calculateNetPay();
    } else {
      basicSalaryController.clear();
      deductionsController.clear();
      setState(() {
        netPay = 0.0;
      });
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(record == null ? 'Add Payroll Record' : 'Edit Payroll Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: basicSalaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Basic Salary'),
              onChanged: (_) => calculateNetPay(),
            ),
            TextField(
              controller: deductionsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Deductions'),
              onChanged: (_) => calculateNetPay(),
            ),
            const SizedBox(height: 10),
            Text(
              'Net Pay: $netPay',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save logic goes here
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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
              title: const Text("Payroll Management"),
              centerTitle: true,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (widget.isHRManager)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => showPayrollForm(),
                          child: const Text('Add Payroll Record'),
                        ),
                      ],
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: buildPayrollTable(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

