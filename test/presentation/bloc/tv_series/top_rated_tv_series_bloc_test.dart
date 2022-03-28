import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late GetTopRatedTvSeries getTopRatedTvSeries;
  late TopRatedTvSeriesBloc bloc;

  setUp(() {
    getTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TopRatedTvSeriesBloc(getTopRatedTvSeries);
  });

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    name: 'title',
    originalLanguage: 'en',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Top Rated Tv Series', () {
    test('should change state to initial', () {
      expect(bloc.state, TopRatedTvSeriesInitial());
    });

    blocTest('should emit [loading, success] when data is gotten successfully',
        build: () {
          when(getTopRatedTvSeries.execute())
              .thenAnswer((_) async => Right(tTvSeriesList));

          return bloc;
        },
        act: (TopRatedTvSeriesBloc bloc) => bloc.add(OnFetchTopRatedTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () =>
            [TopRatedTvSeriesLoading(), TopRatedTvSeriesSuccess(tTvSeriesList)],
        verify: (TopRatedTvSeriesBloc bloc) {
          verify(getTopRatedTvSeries.execute());
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getTopRatedTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (TopRatedTvSeriesBloc bloc) => bloc.add(OnFetchTopRatedTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () => [TopRatedTvSeriesLoading(), TopRatedTvSeriesError('')],
        verify: (TopRatedTvSeriesBloc bloc) {
          verify(getTopRatedTvSeries.execute());
        });
  });
}
