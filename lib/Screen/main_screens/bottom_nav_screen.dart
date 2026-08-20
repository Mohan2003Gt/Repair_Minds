import 'package:flutter/material.dart';
import 'package:repair_minds/Screen/main_screens/home_screen.dart';
import 'package:repair_minds/Screen/main_screens/profile/profile_screen.dart';
import 'package:repair_minds/Screen/main_screens/saved_posts_screen.dart';
import 'package:repair_minds/Screen/main_screens/search_screen.dart';
import 'package:repair_minds/connectivity_wrapper.dart'; 

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  // 👇 The wrapper is applied individually here
  final List<Widget> _screens = [
    const ConnectivityWrapper(child: HomeScreen()),
    const ConnectivityWrapper(child: SearchScreen()),
    const SavedPostsScreen(),
    const ConnectivityWrapper(child: ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}