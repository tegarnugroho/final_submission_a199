import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late GetPopularTvSeries getPopularTvSeries;
  late PopularTvSeriesBloc bloc;

  setUp(() {
    getPopularTvSeries = MockGetPopularTvSeries();
    bloc = PopularTvSeriesBloc(getPopularTvSeries);
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

  group('Popular Tv Series', () {
    test('should change state to initial', () {
      expect(bloc.state, PopularTvSeriesInitial());
    });

    blocTest('should emit [loading, success] when data is gotten successfully',
        build: () {
          when(getPopularTvSeries.execute())
              .thenAnswer((_) async => Right(tTvSeriesList));

          return bloc;
        },
        act: (PopularTvSeriesBloc bloc) => bloc.add(OnFetchPopularTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              PopularTvSeriesLoading(),
              PopularTvSeriesSuccess(tTvSeriesList),
            ],
        verify: (PopularTvSeriesBloc bloc) {
          verify(getPopularTvSeries.execute());
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getPopularTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (PopularTvSeriesBloc bloc) => bloc.add(OnFetchPopularTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              PopularTvSeriesLoading(),
              PopularTvSeriesError(''),
            ],
        verify: (PopularTvSeriesBloc bloc) {
          verify(getPopularTvSeries.execute());
        });
  });
}
