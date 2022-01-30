import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/responsive/mobile_screen_layout.dart';
import 'package:social_app/responsive/responsive_layout_screen.dart';
import 'package:social_app/responsive/web_screen_layout.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/signup_screen.dart';
import 'package:social_app/screens/splash_screen.dart';
import 'package:social_app/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC_ntMgcvmlpxjFkL3xWcm86IewlNr6Frk",
            appId: "1:968691261079:web:c87880ee6f1120fcd193d2",
            messagingSenderId: "968691261079",
            projectId: "instagram-proj-4b2d9"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
