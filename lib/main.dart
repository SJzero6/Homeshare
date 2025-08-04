
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homeshare/Screens/Animations/theme.dart';
import 'package:homeshare/Screens/splash_screen.dart';
import 'package:homeshare/services/gmail_auth_service.dart';
import 'package:homeshare/services/phone_auth_service.dart';
import 'package:homeshare/settings/app_routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GmailAuthProvider()),
        ChangeNotifierProvider(create: (_) => OEmailAuthProvider()), // ✅ Correct custom provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRoutes.generateRoute,
        home: const SplashScreen(),
      ),
    );
  }
}


