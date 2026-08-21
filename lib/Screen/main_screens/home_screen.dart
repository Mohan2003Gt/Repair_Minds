import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Models/post_model.dart';
import 'package:repair_minds/Providers/post_provider.dart';
import 'package:repair_minds/Providers/profile_provider.dart';
import 'package:repair_minds/Screen/main_screens/common_screen/post_details_view.dart';
import 'package:repair_minds/Services/profile_service.dart';
import 'package:repair_minds/Models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadFeed();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final profileProvider = context.read<ProfileProvider>();
      final postProvider = context.read<PostProvider>();

      final domain = profileProvider.userProfile?.domain ?? '';

      if (domain.isNotEmpty) {
        postProvider.loadMorePosts(domain);
      }
    }
  }

  Future<void> _loadFeed() async {
    final profileProvider = context.read<ProfileProvider>();
    final postProvider = context.read<PostProvider>();

    if (profileProvider.userProfile == null) {
      await profileProvider.fetchUserProfile();
    }

    final userDomain = profileProvider.userProfile?.domain ?? '';

    if (userDomain.isNotEmpty) {
      await postProvider.fetchDomainPosts(userDomain);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Feed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        elevation: 3,
        actions: [
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              final profile = profileProvider.userProfile;

              if (profile == null) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                );
              }

              final hasAvatar =
                  profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty;
              final displayName = profile.username ?? 'User';

              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage:
                          hasAvatar ? NetworkImage(profile.avatarUrl!) : null,
                      child: !hasAvatar
                          ? Text(
                              displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadFeed,
        color: Colors.blueAccent,
        child: Consumer<PostProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              );
            }

            if (provider.feedPosts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.feed_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No posts found",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Check back later for updates.",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.feedPosts.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.feedPosts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blueAccent),
                    ),
                  );
                }

                final post = provider.feedPosts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailsView(post: post),
                      ),
                    );
                  },
                  child: PostCard(post: post),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final PostModel post;
  
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().fetchUserProfile(widget.post.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Header
          FutureBuilder<UserProfile?>(
            future: _profileFuture,
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

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.shade100,
                  backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                  child: !hasAvatar
                      ? Text(
                          displayName != 'Loading...' && displayName != 'Unknown User' && displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                title: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              );
            },
          ),

          // Post Image
          Container(
            width: double.infinity,
            height: 220,
            color: Colors.grey.shade100,
            child: Image.network(
              widget.post.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
              },
            ),
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.title,
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.post.subtitle,
                  style: TextStyle(
                    fontSize: 15, 
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}