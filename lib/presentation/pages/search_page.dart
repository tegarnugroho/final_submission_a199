import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movies/movies_search/movies_search_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context
                    .read<MoviesSearchBloc>()
                    .add(OnMoviesQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<MoviesSearchBloc, MoviesSearchState>(
              builder: (context, data) {
                if (data is MoviesSearchLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data is MoviesSearchSuccess) {
                  final result = data.movies;
                  return result.isEmpty
                      ? const Center(
                          child: Text('Nothing found!'),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = data.movies[index];
                              return MovieCard(movie);
                            },
                            itemCount: result.length,
                          ),
                        );
                } else if (data is MoviesSearchError) {
                  return Center(
                    key: Key('error_message'),
                    child: Text(data.message),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
