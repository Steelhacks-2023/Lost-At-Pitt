import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lost_found_steelhacks/authentication/auth.dart';
import 'package:lost_found_steelhacks/authentication/wrapper.dart';
import 'package:lost_found_steelhacks/pages/login_page.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:lost_found_steelhacks/authentication/user.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            'loginPage': (context) => LoginPage(),
            'mapPage': (context) => MapPage(),
            '/': (context) => Wrapper()
          },
          initialRoute: '/',
        ));
  }
}
