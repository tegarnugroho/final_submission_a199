import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movies/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late GetNowPlayingMovies getNowPlayingMovies;
  late NowPlayingMoviesBloc bloc;

  setUp(() {
    getNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMoviesBloc(getNowPlayingMovies);
  });

  final tMovieModel = testMovie;
  final tMovieList = [tMovieModel];

  group('Now Playing Movies', () {
    test('should change state to loading when usecase is called', () {
      expect(bloc.state, NowPlayingMoviesInitial());
    });

    blocTest('should emit [loading, success] when data is gotten successfully',
        build: () {
          when(getNowPlayingMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));

          return bloc;
        },
        act: (NowPlayingMoviesBloc bloc) =>
            bloc.add(OnFetchNowPlayingMovies()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              NowPlayingMoviesLoading(),
              NowPlayingMoviesSuccess(tMovieList)
            ],
        verify: (NowPlayingMoviesBloc bloc) {
          verify(getNowPlayingMovies.execute());
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getNowPlayingMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (NowPlayingMoviesBloc bloc) =>
            bloc.add(OnFetchNowPlayingMovies()),
        wait: const Duration(milliseconds: 500),
        expect: () =>
            [NowPlayingMoviesLoading(), NowPlayingMoviesError('')],
        verify: (NowPlayingMoviesBloc bloc) {
          verify(getNowPlayingMovies.execute());
        });
  });
}