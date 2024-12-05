import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Import your auth_service for backend calls

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    // Validate input fields
    if (_passwordController.text.isEmpty ||
        (_usernameController.text.isEmpty && _userIdController.text.isEmpty)) {
      setState(() {
        _errorMessage = "Please provide either Username or User ID along with Password.";
      });
      return;
    }

    // Parse User_ID if provided
    int? userId;
    if (_userIdController.text.isNotEmpty) {
      userId = int.tryParse(_userIdController.text);
      if (userId == null) {
        setState(() {
          _errorMessage = "User ID must be a valid number.";
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call the login API from the auth_service
      String token = await loginUser(
        _usernameController.text,
        _passwordController.text,
        userId: userId,
      );

      // Navigate to home on success
      print('Login Successful, Token: $token');
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      // Display error message
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.purple.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            // Left Side (Background Image)
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/hr7.png'), // Add your background image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Right Side Form
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/hr3.jpeg', // Add your logo
                                height: 120,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Kiambu HR Management System',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Username Input
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                                labelText: 'Username',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),

                            // User ID Input
                            TextField(
                              controller: _userIdController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.badge, color: Colors.blueAccent),
                                labelText: 'User ID (Optional)',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),

                            // Password Input
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                                labelText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              obscureText: true,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),

                            // Remember Me
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text('Remember Me'),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/forgot-password');
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                            ),

                            // Error Message
                            if (_errorMessage != null)
                              Card(
                                color: Colors.red.shade100,
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),

                            // Login Button
                            _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 32),
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),

                            // Register Button
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/register'),
                                child: const Text(
                                  'Don’t have an account? Register',
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






