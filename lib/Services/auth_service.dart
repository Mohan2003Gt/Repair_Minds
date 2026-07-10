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

  // signup

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required int age,
    required String username,
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
      ' ': lastName,
      'age': age,
      'username': username,
    });
  }
}
