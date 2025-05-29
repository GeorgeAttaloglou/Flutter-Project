// recipe_card.dart

// ------------------------------
// Dart & Flutter Imports
// ------------------------------
import 'package:flutter/material.dart';
import 'dart:io';

// ------------------------------
// Internal Imports
// ------------------------------
import '../models/recipe.dart';

// ------------------------------
// Recipe Card Widget
// ------------------------------
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // ------------------------------
            // Εικόνα
            // ------------------------------
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(recipe.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // ------------------------------
            // Πληροφορίες
            // ------------------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "Χρόνος προετιμασίας: ${recipe.prepTime.toString()} λεπτά",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    Text("Δυσκολία: ${recipe.difficulty}"),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < recipe.rating
                              ? Icons.star
                              : Icons.star_border,
                          color:
                              index < recipe.rating
                                  ? Colors.amber
                                  : Colors.grey,
                          size: 18,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
