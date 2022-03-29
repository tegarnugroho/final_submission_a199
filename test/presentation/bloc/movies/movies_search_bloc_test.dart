import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movies/movies_search/movies_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movies_search_bloc_test.mocks.dart';


@GenerateMocks([SearchMovies])
void main() {
  late MoviesSearchBloc bloc;
  late MockSearchMovies searchMovies;

  setUp(() {
    searchMovies = MockSearchMovies();
    bloc = MoviesSearchBloc(searchMovies);
  });



  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  group('Search Movies', () {
    test('should change state to initial', () {
      expect(bloc.state, MoviesSearchInitial());
    });

    blocTest(
      'should change state to initial when query is empty',
      build: () => bloc,
      act: (MoviesSearchBloc bloc) => bloc.add(OnMoviesQueryChanged('')),
      wait: const Duration(milliseconds: 500),
      expect: () => [MoviesSearchInitial()],
    );

    blocTest('should emit [loading, success] when data is gotten succesful',
        build: () {
          when(searchMovies.execute(tQuery))
              .thenAnswer((_) async => Right(tMovieList));

          return bloc;
        },
        act: (MoviesSearchBloc bloc) => bloc.add(OnMoviesQueryChanged(tQuery)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              MoviesSearchLoading(),
              MoviesSearchSuccess(tMovieList),
            ],
        verify: (MoviesSearchBloc bloc) {
          verify(searchMovies.execute(tQuery));
        });

    blocTest('should emit [loading, error] when data is unsuccesful',
        build: () {
          when(searchMovies.execute(tQuery))
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (MoviesSearchBloc bloc) => bloc.add(OnMoviesQueryChanged(tQuery)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              MoviesSearchLoading(),
              MoviesSearchError(''),
            ],
        verify: (MoviesSearchBloc bloc) {
          verify(searchMovies.execute(tQuery));
        });
  });
}
