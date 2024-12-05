import 'dart:convert';
import 'package:http/http.dart' as http;

// Base API URL
const String apiUrl = 'http://127.0.0.1:5000/auth'; // Update if the Flask backend URL changes

/// Register a new user
Future<Map<String, dynamic>> registerUser(
  String username,
  String email,
  String password, {
  String role = 'Employee',
  int? employeeId,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'role': role,
        'employee_id': employeeId, // Not mandatory, can be null
      }),
    );

    if (response.statusCode == 201) {
      // Successful registration
      return {
        'success': true,
        'message': jsonDecode(response.body)['message'],
        'User_ID': jsonDecode(response.body)['User_ID']
      };
    } else {
      // Registration failed, capture error message
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
      return {'success': false, 'message': errorMessage};
    }
  } catch (e) {
    // Handle network or unexpected errors
    throw Exception('Error during registration: $e');
  }
}

/// Login user and retrieve access token
Future<String> loginUser(String username, String password, {int? userId}) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Login successful, return access token
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      // Login failed
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Invalid login credentials';
      throw Exception('Login failed: $errorMessage');
    }
  } catch (e) {
    throw Exception('Error during login: $e');
  }
}

/// Fetch all employees (requires token)
Future<List<dynamic>> fetchEmployees(String token) async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/employees'), // Ensure Flask route matches
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Successfully fetched employees
      final data = jsonDecode(response.body);
      return data['employees'];
    } else {
      // Fetching failed
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to fetch employees: $errorMessage');
    }
  } catch (e) {
    throw Exception('Error during employee fetch: $e');
  }
}

/// Fetch a specific user's details by ID (requires token)
Future<Map<String, dynamic>> fetchUserById(String token, int userId) async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/user/$userId'), // Ensure Flask route matches `/user/<int:user_id>`
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Successfully fetched user
      final data = jsonDecode(response.body);
      return data['user'];
    } else if (response.statusCode == 404) {
      throw Exception('User not found.');
    } else {
      // Other errors
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to fetch user: $errorMessage');
    }
  } catch (e) {
    throw Exception('Error during user fetch: $e');
  }
}

