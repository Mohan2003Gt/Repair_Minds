import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {  

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController usernameController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController bioController;
  late TextEditingController domainController;
  late TextEditingController placeController;

  @override
  void initState() {
    super.initState();

    final user = context.read<ProfileProvider>().userProfile!;

    usernameController = TextEditingController(text: user.username);
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    bioController = TextEditingController(text: user.bio);
    domainController = TextEditingController(text: user.domain);
    placeController = TextEditingController(text: user.place);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),

            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),

            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),

            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: "Bio"),
            ),
            TextField(
              controller: domainController,
              decoration: InputDecoration(label: Text("Domain")),
            ),
            TextField(
              controller: placeController,
              decoration: InputDecoration(label: Text("Place")),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await context.read<ProfileProvider>().updateProfile(
                  username: usernameController.text,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  bio: bioController.text,
                  place: placeController.text,
                  domain: domainController.text
                );
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
