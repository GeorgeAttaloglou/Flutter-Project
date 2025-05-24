import 'package:hive/hive.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  int prepTime;

  @HiveField(3)
  String difficulty;

  @HiveField(4)
  String imagePath;

  @HiveField(5)
  int rating;

  Recipe({
    required this.title,
    required this.description,
    required this.prepTime,
    required this.difficulty,
    required this.imagePath,
    required this.rating,
  });
}
