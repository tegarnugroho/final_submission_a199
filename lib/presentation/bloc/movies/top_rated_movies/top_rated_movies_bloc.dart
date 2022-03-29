import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  TopRatedMoviesBloc(GetTopRatedMovies getTopRatedMovies) : super(TopRatedMoviesInitial()) {
    on<TopRatedMoviesEvent>((event, emit) async{
      emit(TopRatedMoviesLoading());

      final result = await getTopRatedMovies.execute();

      result.fold((failure) {
        final state = TopRatedMoviesError(failure.message);

        emit(state);
      }, (data) {
        final tvSeries = data;
        final state = TopRatedMoviesSuccess(tvSeries);

        emit(state);
      });
    });
  }
}
