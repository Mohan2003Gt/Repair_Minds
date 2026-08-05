import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Models/post_model.dart';
import 'package:repair_minds/Providers/post_provider.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Image
            Image.network(
              post.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    post.subtitle,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Problem",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // Problem description
                  Text(post.problem, style: const TextStyle(fontSize: 16)),
                ],
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
    );
  }
}
