import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdb_clone/env_conf.dart';
import 'package:imdb_clone/full_movie.dart';
import 'package:imdb_clone/movie.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final config = ref.watch(environmentConfigProvider);

  return MovieService(Dio(), config);
});

class MovieService {
  MovieService(this._dio, this._environmentConfig);

  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  Future<List<Movie>> getMovies() async {
    final response = await _dio.get(
      "https://api.themoviedb.org/3/movie/popular?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=1",
    );

    final results = List<Map<String, dynamic>>.from(response.data['results']);

    List<Movie> movies = results
        .map((movieData) => Movie.fromMap(movieData))
        .toList(growable: false);

    return movies;
  }

  Future<FullMovie> getSingleMovie(int movieId) async {
    final movieImagePaths = await _dio.get(
        "https://api.themoviedb.org/3/movie/$movieId/images?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=1");

    final movieCredits = await _dio.get(
        "https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=1");

    final movieResponse = await _dio.get(
      "https://api.themoviedb.org/3/movie/$movieId?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=1",
    );

    final similarMovies = await _dio.get(
        "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=1");

    final movieDetailsRes = Map<String, dynamic>.from(movieResponse.data);
    final movieImagePathsRes = Map<String, dynamic>.from(movieImagePaths.data);
    final movieCreditsRes = Map<String, dynamic>.from(movieCredits.data);
    final similarMoviesRes = Map<String, dynamic>.from(similarMovies.data);

    FullMovie movie = FullMovie.fromMaps(
        movieDetailsRes, movieImagePathsRes, movieCreditsRes, similarMoviesRes);

    return movie;
  }
}
