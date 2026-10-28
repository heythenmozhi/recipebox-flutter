import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RecipeBoxApp());
}

class RecipeBoxApp extends StatelessWidget {
  const RecipeBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFEF6C00);

    return MaterialApp(
      title: 'RecipeBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: orange),
        scaffoldBackgroundColor: const Color(0xFFFFFBF6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFBF6),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFFE0B2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: orange,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}