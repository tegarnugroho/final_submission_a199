import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/now_playing_tv_series/now_playing_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries])
void main() {
  late GetNowPlayingTvSeries getNowPlayingTvSeries;
  late NowPlayingTvSeriesBloc bloc;

  setUp(() {
    getNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    bloc = NowPlayingTvSeriesBloc(getNowPlayingTvSeries);
  });

  final tTvSeriesModel = testTvSeries;
  final tTvSeriesList = [tTvSeriesModel];

  group('Now Playing Tv Series', () {
    test('should change state to loading when usecase is called', () {
      expect(bloc.state, NowPlayingTvSeriesInitial());
    });

    blocTest('should emit [loading, success] when data is gotten successfully',
        build: () {
          when(getNowPlayingTvSeries.execute())
              .thenAnswer((_) async => Right(tTvSeriesList));

          return bloc;
        },
        act: (NowPlayingTvSeriesBloc bloc) =>
            bloc.add(OnFetchNowPlayingTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              NowPlayingTvSeriesLoading(),
              NowPlayingTvSeriesSuccess(tTvSeriesList)
            ],
        verify: (NowPlayingTvSeriesBloc bloc) {
          verify(getNowPlayingTvSeries.execute());
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getNowPlayingTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (NowPlayingTvSeriesBloc bloc) =>
            bloc.add(OnFetchNowPlayingTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () =>
            [NowPlayingTvSeriesLoading(), NowPlayingTvSeriesError('')],
        verify: (NowPlayingTvSeriesBloc bloc) {
          verify(getNowPlayingTvSeries.execute());
        });
  });
}
