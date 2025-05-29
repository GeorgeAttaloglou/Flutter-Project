// recipe_details_screen.dart

// ------------------------------
// Dart & Flutter Imports
// ------------------------------
import 'dart:io';
import 'package:flutter/material.dart';

// ------------------------------
// Internal Imports
// ------------------------------
import '../models/recipe.dart';

// ------------------------------
// Recipe Detail Screen
// ------------------------------
class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.recipe.rating;
  }

  // ------------------------------
  // Rating Update Handler
  // ------------------------------
  void _updateRating(int newRating) {
    setState(() => _currentRating = newRating);
    widget.recipe.rating = newRating;
    widget.recipe.save();
  }

  // ------------------------------
  // UI
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imagePath.isNotEmpty)
              Image.file(
                File(recipe.imagePath),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              recipe.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Χρόνος Προετοιμασίας: ${recipe.prepTime} λεπτά'),
            Text('Δυσκολία: ${recipe.difficulty}'),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < _currentRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => _updateRating(index + 1),
                ),
              ),
            ),
            const Divider(height: 32),
            Text(
              recipe.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
