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

  final List<Widget> _screens = [
    const ConnectivityWrapper(child: HomeScreen()),
    const ConnectivityWrapper(child: SearchScreen()),
    const SavedPostsScreen(),
    const ConnectivityWrapper(child: ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal, 
            fontSize: 12,
          ),
          elevation: 0, 
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.search),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.search),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.bookmark_border),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.bookmark),
              ),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.person_outline),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}