import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repair_minds/Providers/auth_provider.dart';
import 'package:repair_minds/Providers/post_provider.dart';
import 'package:repair_minds/Providers/profile_provider.dart';
import 'package:repair_minds/Providers/saved_posts_provider.dart';
import 'package:repair_minds/Screen/logs/login_screen.dart';
import 'package:repair_minds/Screen/main_screens/bottom_nav_screen.dart';
import 'package:repair_minds/reset_password_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SavedPostsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
 
class MyApp extends StatefulWidget { 
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isPasswordRecovery = false;

  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        if (!mounted) return;

        setState(() {
          _isPasswordRecovery = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      builder: (context, child) {
        return SafeArea(
          child: child!,
        );
      },

      home: _isPasswordRecovery
          ? const ResetPasswordScreen() 
          : user != null
              ? const BottomNavScreen()
              : const LoginScreen(),
    );
  }
}