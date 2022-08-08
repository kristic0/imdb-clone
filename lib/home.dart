import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdb_clone/full_movie.dart';
import 'package:imdb_clone/movie.dart';
import 'package:imdb_clone/movie_service.dart';
import 'package:imdb_clone/single_movie_page.dart';

final moviesFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;

  final movieService = ref.read(movieServiceProvider);
  final movies = await movieService.getMovies();

  return movies;
});

class HomeWidget extends ConsumerWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: ref.watch(moviesFutureProvider).when(
            error: (e, s) {
              // if (e is MoviesException) {
              //   return _ErrorBody(message: '${e.message}');
              // }
              // return const _ErrorBody(
              //     message: "Oops, something unexpected happened");
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (movies) {
              return RefreshIndicator(
                onRefresh: () async {
                  return ref.refresh(moviesFutureProvider);
                },
                child: GridView.extent(
                  physics: const BouncingScrollPhysics(),
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                  children: movies
                      .map(
                        (movie) => Card(
                          color: Colors.transparent,
                          child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () async {
                                final movieService =
                                    ref.read(movieServiceProvider);
                                final fullMovie =
                                    await movieService.getSingleMovie(movie.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingleMoviePage(
                                            movie: fullMovie,
                                          )),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                      fit: BoxFit.cover,
                                      height: 200.0,
                                      width: 130.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
    );
  }
}
