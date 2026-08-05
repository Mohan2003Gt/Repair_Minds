import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repair_minds/Models/user_model.dart';
import 'package:repair_minds/Services/auth_service.dart';
import 'package:repair_minds/Services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Fetch profile
  Future<void> fetchUserProfile() async {
    final user = _authService.currentUser;

    if (user == null) return;

    _setLoading(true);

    _userProfile = await _profileService.fetchUserProfile(user.id);

    _setLoading(false);
  }

  // Refresh profile
  Future<void> refreshUserProfile() async {
    final user = _authService.currentUser;

    if (user == null) return;

    _userProfile = await _profileService.fetchUserProfile(user.id);

    notifyListeners();
  }

  // Update profile
  Future<void> updateProfile({
    required String username,
    required String firstName,
    required String lastName,
    required String place,
    required String domain,
    required String bio,
  }) async {
    _setLoading(true);

   final updatedProfile = UserProfile(
  id: _userProfile!.id,
  username: username,
  firstName: firstName,
  lastName: lastName,
  avatarUrl: _userProfile!.avatarUrl,
  place: place,
  domain: domain,
  bio: bio,
);
await _profileService.updateProfile(updatedProfile);

    await refreshUserProfile();

    _setLoading(false);
  }

  // Upload avatar
  Future<String?> uploadProfileImage() async {
    if (_userProfile == null) return "No user found.";

    final picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    _setLoading(true);

    try {
      final imageUrl = await _profileService.updateAvatar(
        _userProfile!.id,
        image,
      );

      _userProfile = UserProfile(
        id: _userProfile!.id,
        username: _userProfile!.username,
        firstName: _userProfile!.firstName,
        lastName: _userProfile!.lastName,
        avatarUrl: imageUrl,
        place: _userProfile!.place,
        domain: _userProfile!.domain,
        bio: _userProfile!.bio,
      );

      _setLoading(false);

      return null;
    } catch (e) {
      _setLoading(false);
      return e.toString();
    }
  }
}