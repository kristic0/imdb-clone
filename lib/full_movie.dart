import 'package:imdb_clone/cast.dart';
import 'package:imdb_clone/similar_movies.dart';

import 'movie.dart';
import 'movie_images.dart';

class Genre {
  int id;
  String name;

  Genre({required this.id, required this.name}) {}

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class FullMovie extends Movie {
  String overview;
  String status;
  String tagline;
  double voteAverage;
  int voteCount;
  int runtime;
  List<Genre> genres;
  List<dynamic> cast;
  List<MovieImages> backdrops;
  SimilarMovies similarMovies;

  FullMovie(
      {required int id,
      required String title,
      required String posterPath,
      required String releaseDate,
      required this.status,
      required this.runtime,
      required this.genres,
      required this.overview,
      required this.tagline,
      required this.voteAverage,
      required this.voteCount,
      required this.cast,
      required this.backdrops,
      required this.similarMovies})
      : super(
            id: id,
            title: title,
            posterPath: posterPath,
            releaseDate: releaseDate) {}

  factory FullMovie.fromMaps(
      Map<String, dynamic> details,
      Map<String, dynamic> images,
      Map<String, dynamic> credits,
      Map<String, dynamic> similarMoviesRes) {
    return FullMovie(
        id: details['id'] ?? 0,
        title: details['title'] ?? '',
        posterPath: details['poster_path'] ?? '',
        releaseDate: details['release_date'] ?? '',
        overview: details['overview'] ?? '',
        status: details['status'] ?? '',
        tagline: details['tagline'] ?? '',
        voteAverage: details['vote_average'] ?? '',
        voteCount: details['vote_count'] ?? '',
        runtime: details['runtime'] ?? '',
        genres:
            List<Genre>.from(details["genres"].map((x) => Genre.fromJson(x))),
        cast: List<Cast>.from(credits["cast"].map((x) => Cast.fromJson(x))),
        backdrops: List<MovieImages>.from(
            images['posters'].map((x) => MovieImages.fromJson(x))),
        similarMovies: SimilarMovies.fromJson(similarMoviesRes));
  }
}
