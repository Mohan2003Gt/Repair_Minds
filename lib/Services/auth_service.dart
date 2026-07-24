import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

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
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception("Account creation failed");
    }

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

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}