import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchBloc bloc;
  late MockSearchTvSeries searchTvSeries;

  setUp(() {
    searchTvSeries = MockSearchTvSeries();
    bloc = TvSeriesSearchBloc(searchTvSeries);
  });

  final tTvSeriesModel = TvSeries(
    backdropPath: '/7HLGW6fvAEJ0ZBdRQhqZoby9zGT.jpg',
    genreIds: [10764],
    id: 1549,
    originalTitle: 'WWE SmackDown',
    overview:
        "The superstars of World Wrestling Entertainment's \"SmackDown\" brand collide each and every Friday on WWE Friday Night SmackDown.",
    popularity: 16.351,
    posterPath: '/nq2q5ouFIUs6XAY4QaGrPrC3E2X.jpg',
    name: 'WWE SmackDown',
    originalLanguage: 'en',
    voteAverage: 7.5,
    voteCount: 114,
  );
  final tTvSeriesList = <TvSeries>[tTvSeriesModel];
  final tQuery = 'smackdown';

  group('Search tv series', () {
    test('should change state to initial', () {
      expect(bloc.state, TvSeriesSearchInitial());
    });

    blocTest(
      'should change state to initial when query is empty',
      build: () => bloc,
      act: (TvSeriesSearchBloc bloc) => bloc.add(OnTvSeriesQueryChanged('')),
      wait: const Duration(milliseconds: 500),
      expect: () => [TvSeriesSearchInitial()],
    );

    blocTest('should emit [loading, success] when data is gotten succesful',
        build: () {
          when(searchTvSeries.execute(tQuery))
              .thenAnswer((_) async => Right(tTvSeriesList));

          return bloc;
        },
        act: (TvSeriesSearchBloc bloc) => bloc.add(OnTvSeriesQueryChanged(tQuery)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              TvSeriesSearchLoading(),
              TvSeriesSearchSuccess(tTvSeriesList),
            ],
        verify: (TvSeriesSearchBloc bloc) {
          verify(searchTvSeries.execute(tQuery));
        });

    blocTest('should emit [loading, error] when data is unsuccesful',
        build: () {
          when(searchTvSeries.execute(tQuery))
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (TvSeriesSearchBloc bloc) => bloc.add(OnTvSeriesQueryChanged(tQuery)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              TvSeriesSearchLoading(),
              TvSeriesSearchError(''),
            ],
        verify: (TvSeriesSearchBloc bloc) {
          verify(searchTvSeries.execute(tQuery));
        });
  });
}
