import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc bloc;
  late MockGetWatchlistMovies getWatchlist;

  setUp(() {
    getWatchlist = MockGetWatchlistMovies();
    bloc = WatchlistMoviesBloc(getWatchlist);
  });

  group('Watchlist Movies', () {
    test('should change state to initial', () {
      expect(bloc.state, WatchlistMoviesInitial());
    });

    blocTest('should emit [loading, success] when data is gotten succesful',
        build: () {
          when(getWatchlist.execute())
              .thenAnswer((_) async => Right([testWatchlistMovie]));

          return bloc;
        },
        act: (WatchlistMoviesBloc bloc) => bloc.add(OnFetchWatchlistMovies()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              WatchlistMoviesLoading(),
              WatchlistMoviesSuccess([testWatchlistMovie]),
            ],
        verify: (WatchlistMoviesBloc bloc) {
          verify(getWatchlist.execute());
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getWatchlist.execute())
              .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));

          return bloc;
        },
        act: (WatchlistMoviesBloc bloc) => bloc.add(OnFetchWatchlistMovies()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              WatchlistMoviesLoading(),
              WatchlistMoviesError("Can't get data"),
            ],
        verify: (WatchlistMoviesBloc bloc) {
          verify(getWatchlist.execute());
        });
  });
}
