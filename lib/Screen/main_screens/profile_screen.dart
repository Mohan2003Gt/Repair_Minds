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
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              // Navigate back to login screen here if needed
            },
          )
        ],
      ),
      // 1. Show loading spinner if the provider is busy fetching
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          
      // 2. Show error/empty state if no user is found
          : user == null
              ? const Center(child: Text("No profile data found."))
              
      // 3. Render the UI with the populated UserProfile model
              : ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    // Avatar Placeholder
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        user.firstName?.substring(0, 1).toUpperCase() ?? '?',
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Full Name
                    Center(
                      child: Text(
                        '${user.firstName ?? ''} ${user.lastName ?? ''}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Profile Details Cards
                    _buildProfileRow(Icons.alternate_email, 'Username', user.username),
                    _buildProfileRow(Icons.work_outline, 'Domain', user.domain),
                    _buildProfileRow(Icons.location_on_outlined, 'Place', user.place),
                    _buildProfileRow(Icons.info_outline, 'Bio', user.bio),
                  ],
                ),
    );
  }

  // A simple helper widget to keep the code clean
  Widget _buildProfileRow(IconData icon, String title, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        subtitle: Text(
          value != null && value.isNotEmpty ? value : 'Not provided',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}