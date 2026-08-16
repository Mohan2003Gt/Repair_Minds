import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Models/post_model.dart';
import 'package:repair_minds/Providers/post_provider.dart';
import 'package:repair_minds/Providers/saved_posts_provider.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;
  
  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          post.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        elevation: 1, 
        actions: [
          Consumer<SavedPostsProvider>(
            builder: (context, provider, child) {
              final isSaved = provider.isPostSaved(post.id);
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.blueAccent : Colors.black87,
                    size: 26,
                  ),
                  onPressed: () {
                    provider.toggleSavePost(post);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Image Header
            Container(
              width: double.infinity,
              height: 300.0,
              color: Colors.grey.shade100, 
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover, 
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image_rounded, size: 64, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("Image not available", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            // Post Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    post.subtitle,
                    style: TextStyle(
                      fontSize: 18, 
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Divider(height: 1, thickness: 0.5),
                  ),

                  // Problem Section Header
                  Row(
                    children: [
                      const Icon(Icons.build_circle_outlined, color: Colors.blueAccent, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        "Problem",
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),

                  // Problem Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
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
                  
                   Center(
              child: ElevatedButton(
                onPressed: () async {
                  context.read<PostProvider>().deletePost(post);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                child: Text("DELETE", style: TextStyle(color: Colors.white)),
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