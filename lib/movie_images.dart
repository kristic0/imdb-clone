// To parse this JSON data, do
//
//     final movieImages = movieImagesFromJson(jsonString);

import 'dart:convert';

MovieImages movieImagesFromJson(String str) =>
    MovieImages.fromJson(json.decode(str));

String movieImagesToJson(MovieImages data) => json.encode(data.toJson());

class MovieImages {
  MovieImages({
    required this.id,
    required this.backdrops,
    required this.posters,
  });

  int id;
  List<Backdrop> backdrops;
  List<Backdrop> posters;

  factory MovieImages.fromJson(Map<String, dynamic> json) => MovieImages(
        id: json["id"],
        backdrops: List<Backdrop>.from(
            json["backdrops"].map((x) => Backdrop.fromJson(x))),
        posters: List<Backdrop>.from(
            json["posters"].map((x) => Backdrop.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "backdrops": List<dynamic>.from(backdrops.map((x) => x.toJson())),
        "posters": List<dynamic>.from(posters.map((x) => x.toJson())),
      };
}

class Backdrop {
  Backdrop({
    required this.aspectRatio,
    required this.filePath,
    required this.height,
    required this.iso6391,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
  });

  double aspectRatio;
  String filePath;
  int height;
  String iso6391;
  int voteAverage;
  int voteCount;
  int width;

  factory Backdrop.fromJson(Map<String, dynamic> json) => Backdrop(
        aspectRatio: json["aspect_ratio"].toDouble(),
        filePath: json["file_path"],
        height: json["height"],
        iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "aspect_ratio": aspectRatio,
        "file_path": filePath,
        "height": height,
        "iso_639_1": iso6391 == null ? null : iso6391,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "width": width,
      };
}
