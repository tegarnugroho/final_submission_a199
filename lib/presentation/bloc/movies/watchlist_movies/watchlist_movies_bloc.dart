import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  WatchlistMoviesBloc(GetWatchlistMovies getWatchlist) : super(WatchlistMoviesInitial()) {
    on<WatchlistMoviesEvent>((event, emit) async {
      emit(WatchlistMoviesLoading());
      final result = await getWatchlist.execute();

      result.fold((failure) {
        final state = WatchlistMoviesError(failure.message);
        emit(state);
      }, (data) {
        emit(WatchlistMoviesSuccess(data));
      });
    });
  }
}
