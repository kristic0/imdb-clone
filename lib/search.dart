import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdb_clone/env_conf.dart';
import 'package:imdb_clone/movie_service.dart';
import 'package:imdb_clone/search_item.dart';
import 'package:imdb_clone/search_service.dart';
import 'package:imdb_clone/single_movie_page.dart';

class SearchWidget extends StatefulWidget {
  SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final searchController = TextEditingController();
  List<SearchResults> _searchItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _searchTerm;

    void _onSearchFired(String searchTerm) async {
      SearchService ss = new SearchService(Dio(), EnvironmentConfig());
      final res = await ss.searchFor(searchTerm);
      setState(() {
        isLoading = false;
        _searchItems = res;
      });
    }

    Widget _mainData() {
      return Center(
          child: isLoading
              ? Text("")
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _searchItems.length,
                  itemBuilder: (context, index) {
                    String imgUrl =
                        "https://image.tmdb.org/t/p/w500/${_searchItems[index].posterPath}";

                    if (_searchItems[index].posterPath == null) {
                      return ListTile(
                          title: Text(_searchItems[index].originalTitle ??
                              'something went wrong'));
                    }

                    return ListTile(
                      onTap: () async {
                        final movieService =
                            MovieService(Dio(), EnvironmentConfig());
                        final fullMovie = await movieService
                            .getSingleMovie(_searchItems[index].id ?? 0);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleMoviePage(
                                    movie: fullMovie,
                                  )),
                        );
                      },
                      minVerticalPadding: 25,
                      leading: Image.network(imgUrl),
                      title: Text(_searchItems[index].originalTitle ??
                          'something went wrong'),
                    );
                  },
                ));
    }

    Widget _searchBar() {
      return TextField(
        controller: searchController,
        onSubmitted: (value) async {
          _onSearchFired(value);
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: "Movie title",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.yellow))),
      );
    }

    var padding = MediaQuery.of(context).padding;
    double height = MediaQuery.of(context).size.height;
    double height1 = height - padding.top - padding.bottom;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(5, 50, 5, 0), child: _searchBar()),
          Expanded(flex: 1, child: _mainData()),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
