import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdb_clone/env_conf.dart';
import 'package:imdb_clone/search_item.dart';

final searchServiceProvider = Provider<SearchService>((ref) {
  final config = ref.watch(environmentConfigProvider);

  return SearchService(Dio(), config);
});

class SearchService {
  SearchService(this._dio, this._environmentConfig);

  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  Future<List<SearchResults>> searchFor(String searchTerm) async {
    final response = await _dio.get(
        "https://api.themoviedb.org/3/search/movie?api_key=${_environmentConfig.movieApiKey}&language=en-US&query=$searchTerm&page=1&include_adult=false");

    final results = List<Map<String, dynamic>>.from(response.data["results"]);

    List<SearchResults> searchItems = results
        .map((searchData) => SearchResults.fromJson(searchData))
        .toList(growable: false);

    return searchItems;
  }
}
