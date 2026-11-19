import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'bienvenida_auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const pastelPurple = Color(0xFF9B87F5);
    const pastelBlue = Color(0xFF7EC8E3);
    const pastelMint = Color(0xFF8CE0C3);
    const pastelBg = Color(0xFFF6F5FC);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineStar',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pastelBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: pastelPurple,
          primary: pastelPurple,
          secondary: pastelBlue,
          tertiary: pastelMint,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFEDE9FE), // Lavanda pastel suave
          foregroundColor: Color(0xFF3B3355),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD8D2F8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD8D2F8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: pastelPurple, width: 1.8),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: pastelPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const WelcomeAuthScreen(),
    );
  }
}