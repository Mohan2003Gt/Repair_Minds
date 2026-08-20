import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repair_minds/Models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<PostModel>> fetchUserPosts(String userId) async {
    try {
      final data = await _supabase.from('Posts').select().eq('user_id', userId);

      return (data as List)
          .map((postJson) => PostModel.fromJson(postJson))
          .toList();
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      return [];
    }
  }

  Future<void> deletePost(int postId, String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        final uri = Uri.parse(imageUrl);
        final fileName = uri.pathSegments.last;

        await _supabase.storage.from('posts').remove([fileName]);
      }
    } catch (e) {
      return;
    }

    await _supabase.from('Posts').delete().eq('id', postId);
  }

  Future<List<PostModel>> searchPostsByTitle(
    String query,
    int start,
    int limit,
  ) async {
    try {
      final data = await _supabase
          .from('Posts')
          .select()
          .ilike('title', '%${query.trim()}%')
          .range(start, start + limit - 1);

      return (data as List)
          .map((postJson) => PostModel.fromJson(postJson))
          .toList();
    } catch (e) {
      debugPrint('Error searching posts: $e');
      return [];
    }
  }

  Future<List<PostModel>> fetchPostsByDomain(
    String domain,
    int start,
    int limit,
  ) async {
    try {
      final data = await _supabase
          .from('Posts')
          .select()
          .ilike('title', '%$domain%')
          .order('created_at', ascending: false)
          .range(start, start + limit - 1);

      return (data as List)
          .map((postJson) => PostModel.fromJson(postJson))
          .toList();
    } catch (e) {
      debugPrint('Error fetching domain posts: $e');
      return [];
    }
  }

  Future<void> createPost({
    required String userId,
    required String title,
    required String subtitle,
    required String problem,
    required File imageFile,
  }) async {
    try {
      final fileExt = imageFile.path.split('.').last;

      final fileName =
          'post-$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await _supabase.storage
          .from('posts')
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = _supabase.storage.from('posts').getPublicUrl(fileName);

      await _supabase.from('Posts').insert({
        'user_id': userId,
        'title': title,
        'subtitle': subtitle,
        'problem': problem,
        'image_url': imageUrl,
      });
    } catch (e) {
      debugPrint('Error creating post: $e');
      throw Exception('Failed to create post');
    }
  }
}
