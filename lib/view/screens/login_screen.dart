import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/theme_controller.dart';
import '../../controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to capture user input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _usernameError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context);
    final themeController = Provider.of<ThemeController>(context);
    return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            // Center the content vertically
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 150.0),
                Image.asset(
                  themeController.themeMode == ThemeMode.dark
                      ? 'assets/icons/HoneyDarkComplex.png'
                      : 'assets/icons/HoneyLightComplex.png',
                  height: 130,
                ),

                // Login form
                SizedBox(height: 10.0),
                Text(
                  'Welcome to CodeHive',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Let\'s sign you in',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFaa9988),
                  ),
                ),
                SizedBox(height: 25.0),
                // Username input
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    errorText: _usernameError,
                  ),
                ),
                SizedBox(height: 15.0),

                // Password input
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    errorText: _passwordError,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 15.0),

                // Login button
                SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _handleLogin(loginController);
                    },
                    child: const Text("Log In"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _handleLogin(LoginController loginController) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Clear previous error messages
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    // Validate input
    if (username.isEmpty && password.isEmpty) {
      setState(() {
        _usernameError = 'Please enter username.';
        _passwordError = 'Please enter password.';
      });
      return;
    } else if (username.isEmpty) {
      setState(() {
        _usernameError = 'Please enter username.';
      });
      return;
    } else if (password.isEmpty) {
      setState(() {
        _passwordError = 'Please enter password.';
      });
      return;
    }

    // Call the authentication logic in the LoginController
    bool success = await loginController.login(username, password);

    // Check if the widget is still mounted before navigating
    if (!mounted) return;

    if (success) {
      if (loginController.userProfile == null) {
        Navigator.pushReplacementNamed(context, '/welcome');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() {
        _usernameError = loginController.errorMessage;
        _passwordError = loginController.errorMessage;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
