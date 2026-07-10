import 'package:flutter/material.dart';
import 'package:repair_minds/Services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Returns null if successful, or an error message string if it fails
  Future<String?> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signIn(email: email, password: password);
      _setLoading(false);
      return null; // Null means no errors!
    } on AuthException catch (e) {
      _setLoading(false);
      return e.message; // Return the Supabase error message
    } catch (e) {
      _setLoading(false);
      return 'An unexpected error occurred.';
    }
  }

  Future signUp({
    required String firstName,
    required String lastName,
    required String place,
    required String domain,
    required String bio,
    required String username,
    required String email,
    required String password,
  }) async {
    return await _authService.signUp(
      firstName: firstName,
      lastName: lastName,
      username: username,
      place: place,
      domain: domain,
      bio: bio,
      email: email,
      password: password,
    );
  }

  // Helper method to update loading state and notify the UI
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
