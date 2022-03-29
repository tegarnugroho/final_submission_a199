import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
  GetWatchlistStatusTvSeries,
])
void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries getWatchlist;
  late SaveWatchlistTvSeries saveWatchlist;
  late RemoveWatchlistTvSeries removeWatchlist;
  late GetWatchlistStatusTvSeries getWatchListStatus;

  setUp(() {
    getWatchlist = MockGetWatchlistTvSeries();
    saveWatchlist = MockSaveWatchlistTvSeries();
    removeWatchlist = MockRemoveWatchlistTvSeries();
    getWatchListStatus = MockGetWatchlistStatusTvSeries();
    bloc = WatchlistTvSeriesBloc(
      getWatchListStatus: getWatchListStatus,
      getWatchlist: getWatchlist,
      removeFromWatchlist: removeWatchlist,
      saveWatchlist: saveWatchlist,
    );
  });

  group('Watchlist tv series', () {
    test('should change state to initial', () {
      expect(bloc.state, WatchlistTvSeriesInitial());
    });

    blocTest('should emit [loading, success] when data is gotten succesful',
        build: () {
          when(getWatchlist.execute())
              .thenAnswer((_) async => Right([testWatchlistTvSeries]));

          return bloc;
        },
        act: (WatchlistTvSeriesBloc bloc) =>
            bloc.add(OnFetchWatchlistTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              WatchlistTvSeriesLoading(),
              WatchlistTvSeriesSuccess([testWatchlistTvSeries]),
            ],
        verify: (WatchlistTvSeriesBloc bloc) {
          verify(getWatchlist.execute());
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getWatchlist.execute())
              .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));

          return bloc;
        },
        act: (WatchlistTvSeriesBloc bloc) =>
            bloc.add(OnFetchWatchlistTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              WatchlistTvSeriesLoading(),
              WatchlistTvSeriesError("Can't get data"),
            ],
        verify: (WatchlistTvSeriesBloc bloc) {
          verify(getWatchlist.execute());
        });
  });


  group(
    'get watchlist status test cases',
    () {
      blocTest(
        'should be true when the watchlist status is also true',
        build: () {
          when(getWatchListStatus.execute(testTvSeriesDetail.id))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (WatchlistTvSeriesBloc bloc) => bloc.add(FetchWatchlistStatus(testTvSeriesDetail.id)),
        expect: () => [
          IsAddedToWatchlistTvSeries(true),
        ],
        verify: (bloc) {
          verify(getWatchListStatus.execute(testTvSeriesDetail.id));
          return FetchWatchlistStatus(testTvSeriesDetail.id).props;
        },
      );

      blocTest(
        'should be false when the watchlist status is also false',
        build: () {
          when(getWatchListStatus.execute(testTvSeriesDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (WatchlistTvSeriesBloc bloc) => bloc.add(FetchWatchlistStatus(testTvSeriesDetail.id)),
        expect: () => [
          IsAddedToWatchlistTvSeries(false),
        ],
        verify: (bloc) {
          verify(getWatchListStatus.execute(testTvSeriesDetail.id));
          return FetchWatchlistStatus(testTvSeriesDetail.id).props;
        },
      );
    },
  );
  group(
    'Watchlist Tv Series Add & Remove',
    () {
      blocTest(
        'should update watchlist when adding watchlist succeeded',
        build: () {
          when(saveWatchlist.execute(testTvSeriesDetail))
              .thenAnswer((_) async => const Right('Added to Watchlist'));
          return bloc;
        },
        act: (WatchlistTvSeriesBloc bloc) =>
            bloc.add(AddToWatchlistTvSeries(testTvSeriesDetail)),
        expect: () => [
          WatchlistTvSeriesMessage('Added to Watchlist'),
        ],
        verify: (bloc) {
          verify(saveWatchlist.execute(testTvSeriesDetail));
          return AddToWatchlistTvSeries(testTvSeriesDetail).props;
        },
      );

      blocTest(
        'should update watchlist message when add watchlist failed',
        build: () {
          when(saveWatchlist.execute(testTvSeriesDetail))
              .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
          when(getWatchListStatus.execute(testTvSeriesDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (WatchlistTvSeriesBloc bloc) =>
            bloc.add(AddToWatchlistTvSeries(testTvSeriesDetail)),
        expect: () => [
          WatchlistError('Failed'),
        ],
        verify: (bloc) {
          verify(saveWatchlist.execute(testTvSeriesDetail));
          return AddToWatchlistTvSeries(testTvSeriesDetail).props;
        },
      );

      blocTest(
        'should update watchlist when remove watchlist succeeded',
        build: () {
          when(removeWatchlist.execute(testTvSeriesDetail))
              .thenAnswer((_) async => const Right('Removed'));
          return bloc;
        },
        act: (WatchlistTvSeriesBloc bloc) =>
            bloc.add(RemoveFromWatchlistTvSeries(testTvSeriesDetail)),
        expect: () => [
          WatchlistTvSeriesMessage('Removed'),
        ],
        verify: (bloc) {
          verify(removeWatchlist.execute(testTvSeriesDetail));
          return RemoveFromWatchlistTvSeries(testTvSeriesDetail).props;
        },
      );

      blocTest(
        'should update watchlist when remove watchlist failed',
        build: () {
          when(removeWatchlist.execute(testTvSeriesDetail))
              .thenAnswer((_) async => const Right('Removed'));
          return bloc;
        },
        act: (WatchlistTvSeriesBloc bloc) =>
            bloc.add(RemoveFromWatchlistTvSeries(testTvSeriesDetail)),
        expect: () => [
          WatchlistTvSeriesMessage('Removed'),
        ],
        verify: (bloc) {
          verify(removeWatchlist.execute(testTvSeriesDetail));
          return RemoveFromWatchlistTvSeries(testTvSeriesDetail).props;
        },
      );
    },
  );
}
