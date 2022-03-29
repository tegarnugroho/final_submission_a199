import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';


@GenerateMocks([GetPopularMovies])
void main() {
  late GetPopularMovies getPopularMovies;
  late PopularMoviesBloc bloc;

  setUp(() {
    getPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(getPopularMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  group('Popular Movies', () {
    test('should change state to initial', () {
      expect(bloc.state, PopularMoviesInitial());
    });

    blocTest('should emit [loading, success] when data is gotten successfully',
        build: () {
          when(getPopularMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));

          return bloc;
        },
        act: (PopularMoviesBloc bloc) => bloc.add(OnFetchPopularMovies()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              PopularMoviesLoading(),
              PopularMoviesSuccess(tMovieList),
            ],
        verify: (PopularMoviesBloc bloc) {
          verify(getPopularMovies.execute());
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getPopularMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (PopularMoviesBloc bloc) => bloc.add(OnFetchPopularMovies()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              PopularMoviesLoading(),
              PopularMoviesError(''),
            ],
        verify: (PopularMoviesBloc bloc) {
          verify(getPopularMovies.execute());
        });
  });
}
