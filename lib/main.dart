import 'dart:io';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop initialization
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🎨 GLOBAL THEME
      theme: ThemeData(
        useMaterial3: true, // Naye features ke liye zaroori hai
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: Colors.grey.shade100,

        // 🟣 AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),

        // 🔲 Card Theme (FIXED: CardThemeData use kiya hai)
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // 🧾 Input Field Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),

        // 🔘 Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // ☑️ Checkbox Theme (FIXED: WidgetStateProperty use kiya hai)
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(Colors.indigo),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
