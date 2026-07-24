import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repair_minds/Models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserProfile?> fetchUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('User_Profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromJson(data);
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      return null;
    }
  }

  Future<void> updateProfile({
    required String username,
    required String firstName,
    required String lastName,
    required String place,
    required String domain,
    required String bio,
  }) async {
    final userId = _supabase.auth.currentUser!.id;

    await _supabase
        .from('User_Profiles')
        .update({
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'place': place,
          'domain': domain,
          'bio': bio,
        })
        .eq('id', userId);
  }

  Future<String> updateAvatar(
    String userId,
    XFile pickedFile,
  ) async {
    final file = File(pickedFile.path);

    final fileExt = pickedFile.path.split('.').last;

    final fileName =
        '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';

    await _supabase.storage.from('avatars').upload(
          fileName,
          file,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );

    final imageUrl =
        _supabase.storage.from('avatars').getPublicUrl(fileName);

    await _supabase
        .from('User_Profiles')
        .update({
          'avatar_url': imageUrl,
        })
        .eq('id', userId);

    return imageUrl;
  }
}