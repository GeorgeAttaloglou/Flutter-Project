// home_screen.dart

// ------------------------------
// Flutter & Package Imports
// ------------------------------
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ------------------------------
// Internal Imports
// ------------------------------
import '../main.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import 'recipe_details_screen.dart';

// ------------------------------
// Home Screen
// ------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Box<Recipe> _recipeBox;
  String _sortBy = 'default';

  @override
  void initState() {
    super.initState();
    _recipeBox = Hive.box<Recipe>('recipes');
  }

  // ------------------------------
  // Handlers
  // ------------------------------
  void _deleteRecipe(dynamic key) => _recipeBox.delete(key);

  void _openRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
    );
  }

  void _openAddRecipeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
    );
  }

  void _changeTheme(ThemeMode mode) async {
    themeNotifier.value = mode;
    final settingsBox = await Hive.openBox('settings');
    settingsBox.put('themeMode', _getStringFromThemeMode(mode));
  }

  // ------------------------------
  // Sorting Utility
  // ------------------------------
  List<Recipe> _sortRecipes(List<Recipe> recipes) {
    switch (_sortBy) {
      case 'rating':
        recipes.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'prepTime':
        recipes.sort((a, b) => a.prepTime.compareTo(b.prepTime));
        break;
      case 'difficulty':
        const order = ['Easy', 'Medium', 'Hard'];
        recipes.sort(
          (a, b) => order
              .indexOf(a.difficulty)
              .compareTo(order.indexOf(b.difficulty)),
        );
        break;
    }
    return recipes;
  }

  // ------------------------------
  // UI
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Συνταγές'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder:
                (_) => const [
                  PopupMenuItem(
                    value: 'default',
                    child: Text('Χωρίς ταξινόμηση'),
                  ),
                  PopupMenuItem(value: 'rating', child: Text('Βαθμολογία')),
                  PopupMenuItem(value: 'prepTime', child: Text('Χρόνος')),
                  PopupMenuItem(value: 'difficulty', child: Text('Δυσκολία')),
                ],
          ),
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.color_lens),
            onSelected: _changeTheme,
            itemBuilder:
                (_) => [
                  for (var mode in ThemeMode.values)
                    PopupMenuItem(
                      value: mode,
                      child: Text(
                        mode == ThemeMode.light
                            ? '☀️ Φωτεινό'
                            : mode == ThemeMode.dark
                            ? '🌙 Σκοτεινό'
                            : '⚙️ Σύστημα',
                      ),
                    ),
                ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddRecipeScreen,
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: _recipeBox.listenable(),
        builder: (context, Box<Recipe> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Δεν υπάρχουν συνταγές'));
          }
          final recipes = _sortRecipes(box.values.toList());
          final keys = box.keys.toList();
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final key = keys[index];
              return Dismissible(
                key: ValueKey(key),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _deleteRecipe(key),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: RecipeCard(
                  recipe: recipe,
                  onTap: () => _openRecipeDetail(recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ------------------------------
// Theme String Utility
// ------------------------------
String _getStringFromThemeMode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'system';
  }
}
