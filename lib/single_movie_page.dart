import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdb_clone/cast.dart';
import 'package:imdb_clone/full_movie.dart';
import 'package:imdb_clone/movie_service.dart';

import 'movie.dart';

final moviesFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;

  final movieService = ref.read(movieServiceProvider);
  final movies = await movieService.getMovies();

  return movies;
});

class SingleMoviePage extends ConsumerWidget {
  const SingleMoviePage({Key? key, required this.movie}) : super(key: key);

  final FullMovie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var imageUrl = 'https://image.tmdb.org/t/p/w500/${movie.posterPath}';

    String castString = "";
    for (Cast i in movie.cast) {
      castString += i.name;
      castString += ", ";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: 500,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.cover)),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 30,
              child: ListView.builder(
                  itemCount: movie.genres.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      margin:
                          EdgeInsets.only(left: index == 0 ? 30 : 0, right: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(movie.genres[index].name,
                              style: Theme.of(context).textTheme.bodyText2!),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 30, right: 30, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.overview,
                      style: Theme.of(context).textTheme.bodyText2!),
                  const SizedBox(
                    height: 12,
                  ),
                  Text('Release date',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(movie.releaseDate,
                      style: Theme.of(context).textTheme.bodyText2!),
                  const SizedBox(
                    height: 12,
                  ),
                  Text('Runtime',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(movie.runtime.toString() + ' minutes',
                      style: Theme.of(context).textTheme.bodyText2!),
                  const SizedBox(
                    height: 12,
                  ),
                  Text('Stars',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(castString),
                  const SizedBox(
                    height: 12,
                  ),
                  Text('Similar movies',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 650,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: [
                  for (var i = 0; i < 6; i++)
                    InkWell(
                      onTap: () async {
                        final movieService = ref.read(movieServiceProvider);
                        final fullMovie = await movieService
                            .getSingleMovie(movie.similarMovies.results[i].id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleMoviePage(
                                      movie: fullMovie,
                                    )));
                      },
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.similarMovies.results[i].posterPath}',
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(4),
                      ),
                    )
                ],
              ),
            )
          ])),
        ],
      ),
    );
  }
}
