import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repair_minds/Models/user_model.dart';
import 'package:repair_minds/Services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserProfile? userProfile;

  // Returns null if successful, or an error message string if it fails
  Future<String?> signIn(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _authService.signIn(email: email, password: password);
      
      // Populate user profile after login
      if (response.user != null) {
        userProfile = await _authService.fetchUserProfile(response.user!.id);
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
        userProfile = await _authService.fetchUserProfile(currentUser.id);
      }

      _setLoading(false);
      return null; 
    } on AuthException catch (e) { 
      _setLoading(false); 
      return e.message; 
    } catch (e) { 
      _setLoading(false); 
      
      // Check if it's our custom Exception for username uniqueness
      if (e is Exception) {
        return e.toString().replaceAll('Exception: ', '');
      }
      return 'An unexpected error occurred.'; 
    }
  }

  // Sign Out logic
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    userProfile = null; // Clear state on logout
    notifyListeners();
  }

  // Upload Profile Image Logic
  Future<String?> uploadProfileImage() async {
    if (userProfile == null) return 'No active user session.';

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null; // User canceled picking

    _setLoading(true);
    try {
      // Upload image and get new URL
      final newImageUrl = await _authService.updateAvatar(userProfile!.id, image);

      // Re-instantiate the UserProfile with the updated avatar URL
      userProfile = UserProfile(
        id: userProfile!.id,
        username: userProfile!.username,
        firstName: userProfile!.firstName,
        lastName: userProfile!.lastName,
        avatarUrl: newImageUrl, 
        place: userProfile!.place,
        domain: userProfile!.domain,
        bio: userProfile!.bio,
      );

      _setLoading(false);
      return null; // Success
    } catch (e) {
      _setLoading(false);
      return 'Failed to upload image: $e';
    }
  }

  // Helper method to update loading state and notify the UI
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}