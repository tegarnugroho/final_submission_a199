import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  WatchlistMoviesBloc({
    required GetWatchlistMovies getWatchlist,
    required SaveWatchlist saveWatchlist,
    required RemoveWatchlist removeFromWatchlist,
    required GetWatchListStatus getWatchListStatus,
  }) : super(WatchlistMoviesInitial()) {
    on<OnFetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMoviesLoading());
      final result = await getWatchlist.execute();

      result.fold((failure) {
        final state = WatchlistMoviesError(failure.message);
        emit(state);
      }, (data) {
        emit(WatchlistMoviesSuccess(data));
      });
    });

    on<AddToWatchlistMovies>((event, emit) async {
      final result = await saveWatchlist.execute(event.detail);

      result.fold(
        (failure) => emit(WatchlistError(failure.message)),
        (successMessage) => emit(WatchlistSuccess(successMessage)),
      );
    });

    on<RemoveFromWatchlistMovies>((event, emit) async {
      final result = await removeFromWatchlist.execute(event.detail);

      result.fold(
        (failure) => emit(WatchlistError(failure.message)),
        (successMessage) => emit(WatchlistSuccess(successMessage)),
      );
    });
  }
}
