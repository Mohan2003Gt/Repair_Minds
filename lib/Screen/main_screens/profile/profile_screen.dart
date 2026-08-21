import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Providers/post_provider.dart';
import 'package:repair_minds/Providers/profile_provider.dart';
import 'package:repair_minds/Screen/main_screens/profile/edit_profile.dart';
import 'package:repair_minds/Screen/main_screens/profile/post_create.dart';
import 'package:repair_minds/Screen/main_screens/profile/post_details.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProfileProvider>().fetchUserProfile();
      if (!mounted) return;
      await context.read<PostProvider>().fetchUserPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final postProvider = context.watch<PostProvider>();
    final user = profileProvider.userProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 3,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text("No profile data found."))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,

                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.black,
                            ),

                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage:
                                  user.avatarUrl != null &&
                                      user.avatarUrl!.isNotEmpty
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                              child:
                                  user.avatarUrl == null ||
                                      user.avatarUrl!.isEmpty
                                  ? Text(
                                      user.username
                                              ?.substring(0, 1)
                                              .toUpperCase() ??
                                          '?',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 16,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () async {
                                    final error = await profileProvider
                                        .uploadProfileImage();
                                    if (error != null && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(error)),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("@", style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 2),
                            Text(
                              user.username ?? 'Username',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // First Name & Last Name
                    Row(
                      children: [
                        Text(
                          user.firstName != null && user.firstName!.isNotEmpty
                              ? user.firstName!
                              : 'First Name  ',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          user.lastName != null && user.lastName!.isNotEmpty
                              ? user.lastName!
                              : 'Last Name',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Domain
                    Row(
                      children: [
                        const Text("Domain : ", style: TextStyle(fontSize: 18)),
                        Text(
                          user.domain != null && user.domain!.isNotEmpty
                              ? user.domain!
                              : 'Domain',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Place
                    Row(
                      children: [
                        const Text("Place : ", style: TextStyle(fontSize: 18)),
                        Text(
                          user.place != null && user.place!.isNotEmpty
                              ? user.place!
                              : 'Place',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Bio
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Bio :", style: TextStyle(fontSize: 18)),
                        Text(
                          user.bio != null && user.bio!.isNotEmpty
                              ? user.bio!
                              : 'Bio',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 130,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PostCreate(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add Post"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 5,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const Text(
                      "My Posts",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    postProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : postProvider.userPosts.isEmpty
                        ? const Center(
                            child: Column(
                              children: [
                                SizedBox(height: 100),
                                Text(
                                  "No posts found",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.8,
                                ),
                            itemCount: postProvider.userPosts.length,
                            itemBuilder: (context, index) {
                              final post = postProvider.userPosts[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PostDetailsScreen(post: post),
                                    ),
                                  );
                                },
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.grey.shade200,
                                          child: Image.network(
                                            post.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          post.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
