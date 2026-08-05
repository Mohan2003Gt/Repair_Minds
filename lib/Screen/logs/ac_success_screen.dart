import 'package:flutter/material.dart';
import 'package:repair_minds/Screen/logs/login_screen.dart';
class AcSuccessScreen extends StatelessWidget {
  const AcSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, size: 100, color: Colors.green),
            SizedBox(height: 10),
            Text("Account Create Successfully"),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}
