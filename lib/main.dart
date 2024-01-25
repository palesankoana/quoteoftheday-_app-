import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String _currentQuote = "Another day, Another dollar!";
  List<String> quotes = [
    "The early bird gets the worm!",
    "The first step is always the hardest!",
    "Its not over until its over!",
    "Always look on the bright side of life!",
  ];
  ///NEW CODE
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes"),
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                _shareQuote(_currentQuote);
              }
          ),
          IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen(favorites: favorites)))
          ),

        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentQuote,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () => _toggleFavorite(_currentQuote),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _getNewQuote,
        tooltip: 'New Quote',
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _getNewQuote() {
    setState(() {
      _currentQuote = quotes[(quotes.indexOf(_currentQuote) + 1) % quotes.length];
    });
  }

  void _shareQuote(String quote) {
    Share.share(quote);
  }

  void _toggleFavorite(String quote) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favorites.contains(quote)) {
        favorites.remove(quote);
      } else {
        favorites.add(quote);
      }
      prefs.setStringList("favorites", favorites);
    });
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList("favorites") ?? [];
    });
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.favorites});

  final List<String> favorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(favorites[index]),
            ),
          );
        },
      ),
    );
  }
}