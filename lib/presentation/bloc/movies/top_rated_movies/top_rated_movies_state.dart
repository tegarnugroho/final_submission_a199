part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();
  
  @override
  List<Object> get props => [];
}

class TopRatedMoviesInitial extends TopRatedMoviesState {}

class TopRatedMoviesLoading extends TopRatedMoviesState {}


class TopRatedMoviesSuccess extends TopRatedMoviesState {
  final List<Movie> movies;

  TopRatedMoviesSuccess(this.movies);

  @override
  List<Object> get props => [movies];
}

class TopRatedMoviesError extends TopRatedMoviesState {
  final String message;

  TopRatedMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
