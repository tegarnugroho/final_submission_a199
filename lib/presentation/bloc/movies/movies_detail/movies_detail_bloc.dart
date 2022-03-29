import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'movies_detail_event.dart';
part 'movies_detail_state.dart';

class MoviesDetailBloc extends Bloc<MoviesDetailEvent, MoviesDetailState> {
  MoviesDetailBloc(GetMovieDetail getMovieDetail,
      GetMovieRecommendations getMovieRecommendations)
      : super(MoviesDetailInitial()) {
    on<MoviesDetailEvent>((event, emit) async {
      if (event is OnFecthMoviesDetail) {
        emit(MoviesDetailLoading());
        final detailResult = await getMovieDetail.execute(event.id);
        final recommendationResult =
            await getMovieRecommendations.execute(event.id);

        detailResult.fold((failure) {
          emit(MoviesDetailError(failure.message));
        }, (data) {
          recommendationResult.fold((failure) {
            final state = MoviesDetailError(failure.message);

            emit(state);
            emit(MoviesDetailSuccess(data));
          }, (dataRecommendations) {
            final state = MoviesDetailSuccess(data,
                recommendations: dataRecommendations);

            emit(state);
          });
        });
      }
    });
  }
}
