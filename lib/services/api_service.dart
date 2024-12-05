import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for your backend (adjust if necessary)
  final String baseUrl = "http://localhost:5000"; // Update this with your backend URL

  // Generic GET request
  Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Generic POST request
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  // Generic PUT request
  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data');
    }
  }

  // Generic DELETE request
  Future<dynamic> deleteRequest(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  // Get all employees
  Future<dynamic> getAllEmployees() async {
    return getRequest('employees'); // Endpoint to get all employees
  }

  // Get a single employee by ID
  Future<dynamic> getEmployeeById(int id) async {
    return getRequest('employee/$id'); // Endpoint to get employee by ID
  }

  // Create new employee
  Future<dynamic> createEmployee(Map<String, dynamic> employeeData) async {
    return postRequest('employee', employeeData); // Endpoint to create a new employee
  }

  // Update employee details
  Future<dynamic> updateEmployee(int id, Map<String, dynamic> employeeData) async {
    return putRequest('employee/$id', employeeData); // Endpoint to update employee by ID
  }

  // Delete employee
  Future<dynamic> deleteEmployee(int id) async {
    return deleteRequest('employee/$id'); // Endpoint to delete employee by ID
  }

  // Create leave request
  Future<dynamic> createLeaveRequest(Map<String, dynamic> leaveData) async {
    return postRequest('leave', leaveData); // Reuse postRequest method for leave requests
  }

  // Get all leave requests
  Future<dynamic> getAllLeaveRequests() async {
    return getRequest('leave'); // Reuse getRequest method for fetching leave requests
  }

  // Get a single leave request by ID
  Future<dynamic> getLeaveRequestById(int id) async {
    return getRequest('leave/$id'); // Reuse getRequest method for a specific leave request
  }

  // Get all training sessions
  Future<dynamic> getAllTrainingSessions() async {
    return getRequest('training'); // Endpoint to get all training sessions
  }

  // Get a specific training session by ID
  Future<dynamic> getTrainingSessionById(int id) async {
    return getRequest('training/$id'); // Endpoint to get training session by ID
  }

  // Create new training session
  Future<dynamic> createTrainingSession(Map<String, dynamic> trainingData) async {
    return postRequest('training', trainingData); // Endpoint to create new training session
  }

  // Get all payroll runs
  Future<dynamic> getAllPayrollRuns() async {
    return getRequest('payroll'); // Endpoint to get all payroll runs
  }

  // Get payroll by ID
  Future<dynamic> getPayrollById(int id) async {
    return getRequest('payroll/$id'); // Endpoint to get payroll by ID
  }

  // Create new payroll run
  Future<dynamic> createPayrollRun(Map<String, dynamic> payrollData) async {
    return postRequest('payroll', payrollData); // Endpoint to create new payroll run
  }

  // Get performance data for employees
  Future<dynamic> getEmployeePerformance() async {
    return getRequest('performance'); // Endpoint to get employee performance data
  }

  // Get performance data for a specific employee by ID
  Future<dynamic> getPerformanceByEmployeeId(int id) async {
    return getRequest('performance/$id'); // Endpoint to get performance by employee ID
  }

  // Get department data
  Future<dynamic> getAllDepartments() async {
    return getRequest('department'); // Endpoint to get all departments
  }

  // Get department details by ID
  Future<dynamic> getDepartmentById(int id) async {
    return getRequest('department/$id'); // Endpoint to get department details by ID
  }

  // Create a new department
  Future<dynamic> createDepartment(Map<String, dynamic> departmentData) async {
    return postRequest('department', departmentData); // Endpoint to create new department
  }

  // Get all reports
  Future<dynamic> getAllReports() async {
    return getRequest('reports'); // Endpoint to get all reports
  }

  // Get specific report by ID
  Future<dynamic> getReportById(int id) async {
    return getRequest('reports/$id'); // Endpoint to get report by ID
  }
}

