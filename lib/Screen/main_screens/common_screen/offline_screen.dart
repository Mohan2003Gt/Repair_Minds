import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 100, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7),
           
                Text(
                  'Try to Connect',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 20,
                  height: 20,
                   child: const CircularProgressIndicator(
                    color: Colors.grey,
                                   ),
                 )
          ],
        ),
      ),
    );
  }
}