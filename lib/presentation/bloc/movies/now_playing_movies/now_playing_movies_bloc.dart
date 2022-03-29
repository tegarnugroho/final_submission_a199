import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  NowPlayingMoviesBloc(GetNowPlayingMovies getNowPlayingMovies)
      : super(NowPlayingMoviesInitial()) {
    on<NowPlayingMoviesEvent>((event, emit) async {
      emit(NowPlayingMoviesLoading());

      final result = await getNowPlayingMovies.execute();

      result.fold((failure) {
        final state = NowPlayingMoviesError(failure.message);

        emit(state);
      }, (data) {
        final result = data;
        final state = NowPlayingMoviesSuccess(result);

        emit(state);
      });
    });
  }
}