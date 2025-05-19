import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'movie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required before async init
  // Εξασφαλίζει ότι το Flutter framework είναι έτοιμο
  // πριν τρέξουμε async εντολές όπως Hive.initFlutter()
  // ή getApplicationDocumentsDirectory()
  // (που βασίζονται σε σύνδεση με το σύστημα του Android/iOS)

  await Hive.initFlutter();
  // Αρχικοποιεί το Hive ώστε να αποθηκεύει δεδομένα
  // στον σωστό φάκελο εγγράφων της εφαρμογής (π.χ. σε Android/iOS)
  // Χωρίς αυτό, το Hive δεν μπορεί να διαβάσει ή να γράψει αρχεία

  // Register the generated adapter **before** opening any boxes --------- TI EINAI ADAPTER ?? SHOW EXAMPLE
  Hive.registerAdapter(MovieAdapter());

  // Open (or create) a typed box that stores Food objects
  await Hive.openBox<Movie>('movies');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Hive Movie Demo', home: MovieHomePage());
  }
}

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  final _movieTitleCtrl = TextEditingController();
  final _releaseYearCtrl = TextEditingController();
  final _actor1Ctrl = TextEditingController();
  final _actor2Ctrl = TextEditingController();
  final _actor3Ctrl = TextEditingController();

  //reference to the already opened box
  final Box<Movie> _box = Hive.box<Movie>('movies');

  void _addMovie() {
    final name = _movieTitleCtrl.text.trim();
    final releaseYear = int.tryParse(_releaseYearCtrl.text) ?? 0;
    final actor1 = _actor1Ctrl.text.trim();
    final actor2 = _actor2Ctrl.text.trim();
    final actor3 = _actor3Ctrl.text.trim();
    if (name.isEmpty) return;

    //add in the box
    _box.add(
      Movie(
        movieTitle: name,
        releaseYear: releaseYear,
        actor1: actor1,
        actor2: actor2,
        actor3: actor3,
      ),
    );
    //το add προσθετει στο τελος του box. Διαφορετικα θα μπορουσα να χρησιμοποιησω put Και να δωσω key -- αν υπηρχε ηδη το αντικαθιστα

    _movieTitleCtrl.clear();
    _releaseYearCtrl.clear();
    _actor1Ctrl.clear();
    _actor2Ctrl.clear();
    _actor3Ctrl.clear();
  }

  //delete from the box
  void _deleteMovie(int index) => _box.deleteAt(index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive – Movie List')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _movieTitleCtrl,
              decoration: const InputDecoration(labelText: 'Movie name'),
            ),
            TextField(
              controller: _releaseYearCtrl,
              decoration: const InputDecoration(labelText: 'Release Year'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _actor1Ctrl,
              decoration: const InputDecoration(labelText: 'Actor 1'),
            ),
            TextField(
              controller: _actor2Ctrl,
              decoration: const InputDecoration(labelText: 'Actor 2'),
            ),
            TextField(
              controller: _actor3Ctrl,
              decoration: const InputDecoration(labelText: 'Actor 3'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addMovie,
              child: const Text('Add movie'),
            ),
            const Divider(),
            Expanded(
              // Listen to the box; UI rebuilds automatically on every change
              //ΠΡΟΣΟΧΗ: Ενα widget το οποιο βλεπει κατευθειαν το box.
              child: ValueListenableBuilder(
                // Το Hive.box().listenable() επιστρέφει ένα ValueListenable<Box> το οποιο ειδοποιει καθε φορα που αλλαζει κατι στο box
                valueListenable: _box.listenable(),
                builder: (context, Box<Movie> box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('No foods saved'));
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final movie =
                          box.getAt(index)!; // never null after length check
                      return ListTile(
                        title: Text(movie.movieTitle),
                        subtitle: Text(
                          '${movie.releaseYear} - ${movie.actor1}, ${movie.actor2}, ${movie.actor3}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteMovie(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _movieTitleCtrl.dispose();
    _releaseYearCtrl.dispose();
    super.dispose();
  }
}
