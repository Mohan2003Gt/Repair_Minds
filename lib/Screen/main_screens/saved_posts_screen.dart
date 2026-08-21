import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Providers/saved_posts_provider.dart';
import 'package:repair_minds/Screen/main_screens/common_screen/offline_post_screen.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Saved Offline',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        elevation: 3,
      ),
      body: Consumer<SavedPostsProvider>(
        builder: (context, provider, child) {
          if (provider.savedPosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No saved posts",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Posts you save will appear here.",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.savedPosts.length,
            itemBuilder: (context, index) {
              final post = provider.savedPosts[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfflinePostScreen(post: post),
                      ),
                    );
                  },
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: post.localImagePath != null &&
                            File(post.localImagePath!).existsSync()
                        ? Image.file(
                            File(post.localImagePath!),
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.broken_image, color: Colors.grey.shade400),
                  ),
                  title: Text(
                    post.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      post.subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}