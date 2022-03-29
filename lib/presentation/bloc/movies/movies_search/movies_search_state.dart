part of 'movies_search_bloc.dart';

abstract class MoviesSearchState extends Equatable {
  const MoviesSearchState();
  
  @override
  List<Object> get props => [];
}


class MoviesSearchInitial extends MoviesSearchState {}

class MoviesSearchLoading extends MoviesSearchState {}

class MoviesSearchSuccess extends MoviesSearchState {
  final List<Movie> movies;

  MoviesSearchSuccess(this.movies);

  @override
  List<Object> get props => [...movies];
}

class MoviesSearchError extends MoviesSearchState {
  final String message;

  MoviesSearchError(this.message);

  @override
  List<Object> get props => [message];
}
