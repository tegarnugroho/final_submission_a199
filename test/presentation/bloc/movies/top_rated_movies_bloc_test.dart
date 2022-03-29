import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_bloc_test.mocks.dart';


@GenerateMocks([GetTopRatedMovies])
void main() {
  late GetTopRatedMovies getTopRatedMovies;
  late TopRatedMoviesBloc bloc;

  setUp(() {
    getTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(getTopRatedMovies);
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

  group('Top Rated Movies', () {
    test('should change state to initial', () {
      expect(bloc.state, TopRatedMoviesInitial());
    });

    blocTest('should emit [loading, success] when data is gotten successfully',
        build: () {
          when(getTopRatedMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));

          return bloc;
        },
        act: (TopRatedMoviesBloc bloc) => bloc.add(OnFetchTopRatedMovies()),
        wait: const Duration(milliseconds: 500),
        expect: () =>
            [TopRatedMoviesLoading(), TopRatedMoviesSuccess(tMovieList)],
        verify: (TopRatedMoviesBloc bloc) {
          verify(getTopRatedMovies.execute());
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getTopRatedMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (TopRatedMoviesBloc bloc) => bloc.add(OnFetchTopRatedMovies()),
        wait: const Duration(milliseconds: 500),
        expect: () => [TopRatedMoviesLoading(), TopRatedMoviesError('')],
        verify: (TopRatedMoviesBloc bloc) {
          verify(getTopRatedMovies.execute());
        });
  });
}
