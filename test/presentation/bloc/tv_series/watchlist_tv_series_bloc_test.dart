import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries getWatchlist;

  setUp(() {
    getWatchlist = MockGetWatchlistTvSeries();
    bloc = WatchlistTvSeriesBloc(getWatchlist);
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
        act: (WatchlistTvSeriesBloc bloc) => bloc.add(OnFetchWatchlistTvSeries()),
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
        act: (WatchlistTvSeriesBloc bloc) => bloc.add(OnFetchWatchlistTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              WatchlistTvSeriesLoading(),
              WatchlistTvSeriesError("Can't get data"),
            ],
        verify: (WatchlistTvSeriesBloc bloc) {
          verify(getWatchlist.execute());
        });
  });
}
