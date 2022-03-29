import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movies/movies_detail/movies_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movies_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
])
void main() {
  late GetMovieDetail getMovieDetail;
  late GetMovieRecommendations getMovieRecommendations;
  late MoviesDetailBloc bloc;

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  setUp(() {
    getMovieDetail = MockGetMovieDetail();
    getMovieRecommendations = MockGetMovieRecommendations();
    bloc = MoviesDetailBloc(getMovieDetail, getMovieRecommendations);
  });

  group('Movies Detail', () {
    test('should change state to initial', () {
      expect(bloc.state, MoviesDetailInitial());
    });

    blocTest('should emit [loading, success] when data is gotten successfully',
        build: () {
          when(getMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          when(getMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(tMovieList));

          return bloc;
        },
        act: (MoviesDetailBloc bloc) => bloc.add(OnFecthMoviesDetail(tId)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              MoviesDetailLoading(),
              MoviesDetailSuccess(testMovieDetail,
                  recommendations: tMovieList),
            ],
        verify: (MoviesDetailBloc bloc) {
          verify(getMovieDetail.execute(tId));
          verify(getMovieRecommendations.execute(tId));
        });

    blocTest(
        'should emit [loading, error, success] when data is gotten successfully',
        build: () {
          when(getMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          when(getMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (MoviesDetailBloc bloc) => bloc.add(OnFecthMoviesDetail(tId)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              MoviesDetailLoading(),
              MoviesDetailError(''),
              MoviesDetailSuccess(testMovieDetail),
            ],
        verify: (MoviesDetailBloc bloc) {
          verify(getMovieDetail.execute(tId));
          verify(getMovieRecommendations.execute(tId));
        });

    blocTest('should emit [loading, error] when data is unsuccessful',
        build: () {
          when(getMovieDetail.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('')));
          when(getMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Left(ServerFailure('')));

          return bloc;
        },
        act: (MoviesDetailBloc bloc) => bloc.add(OnFecthMoviesDetail(tId)),
        wait: const Duration(milliseconds: 500),
        expect: () => [
              MoviesDetailLoading(),
              MoviesDetailError(''),
            ],
        verify: (MoviesDetailBloc bloc) {
          verify(getMovieDetail.execute(tId));
          verify(getMovieRecommendations.execute(tId));
        });
  });
}
