import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Providers/post_provider.dart';
import 'package:repair_minds/Screen/main_screens/common_screen/post_details_view.dart'; 
import 'package:repair_minds/Services/profile_service.dart'; 
import 'package:repair_minds/Models/user_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Posts',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 3,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                context.read<PostProvider>().searchPosts(value);
              },
            ),
          ),
          
          // Search Results
          Expanded(
            child: Consumer<PostProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.searchResults.isEmpty && _searchController.text.isNotEmpty) {
                  return const Center(child: Text('No posts found.'));
                }
                
                if (provider.searchResults.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 100, color: Colors.grey,),
                        Text(
                          "Search a Solution For Problem",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    final post = provider.searchResults[index];
                    
                    return GestureDetector(
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailsView(post: post),
                      ),
                    );
                  },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<UserProfile?>(
                              future: ProfileService().fetchUserProfile(post.userId),
                              builder: (context, snapshot) {
                                String displayName = 'Loading...';
                                String avatarUrl = '';
                                bool hasAvatar = false;
                      
                                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                  final profile = snapshot.data!;
                                  displayName = profile.username ?? 'Unknown User';
                                  avatarUrl = profile.avatarUrl ?? '';
                                  hasAvatar = avatarUrl.isNotEmpty;
                                }
                      
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.blueAccent,
                                        backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                                        child: !hasAvatar
                                            ? Text(
                                                displayName != 'Loading...' && displayName != 'Unknown User' && displayName.isNotEmpty
                                                    ? displayName[0].toUpperCase()
                                                    : '?',
                                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // ----------------------------------------------------
                      
                            // Your existing Post Image Container
                            Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                image: DecorationImage(
                                  image: NetworkImage(post.imageUrl),
                                  fit: BoxFit.fill, 
                                )
                              ),               
                            ),
                      
                            // Your existing Post Title
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Title(
                                color: Colors.black, 
                                child: Text(
                                  post.title,
                                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                )
                              )
                            ),
                      
                            // Your existing Post Subtitle
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Title(
                                color: Colors.black, 
                                child: Text(
                                  post.subtitle,
                                  style: const TextStyle(fontSize: 15),
                                )
                              )
                            )
                          ],
                        )
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}    