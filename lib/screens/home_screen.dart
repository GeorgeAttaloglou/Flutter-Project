import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import 'recipe_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Box<Recipe> _recipeBox;

  @override
  void initState() {
    super.initState();
    _recipeBox = Hive.box<Recipe>('recipes');
  }

  void _deleteRecipe(int index) => _recipeBox.deleteAt(index);

  void _openRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  void _openAddRecipeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Συνταγές')),
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

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final recipe = box.getAt(index)!;
              return Dismissible(
                key: ValueKey(recipe.key),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _deleteRecipe(index),
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
