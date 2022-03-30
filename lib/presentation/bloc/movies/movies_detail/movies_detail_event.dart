part of 'movies_detail_bloc.dart';

abstract class MoviesDetailEvent extends Equatable {}

class OnFecthMoviesDetail extends MoviesDetailEvent {
  final int id;

  OnFecthMoviesDetail(this.id);

  @override
  List<Object> get props => [id];
}
