import 'package:flutter/material.dart';
import 'package:repair_minds/Models/post_model.dart';

class PostDetailsView extends StatelessWidget {
  final PostModel post;
  
  const PostDetailsView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(post.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Ensures the title text is black
        elevation: 1, // Adds a subtle shadow under the normal app bar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Standard Image Header
            Container(
              width: double.infinity,
              height: 300.0,
              color: Colors.grey.shade200, // Light grey background
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.fitWidth, 
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 28,
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
                    child: Divider(height: 1, thickness: 1),
                  ),

                  // Problem Section Header
                  const Text(
                    "Problem",
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Problem Description
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
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}