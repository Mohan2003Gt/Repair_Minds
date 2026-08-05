import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; 
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_minds/Models/post_model.dart';

class SavedPostsProvider extends ChangeNotifier {
  List<PostModel> _savedPosts = [];
  List<PostModel> get savedPosts => _savedPosts;

  final Set<int> _processingPosts = {};

  final String _storageKey = 'offline_saved_posts';

  SavedPostsProvider() {
    loadSavedPosts();
  } 






  Future<void> loadSavedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? postsString = prefs.getString(_storageKey);

    if (postsString != null) {
      List<dynamic> decodedList = json.decode(postsString);
      _savedPosts = decodedList.map((item) => PostModel.fromJson(item)).toList();
      notifyListeners();
    }
  }
   






  Future<void> toggleSavePost(PostModel post) async {
    if (_processingPosts.contains(post.id)) {
      debugPrint("Ignoring tap: Post ${post.id} is already saving/unsaving.");
      return; 
    }

    _processingPosts.add(post.id);
    notifyListeners(); 

    try {
      final prefs = await SharedPreferences.getInstance();
      final existingIndex = _savedPosts.indexWhere((p) => p.id == post.id);

      if (existingIndex >= 0) {
        final postToRemove = _savedPosts[existingIndex];
        if (postToRemove.localImagePath != null) {
          final file = File(postToRemove.localImagePath!);
          if (await file.exists()) await file.delete();
        }
        _savedPosts.removeAt(existingIndex);
      } else {
        if (post.imageUrl.isNotEmpty) {
          try {
            final directory = await getApplicationDocumentsDirectory();
            final filePath = '${directory.path}/saved_post_${post.id}.jpg';
            
            final dio = Dio();
            await dio.download(post.imageUrl, filePath);
            
            post.localImagePath = filePath; 
          } catch (e) {
            debugPrint("Image download error: $e");
          }
        }
        _savedPosts.insert(0, post);
      }

      final String encodedData = json.encode(_savedPosts.map((p) => p.toJson()).toList());
      await prefs.setString(_storageKey, encodedData);
      
    } finally {
      _processingPosts.remove(post.id);
      notifyListeners();
    }
  }

  bool isPostSaved(int postId) {
    return _savedPosts.any((p) => p.id == postId);
  }
}