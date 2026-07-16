import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the AuthProvider for changes
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userProfile;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"),
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 3,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.menu))
      ],
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text("No profile data found."))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar (with Upload Trigger) and Username Row
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
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
                                    user.firstName
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
                                  final error = await authProvider
                                      .uploadProfileImage();
                                  if (error != null && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                          Text("@",style: TextStyle(fontSize: 22),),
                          SizedBox(width: 2,),
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

                  // First Name
                  Row(
                    children: [
                      Text(
                        user.firstName != null && user.firstName!.isNotEmpty
                            ? user.firstName!
                            : 'First Name  ',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        user.lastName != null && user.lastName!.isNotEmpty
                            ? user.lastName!
                            : 'Last Name',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Domain
                  Row(
                    children: [
                      Text("Domain : ", style: TextStyle(fontSize: 18)),
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

                  // Bio
                  Row(
                    children: [
                      Text("Place : ", style: TextStyle(fontSize: 18)),
                      Text(
                        user.place != null && user.place!.isNotEmpty
                            ? user.place!
                            : 'Place',
                        style: const TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Place
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bio :", style: TextStyle(fontSize: 18)),
                      Text(
                        user.bio != null && user.bio!.isNotEmpty
                            ? user.bio!
                            : 'Bio',
                        style: const TextStyle(fontSize: 17, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 70,
                            child: IconButton(onPressed: (){}, icon: Icon(Icons.add),style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                                                    ),
                            ),),
                          ),
                          SizedBox(
                            width: 70,
                            child: IconButton(onPressed: (){}, icon: Icon(Icons.edit),style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                                                    ),
                            ),),
                          ),
                        ],
                      )

                    ],
                  )
                ],
              ),
            ),
    );
  }
}
