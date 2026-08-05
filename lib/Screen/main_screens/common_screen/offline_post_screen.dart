import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Models/post_model.dart';
import 'package:repair_minds/Providers/saved_posts_provider.dart';

class OfflinePostScreen extends StatelessWidget {
  final PostModel post;

  const OfflinePostScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final bool hasLocalImage =
        post.localImagePath != null && File(post.localImagePath!).existsSync();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
           Consumer<SavedPostsProvider>(
      builder: (context, provider, child) {
        final isSaved = provider.isPostSaved(post.id);
        return IconButton(
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: isSaved ? Colors.blue : Colors.black,
          ),
          onPressed: () {
            provider.toggleSavePost(post);
          },
        );
      },
    ),
        ],
        title:  Text(
          post.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. THE IMAGE (Loaded entirely offline!)
            if (hasLocalImage)
              Image.file(
                File(post.localImagePath!),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[200],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Image not available offline",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    post.subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Divider(height: 40, thickness: 1),
                  const Text(
                    "Problem",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      post.problem,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
