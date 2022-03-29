part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class OnFetchWatchlistMovies extends WatchlistMoviesEvent {}

class AddToWatchlistMovies extends WatchlistMoviesEvent {
  final MovieDetail detail;

  const AddToWatchlistMovies(this.detail);

  @override
  List<Object> get props => [detail];
}

class RemoveFromWatchlistMovies extends WatchlistMoviesEvent {
  final MovieDetail detail;

  const RemoveFromWatchlistMovies(this.detail);

  @override
  List<Object> get props => [detail];
}
