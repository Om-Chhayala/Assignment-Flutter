import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trying_movie_pp/api/database_helper.dart';
import 'package:trying_movie_pp/constants.dart';
import 'package:trying_movie_pp/models/movie_model.dart';

class Api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/movie/popular?api_key=${Constants.apiKey}';
  static const _topRated =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const _releaseDateUrl =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';

  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final response = await http.get(Uri.parse(_trendingUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<MovieModel> movies = List<MovieModel>.from(
            data['results'].map((movie) => MovieModel.fromJson(movie)));
        return movies;
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      final response = await http.get(Uri.parse(_topRated));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<MovieModel> movies = List<MovieModel>.from(
            data['results'].map((movie) => MovieModel.fromJson(movie)));
        return movies;
      } else {
        throw Exception('Failed to load top rated movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<MovieModel>> getMoviesByReleaseDate() async {
    try {
      final response = await http.get(Uri.parse(_releaseDateUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<MovieModel> movies = List<MovieModel>.from(
            data['results'].map((movie) => MovieModel.fromJson(movie)));
        return movies;
      } else {
        throw Exception('Failed to load movies by release date');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addToFavorites(MovieModel movie) async {
    try {
      final dbHelper = MovieDatabaseHelper.instance;
      final id = await dbHelper.insertMovie(movie);
      print('Added movie to favorites with id: $id');
    } catch (e) {
      throw Exception('Error adding movie to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(int id) async {
    try {
      final dbHelper = MovieDatabaseHelper.instance;
      final rowsDeleted = await dbHelper.deleteMovie(id);
      print('Removed $rowsDeleted movie(s) from favorites');
    } catch (e) {
      throw Exception('Error removing movie from favorites: $e');
    }
  }

  Future<List<MovieModel>> getMoviesFromDatabase() async {
    try {
      // Fetch movies from the database using MovieDatabaseHelper
      List<MovieModel> movies = await MovieDatabaseHelper.instance.getMovies();
      return movies;
    } catch (e) {
      throw Exception('Error fetching movies from database: $e');
    }
  }
}
