import 'package:flutter/material.dart';
import 'package:trying_movie_pp/api/api.dart';
import 'package:trying_movie_pp/api/database_helper.dart';
import 'package:trying_movie_pp/models/movie_model.dart';
import 'package:trying_movie_pp/pages/display_movie_page.dart';
import 'package:trying_movie_pp/pages/favourite_page.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<MovieModel>> futureMovies;
  String sortBy = 'Top Rated'; // Default sorting option
  List<String> sortOptions = ['Top Rated', 'Popular', 'Release Date'];
  TextEditingController searchController = TextEditingController();
  late List<MovieModel> allMovies = []; // Local list of all movies
  List<MovieModel> filteredMovies = []; // List of movies after search
  List<MovieModel> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _initializeMovies();
  }

  Future<void> _initializeMovies() async {
    futureMovies = Api().getTopRatedMovies();
    allMovies.addAll(await Api().getTopRatedMovies());
    allMovies.addAll(await Api().getTrendingMovies());
    allMovies.addAll(await Api().getMoviesByReleaseDate());
  }

  void _sortMovies(String value) {
    setState(() {
      sortBy = value;
      switch (sortBy) {
        case 'Top Rated':
          futureMovies = Api().getTopRatedMovies();
          break;
        case 'Popular':
          futureMovies = Api().getTrendingMovies();
          break;
        case 'Release Date':
          futureMovies = Api().getMoviesByReleaseDate();
          break;
        default:
          futureMovies = Api().getTopRatedMovies();
          break;
      }
    });
  }

  void _searchMovies(String query) {
    setState(() {
      filteredMovies = allMovies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void fetchData() async {
    favoriteMovies = await Api().getMoviesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Movie App"),
            backgroundColor: Colors.blue[300],
          ),
          backgroundColor: Colors.blue[50],
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for movies...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                    onChanged: (value) {
                      _searchMovies(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: sortBy,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _sortMovies(newValue);
                      }
                    },
                    items: sortOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Top Movies:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextButton(
                          onPressed: () {
                            // Add your navigation logic here
                            fetchData();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavouritesPage(
                                          favoriteMovies: favoriteMovies,
                                        )));
                          },
                          child: Text(
                            "Go to Favourites",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent[
                                  500], // Set the color of the button text
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<MovieModel>>(
                    future: futureMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print(Text('Error: ${snapshot.error}'));
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        List<MovieModel> moviesToShow = [];

                        if (searchController.text.isNotEmpty) {
                          moviesToShow = filteredMovies;
                        } else {
                          moviesToShow = snapshot.data!;
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(
                              (moviesToShow.length / 2).ceil(),
                              (index) {
                                int startIndex = index * 2;
                                int endIndex =
                                    startIndex + 2 < moviesToShow.length
                                        ? startIndex + 2
                                        : moviesToShow.length;
                                List<MovieModel> movies =
                                    moviesToShow.sublist(startIndex, endIndex);

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: movies.map((movie) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DisplayMoviePage(
                                                            movie: movie)));
                                          },
                                          child: Card(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                  'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                                  width: double.infinity,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        movie.title,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Rating: ${movie.voteAverage}',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
