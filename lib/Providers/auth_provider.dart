import 'package:flutter/material.dart';
import 'package:repair_minds/Services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _authService.currentUser;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?>signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      await _authService.signIn(
        email: email,
        password: password,
      );

      _setLoading(false);
      return null;
    } catch (e) {
      _setLoading(false);
      return "Something went wrong.";
    }
  }

  Future<String?> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String place,
    required String domain,
    required String bio,
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

      _setLoading(false);
      return null;
    } on AuthException catch (e) {
      _setLoading(false);
      return e.message;
    } catch (e) {
      _setLoading(false);
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}