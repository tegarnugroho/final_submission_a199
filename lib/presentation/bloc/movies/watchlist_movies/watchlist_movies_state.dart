part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();
  
  @override
  List<Object> get props => [];
}

class WatchlistMoviesInitial extends WatchlistMoviesState {}

class WatchlistMoviesLoading extends WatchlistMoviesState {}

class WatchlistMoviesSuccess extends WatchlistMoviesState {
  final List<Movie> watchlistMovies;

  WatchlistMoviesSuccess(this.watchlistMovies);

  @override
  List<Object> get props => [...watchlistMovies];
}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistSuccess extends WatchlistMoviesState {
  final String message;

  const WatchlistSuccess(this.message);

  @override
  List<Object> get props => [message];
}


class WatchlistError extends WatchlistMoviesState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}
