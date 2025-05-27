import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/recipe.dart';
import 'screens/home_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  await Hive.openBox<Recipe>('recipes');
  final settingsBox = await Hive.openBox('settings');

  final storedTheme = settingsBox.get('themeMode', defaultValue: 'system');
  themeNotifier.value = _getThemeModeFromString(storedTheme);

  runApp(const MyApp());
}

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
