import 'package:flutter/material.dart';
import '../../controller/theme_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to capture user input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: Icon(themeController.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode),
              onPressed: themeController.toggleTheme,
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            // Center the content vertically
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 80.0),

                // App logo or title
                Image.asset(
                  themeController.themeMode == ThemeMode.dark
                      ? 'assets/icons/HoneyDarkComplex.png'
                      : 'assets/icons/HoneyLightComplex.png',
                  height: 130,
                ),
                // Login form
                SizedBox(height: 8.0),
                Text(
                  'Welcome to CodeHive',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Let\'s sign you in',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFaa9988),
                  ),
                ),
                SizedBox(height: 16.0),
                // Username input
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                // Password input
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // Hide password text
                ),
                SizedBox(height: 16.0),
                // Show error message if available
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 16.0),

                // Username input

                // Login button
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: Text('Log In'),
                ),
              ],
            ),
          ),
        ));
  }

  void _handleLogin() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Clear any previous error message
    setState(() {
      _errorMessage = null;
    });

    // Validate input
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password.';
      });
      return;
    }

    // Call your login API here
    // On success, navigate to either the welcome/setup screen or home screen based on user status.
    // On failure, set an error message.

    print('Logging in with Username: $username, Password: $password');
    // Example: Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
