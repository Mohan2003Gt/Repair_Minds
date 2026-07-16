import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:repair_minds/Models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  User? get currentUser => _supabase.auth.currentUser;

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String place,
    required String domain,
    required String bio,
    required String email,
    required String password,
  }) async {
    final normalizedUsername = username.trim().toLowerCase();

    // 1. PRE-CHECK: See if the username is already taken
    final existingUser = await _supabase
        .from('User_Profiles')
        .select('username')
        .ilike('username', normalizedUsername)
        .maybeSingle();

    if (existingUser != null) {
      throw Exception('This username is already taken. Please choose another one.');
    }

    // 2. Proceed with creating the auth account
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception("Account creation failed");
    }

    // 3. Insert the profile
    await _supabase.from('User_Profiles').insert({
      'id': user.id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'place': place,
      'domain': domain,
      'bio': bio,
    });
  }

  Future<UserProfile?> fetchUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('User_Profiles') 
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromJson(data);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // Handle uploading avatar to storage and updating the database
  Future<String> updateAvatar(String userId, XFile pickedFile) async {
    final file = File(pickedFile.path);
    final fileExt = pickedFile.path.split('.').last;
    final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';

    // Upload to Supabase Storage bucket
    await _supabase.storage.from('avatars').upload(
          fileName,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    // Retrieve public URL
    final imageUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);

    // Update avatar_url in the database
    await _supabase.from('User_Profiles').update({
      'avatar_url': imageUrl,
    }).eq('id', userId);

    return imageUrl;
  }
}