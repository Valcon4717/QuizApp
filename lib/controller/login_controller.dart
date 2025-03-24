import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import '../model/authentication_service.dart';

class LoginController extends ChangeNotifier {
  final AuthenticationService authService;

  bool isLoading = false;
  String? errorMessage;
  String? userProfile;

  LoginController({required this.authService});

  /// Calls the authentication service to log in.
  /// Returns true if login is successful, false otherwise.
  Future<bool> login(String username, String pin) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await authService.login(username, pin);

    isLoading = false;
    if (result["response"] == true) {
      await saveUserProfile(username, pin);
      notifyListeners();
      return true;
    } else {
      errorMessage = result["reason"];
      notifyListeners();
      return false;
    }
  }

  Future<void> saveUserProfile(String username, String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('pin', pin);
    await prefs.setBool('isSetupComplete', true);
    log("LoginController: Saved username: $username, pin: $pin");
  }
}
