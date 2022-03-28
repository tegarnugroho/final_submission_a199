import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
])
void main() {
  late GetTvSeriesDetail getTvSeriesDetail;
  late GetTvSeriesRecommendations getTvSeriesRecommendations;
  late TvSeriesDetailBloc bloc;

  final tId = 1;

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

  setUp(() {
    getTvSeriesDetail = MockGetTvSeriesDetail();
    getTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    bloc = TvSeriesDetailBloc(getTvSeriesDetail, getTvSeriesRecommendations);
  });

  group('Tv Series Detail', () {
    test('should change state to initial', () {
      expect(bloc.state, TvSeriesDetailInitial());
    });

    blocTest('should emit [loading, success] when data is gotten successfully',
        build: () {
          when(getTvSeriesDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvSeriesDetail));
          when(getTvSeriesRecommendations.execute(tId))
              .thenAnswer((_) async => Right(tTvSeriesList));

          return bloc;
        },
        act: (TvSeriesDetailBloc bloc) => bloc.add(OnFecthTvSeriesDetail(tId)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              TvSeriesDetailLoading(),
              TvSeriesDetailSuccess(testTvSeriesDetail,
                  recommendations: tTvSeriesList),
            ],
        verify: (TvSeriesDetailBloc bloc) {
          verify(getTvSeriesDetail.execute(tId));
          verify(getTvSeriesRecommendations.execute(tId));
        });

    blocTest(
        'should emit [loading, error, success] when data is gotten successfully',
        build: () {
          when(getTvSeriesDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvSeriesDetail));
          when(getTvSeriesRecommendations.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (TvSeriesDetailBloc bloc) => bloc.add(OnFecthTvSeriesDetail(tId)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              TvSeriesDetailLoading(),
              TvSeriesDetailError(''),
              TvSeriesDetailSuccess(testTvSeriesDetail),
            ],
        verify: (TvSeriesDetailBloc bloc) {
          verify(getTvSeriesDetail.execute(tId));
          verify(getTvSeriesRecommendations.execute(tId));
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getTvSeriesDetail.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('')));
          when(getTvSeriesRecommendations.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (TvSeriesDetailBloc bloc) => bloc.add(OnFecthTvSeriesDetail(tId)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              TvSeriesDetailLoading(),
              TvSeriesDetailError(''),
            ],
        verify: (TvSeriesDetailBloc bloc) {
          verify(getTvSeriesDetail.execute(tId));
          verify(getTvSeriesRecommendations.execute(tId));
        });
  });
}
