import 'package:ditonton/presentation/bloc/movies/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PopularMoviesBloc>().add(OnFetchPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
          builder: (context, data) {
            if (data is PopularMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data is PopularMoviesSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.movies[index];
                  return MovieCard(movie);
                },
                itemCount: data.movies.length,
              );
            } else if (data is PopularMoviesError) {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
