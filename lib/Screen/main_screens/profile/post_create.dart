import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Providers/post_provider.dart';

class PostCreate extends StatefulWidget {
  const PostCreate({super.key});

  @override
  State<PostCreate> createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _problemController = TextEditingController();
  
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_titleController.text.trim().isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a title and select an image.')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    final postProvider = Provider.of<PostProvider>(context, listen: false);
    
    final errorMessage = await postProvider.createPost(
      title: _titleController.text,
      subtitle: _subtitleController.text,
      problem: _problemController.text,
      imageFile: _selectedImage!,
    );

    if (mounted) {
      setState(() { _isLoading = false; });
      
      if (errorMessage == null) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post published successfully!')),
        );
        Navigator.pop(context); 
      } else {
        // Failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                      image: _selectedImage != null 
                        ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                        : null,
                      border: _selectedImage == null 
                          ? Border.all(color: Colors.grey.shade400, style: BorderStyle.solid) 
                          : null,
                    ),
                    child: _selectedImage == null 
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 50, color: Colors.blueAccent.shade200),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap to upload an image',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            )
                          ],
                        )
                      : null,
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Post Title',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _subtitleController,
                  decoration: InputDecoration(
                    labelText: 'Subtitle / Description',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _problemController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Summarize the Problem',
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: _uploadPost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Publish Post', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
        ),
    );
  }
}