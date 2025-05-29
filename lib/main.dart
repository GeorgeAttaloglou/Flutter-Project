// main.dart

// ------------------------------
// Flutter & Package Imports
// ------------------------------
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ------------------------------
// Internal Imports
// ------------------------------
import 'models/recipe.dart';
import 'screens/home_screen.dart';

// ------------------------------
// Theme Notifier (for runtime theme switching)
// ------------------------------
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

// ------------------------------
// App Entry Point
// ------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialization & adapters
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  await Hive.openBox<Recipe>('recipes');

  // Load saved theme setting
  final settingsBox = await Hive.openBox('settings');
  final storedTheme = settingsBox.get('themeMode', defaultValue: 'system');
  themeNotifier.value = _getThemeModeFromString(storedTheme);

  runApp(const MyApp());
}

// ------------------------------
// Theme Parsing Utility
// ------------------------------
ThemeMode _getThemeModeFromString(String value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

// ------------------------------
// Main App Widget
// ------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Recipe App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
