import 'package:flutter/material.dart';
import 'package:repair_minds/Models/user_model.dart';
import 'package:repair_minds/Services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  // Returns null if successful, or an error message string if it fails
  Future<String?> signIn(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _authService.signIn(email: email, password: password);
      
      // Populate user profile after login
      if (response.user != null) {
        _userProfile = await _authService.fetchUserProfile(response.user!.id);
      }

      _setLoading(false);
      return null; 
    } on AuthException catch (e) {
      _setLoading(false);
      return e.message; 
    } catch (e) {
      _setLoading(false);
      return 'An unexpected error occurred.';
    }
  }

  // Returns null if successful, or an error message string if it fails
  Future<String?> signUp({
    required String firstName,
    required String lastName,
    required String place,
    required String domain,
    required String bio,
    required String username,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.signUp(
        firstName: firstName,
        lastName: lastName,
        username: username,
        place: place,
        domain: domain,
        bio: bio,
        email: email,
        password: password,
      );

      // Populate user profile after signup
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        _userProfile = await _authService.fetchUserProfile(currentUser.id);
      }

      _setLoading(false);
      return null; 
    } on AuthException catch (e) { 
      _setLoading(false); 
      return e.message; 
    } catch (e) { 
      _setLoading(false); 
      return 'An unexpected error occurred.'; 
    }
  }

  // Sign Out logic
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    _userProfile = null; // Clear state on logout
    notifyListeners();
  }

  // Helper method to update loading state and notify the UI
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}