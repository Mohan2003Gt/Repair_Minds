import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadFeed();
    });
  }

  Future<void> _loadFeed() async {
    final profileProvider = context.read<ProfileProvider>();
    final postProvider = context.read<PostProvider>();

    if (profileProvider.userProfile == null) {
      await profileProvider.fetchUserProfile();
    }

    final userDomain = profileProvider.userProfile?.domain ?? '';

    if (userDomain.isNotEmpty) {
      postProvider.fetchDomainPosts(userDomain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feed',style: TextStyle(
        fontWeight: FontWeight.bold,
       
        ),),
        backgroundColor: Colors.white,
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
                    child: Icon(Icons.person, size: 16, color: Colors.white),
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
                    // The Circular Avatar
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage: hasAvatar
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child: !hasAvatar
                          ? Text(
                              displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
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
        child: Consumer<PostProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.feedPosts.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.feed_outlined, size: 100, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No posts found ",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: provider.feedPosts.length,
              itemBuilder: (context, index) {
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

                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<UserProfile?>(
                          future: ProfileService().fetchUserProfile(
                            post.userId,
                          ),
                          builder: (context, snapshot) {
                            String displayName = 'Loading...';
                            String avatarUrl = '';
                            String location ='';
                            bool hasAvatar = false;

                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              final profile = snapshot.data!;
                              displayName = profile.username ?? 'Unknown User';
                              location =  profile.place ?? 'Undefind';
                              avatarUrl = profile.avatarUrl ?? '';
                              hasAvatar = avatarUrl.isNotEmpty;
                            }

                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.blueAccent,
                                    backgroundImage: hasAvatar
                                        ? NetworkImage(avatarUrl)
                                        : null,
                                    child: !hasAvatar
                                        ? Text(
                                            displayName != 'Loading...' &&
                                                    displayName !=
                                                        'Unknown User' &&
                                                    displayName.isNotEmpty
                                                ? displayName[0].toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(Icons.location_on,color: Colors.grey.shade500,size: 20,),
                                  Text(
                                    location,
                                    style: const TextStyle(
                                      
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            image: post.imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(post.imageUrl),
                                    fit: BoxFit.fill,
                                  )
                                : null,
                          ),
                          child: post.imageUrl.isEmpty
                              ? const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                          child: Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                          child: Text(
                            post.subtitle,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
