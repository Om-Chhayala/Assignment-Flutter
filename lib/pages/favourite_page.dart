import 'package:flutter/material.dart';
import 'package:trying_movie_pp/api/api.dart';
import 'package:trying_movie_pp/models/movie_model.dart';
import 'package:trying_movie_pp/pages/display_movie_page.dart'; // Import your MovieModel

class FavouritesPage extends StatelessWidget {
  final List<MovieModel> favoriteMovies; // List of favorite movies

  const FavouritesPage({
    Key? key,
    required this.favoriteMovies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
        backgroundColor: Colors.blue[300],
      ),
      body: favoriteMovies.isNotEmpty
          ? ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text('Rating: ${movie.voteAverage}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Call the function to remove the movie from the database
                      Api().removeFromFavorites(movie.id);
                      
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayMoviePage(movie: movie),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text(
                "No favorite movies yet!",
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
