import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repair_minds/Models/post_model.dart';
import 'package:repair_minds/Services/auth_service.dart';
import 'package:repair_minds/Services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  final AuthService _authService = AuthService();

  List _userPosts = [];
  List get userPosts => _userPosts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future fetchUserPosts() async {
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

  Future<String?> createPost({
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

  List _searchResults = [];
  List get searchResults => _searchResults;

  int _searchStart = 0;
  static const int _searchLimit = 5;

  bool _searchHasMore = true;
  bool _isSearchingMore = false;

  bool get searchHasMore => _searchHasMore;
  bool get isSearchingMore => _isSearchingMore;

  Future searchPosts(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchStart = 0;
      _searchHasMore = true;
      _isSearchingMore = false;
      notifyListeners();
      return;
    }

    _searchStart = 0;
    _searchHasMore = true;
    _isSearchingMore = false;

    _setLoading(true);

    try {
      final posts = await _postService.searchPostsByTitle(
        query,
        _searchStart,
        _searchLimit,
      );

      _searchResults = posts;

      if (posts.length < _searchLimit) {
        _searchHasMore = false;
      }
    } catch (e) {
      debugPrint('Search Provider Error: $e');
    }

    _setLoading(false);
  }

  Future loadMoreSearchPosts(String query) async {
    if (_isSearchingMore || !_searchHasMore) return;

    _isSearchingMore = true;
    notifyListeners();

    try {
      final nextStart = _searchStart + _searchLimit;

      final posts = await _postService.searchPostsByTitle(
        query,
        nextStart,
        _searchLimit,
      );

      if (posts.isNotEmpty) {
        _searchStart = nextStart;
        _searchResults.addAll(posts);
      }

      if (posts.length < _searchLimit) {
        _searchHasMore = false;
      }
    } catch (e) {
      debugPrint('Load More Search Error: $e');
    }

    _isSearchingMore = false;
    notifyListeners();
  }

  List _feedPosts = [];
  List get feedPosts => _feedPosts;

  int _start = 0;
  static const int _limit = 5;

  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future fetchDomainPosts(String domain) async {
    _setLoading(true);

    _start = 0;
    _hasMore = true;

    try {
      final posts = await _postService.fetchPostsByDomain(
        domain,
        _start,
        _limit,
      );

      _feedPosts = posts;

      if (posts.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('Domain Provider Error: $e');
    }

    _setLoading(false);
  }

  Future loadMorePosts(String domain) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextStart = _start + _limit;

      final posts = await _postService.fetchPostsByDomain(
        domain,
        nextStart,
        _limit,
      );

      if (posts.isNotEmpty) {
        _start = nextStart;
        _feedPosts.addAll(posts);
      }

      if (posts.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('Load More Error: $e');
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future deletePost(PostModel post) async {
    await _postService.deletePost(
      post.id,
      post.imageUrl,
    );

    _userPosts.removeWhere(
      (p) => p.id == post.id,
    );

    notifyListeners();
  }
}