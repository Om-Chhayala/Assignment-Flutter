import 'package:flutter/material.dart';
import 'package:trying_movie_pp/api/api.dart';
import 'package:trying_movie_pp/models/movie_model.dart';

class DisplayMoviePage extends StatelessWidget {
  final MovieModel movie;

  const DisplayMoviePage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.blue[300],
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display movie poster with increased size
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Add logic to add movie to favorites
                    Api().addToFavorites(movie);
                  },
                  child: Text(
                    "Add to favourite",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Adjust the color if necessary
                    ),
                  ),
                  style: ButtonStyle(
                    // No need to change here
                    foregroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Title: ${movie.title}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Overview:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Change the color as desired
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${movie.overview}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Release Date: ${movie.releaseDate}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Rating: ${movie.voteAverage}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Popularity: ${movie.popularity}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 28),
              // Add more properties as needed
            ],
          ),
        ),
      ),
    );
  }
}
