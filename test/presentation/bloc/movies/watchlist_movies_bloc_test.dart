import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  SaveWatchlist,
  RemoveWatchlist,
  GetWatchListStatus,
])
void main() {
  late WatchlistMoviesBloc bloc;
  late MockGetWatchlistMovies getWatchlist;
  late SaveWatchlist saveWatchlist;
  late RemoveWatchlist removeWatchlist;
  late GetWatchListStatus getWatchListStatus;

  setUp(() {
    getWatchlist = MockGetWatchlistMovies();
    getWatchListStatus = MockGetWatchListStatus();
    saveWatchlist = MockSaveWatchlist();
    removeWatchlist = MockRemoveWatchlist();
    bloc = WatchlistMoviesBloc(
      getWatchListStatus: getWatchListStatus,
      getWatchlist: getWatchlist,
      removeFromWatchlist: removeWatchlist,
      saveWatchlist: saveWatchlist,
    );
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

  group(
    'Watchlist Add & Remove',
    () {
      blocTest(
        'should update watchlist status when adding watchlist succeeded',
        build: () {
          when(saveWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async => const Right('Added to Watchlist'));
          return bloc;
        },
        act: (WatchlistMoviesBloc bloc) =>
            bloc.add(AddToWatchlistMovies(testMovieDetail)),
        expect: () => [
          WatchlistSuccess('Added to Watchlist'),
        ],
        verify: (bloc) {
          verify(saveWatchlist.execute(testMovieDetail));
          return AddToWatchlistMovies(testMovieDetail).props;
        },
      );

      blocTest(
        'should update watchlist message when add watchlist failed',
        build: () {
          when(saveWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
          when(getWatchListStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (WatchlistMoviesBloc bloc) =>
            bloc.add(AddToWatchlistMovies(testMovieDetail)),
        expect: () => [
          WatchlistError('Failed'),
        ],
        verify: (bloc) {
          verify(saveWatchlist.execute(testMovieDetail));
          return AddToWatchlistMovies(testMovieDetail).props;
        },
      );

      blocTest(
        'should update watchlist status when remove watchlist succeeded',
        build: () {
          when(removeWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async => const Right('Removed'));
          return bloc;
        },
        act: (WatchlistMoviesBloc bloc) =>
            bloc.add(RemoveFromWatchlistMovies(testMovieDetail)),
        expect: () => [
          WatchlistSuccess('Removed'),
        ],
        verify: (bloc) {
          verify(removeWatchlist.execute(testMovieDetail));
          return RemoveFromWatchlistMovies(testMovieDetail).props;
        },
      );

      blocTest(
        'should update watchlist status when remove watchlist failed',
        build: () {
          when(removeWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async => const Right('Removed'));
          return bloc;
        },
        act: (WatchlistMoviesBloc bloc) =>
            bloc.add(RemoveFromWatchlistMovies(testMovieDetail)),
        expect: () => [
          WatchlistSuccess('Removed'),
        ],
        verify: (bloc) {
          verify(removeWatchlist.execute(testMovieDetail));
          return RemoveFromWatchlistMovies(testMovieDetail).props;
        },
      );
    },
  );
}
