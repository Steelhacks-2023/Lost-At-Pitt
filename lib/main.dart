import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lost_found_steelhacks/services/auth_service.dart';
import 'package:lost_found_steelhacks/data/app_user.dart';
import 'package:lost_found_steelhacks/routing/wrapper.dart';
import 'package:lost_found_steelhacks/services/firestore_service.dart';
import 'package:lost_found_steelhacks/data/item.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:lost_found_steelhacks/themes/theme_manager.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

const String errorMessage =
    "Must declare MODE as either production or development. Supply --dart-define=\"MODE=mode\" via command line or launch arguments";

void main() async {
  const mode =
      bool.hasEnvironment("MODE") ? String.fromEnvironment("MODE") : null;
  FirebaseOptions options = mode == "production" || mode == null
      ? ProductionFirebaseOptions.currentPlatform
      : DevelopmentFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(options: options);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

ThemeManager themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiProvider(
        providers: [
          StreamProvider<AppUser?>.value(
              value: AuthService.appUserStream,
              initialData: AppUser.defaultUser,
              catchError: (context, error) => null),
          StreamProvider<List<Item>>.value(
              value: FirestoreService.getFoundItemsStream(),
              initialData: const [],
              catchError: (context, error) => []),
        ],
        child: MaterialApp(
            title: 'Lost@Pitt | For Students By Students',
            debugShowCheckedModeBanner: false,
            home: const Wrapper(),
            theme: AppTheme.getTheme(),
            themeMode: themeManager.themeMode));
  }
}
