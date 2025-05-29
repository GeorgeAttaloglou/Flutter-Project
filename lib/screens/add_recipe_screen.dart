// add_recipe_screen.dart

// ------------------------------
// Dart & Flutter Imports
// ------------------------------
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

// ------------------------------
// Internal Imports
// ------------------------------
import '../models/recipe.dart';

// ------------------------------
// Add Recipe Screen
// ------------------------------
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // ------------------------------
  // Form State & Controllers
  // ------------------------------
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _prepTimeCtrl = TextEditingController();

  String _difficulty = 'Easy';
  int _rating = 0;
  File? _imageFile;

  // ------------------------------
  // Image Picker
  // ------------------------------
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  // ------------------------------
  // Save Handler
  // ------------------------------
  void _saveRecipe() {
    if (!_formKey.currentState!.validate() || _imageFile == null) return;

    final recipe = Recipe(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      prepTime: int.tryParse(_prepTimeCtrl.text.trim()) ?? 0,
      difficulty: _difficulty,
      imagePath: _imageFile!.path,
      rating: _rating,
    );

    Hive.box<Recipe>('recipes').add(recipe);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _prepTimeCtrl.dispose();
    super.dispose();
  }

  // ------------------------------
  // UI
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Προσθήκη Συνταγής')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Τίτλος'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Υποχρεωτικό' : null,
                ),
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: 'Περιγραφή'),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: _prepTimeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Χρόνος Προετοιμασίας (min)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  value: _difficulty,
                  decoration: const InputDecoration(labelText: 'Δυσκολία'),
                  items: const ["Easy", "Medium", "Hard"]
                      .map(
                        (d) => DropdownMenuItem(value: d, child: Text(d)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _difficulty = val!),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () => setState(() => _rating = index + 1),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Επιλογή Εικόνας'),
                ),
                if (_imageFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.file(_imageFile!, height: 120),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _saveRecipe,
                  child: const Text('Αποθήκευση'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}