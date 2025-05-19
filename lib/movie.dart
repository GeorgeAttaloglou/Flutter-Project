import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  String movieTitle;

  @HiveField(1)
  int releaseYear;

  @HiveField(2)
  String actor1;

  @HiveField(3)
  String actor2;

  @HiveField(4)
  String actor3;

  Movie({
    required this.movieTitle,
    required this.releaseYear,
    required this.actor1,
    required this.actor2,
    required this.actor3,
  });
}
