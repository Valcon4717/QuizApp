import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/authentication_service.dart';

class LoginController extends ChangeNotifier {
  final AuthenticationService authService;

  bool isLoading = false;
  String? errorMessage;
  String? userProfile;

  LoginController({required this.authService});

  /// Calls the authentication service to log in.
  /// Returns true if login is successful, false otherwise.
  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await authService.login(username, password);

    isLoading = false;
    if (result["response"] == true) {
      await saveUserProfile(username);
      notifyListeners();
      return true;
    } else {
      errorMessage = result["reason"];
      notifyListeners();
      return false;
    }
  }

  Future<void> saveUserProfile(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('isSetupComplete', true);
  }
}
