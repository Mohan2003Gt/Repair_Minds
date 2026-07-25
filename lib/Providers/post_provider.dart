import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repair_minds/Models/post_model.dart';
import 'package:repair_minds/Services/auth_service.dart';
import 'package:repair_minds/Services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  final AuthService _authService = AuthService();

  List<PostModel> _userPosts = [];
  List<PostModel> get userPosts => _userPosts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Fetch current user's posts
  Future<void> fetchUserPosts() async {
    final user = _authService.currentUser;

    if (user == null) return;

    _setLoading(true);

    try {
      _userPosts = await _postService.fetchUserPosts(user.id);
    } catch (e) {
      debugPrint('$e');
    }

    _setLoading(false);
  }

  // Create post
  Future<String?>createPost({
    required String title,
    required String subtitle,
    required String problem,
    required File imageFile,
  }) async {
    final user = _authService.currentUser;

    if (user == null) {
      return "User not logged in";
    }

    _setLoading(true);

    try {
      await _postService.createPost(
        userId: user.id,
        title: title,
        subtitle: subtitle,
        problem: problem,
        imageFile: imageFile,
      );

      await fetchUserPosts();

      _setLoading(false);

      return null;
    } catch (e) {
      _setLoading(false);
      return e.toString();
    }
  }

List<PostModel> _searchResults = [];
List<PostModel> get searchResults => _searchResults;

Future<void> searchPosts(String query) async {
  if (query.trim().isEmpty) {
    _searchResults = [];
    notifyListeners();
    return;
  }

  _setLoading(true);

  try {
    _searchResults = await _postService.searchPostsByTitle(query);
  } catch (e) {
    debugPrint('Search Provider Error: $e');
  }

  _setLoading(false);
}
// 1. Add these state variables
  List<PostModel> _feedPosts = [];
  List<PostModel> get feedPosts => _feedPosts;

  Future<void> fetchDomainPosts(String domain) async {
    _setLoading(true);

    try {
      _feedPosts = await _postService.fetchPostsByDomain(domain);
    } catch (e) {
      debugPrint('Domain Provider Error: $e');
    }

    _setLoading(false);
  }

  Future<void> deletePost(int postId) async {
    await _postService.deletePost(postId);

    _userPosts.removeWhere(
      (post) => post.id == postId,
    );
    notifyListeners();
  }
}