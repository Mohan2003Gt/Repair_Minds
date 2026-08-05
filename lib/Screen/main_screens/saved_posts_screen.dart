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
      appBar: AppBar(title: const Text('Saved Offline',style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 3,
      ),
      body: Consumer<SavedPostsProvider>(
        builder: (context, provider, child) {
          if (provider.savedPosts.isEmpty) {
            return const Center(child: Text("No saved posts."));
          }

          return ListView.builder(
            itemCount: provider.savedPosts.length,
            itemBuilder: (context, index) {
              final post = provider.savedPosts[index];

              return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => OfflinePostScreen(post: post)
                  ));
                },
                leading: post.localImagePath != null && File(post.localImagePath!).existsSync()
                    ? Image.file(File(post.localImagePath!), width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 50),
                title: Text(post.title),
                subtitle: Text(post.subtitle),
              );
            },
          );
        },
      ),
    );
  }
}