import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'movies_search_event.dart';
part 'movies_search_state.dart';

class MoviesSearchBloc extends Bloc<MoviesSearchEvent, MoviesSearchState> {
  MoviesSearchBloc(SearchMovies searchMovies) : super(MoviesSearchInitial()) {
    on<OnMoviesQueryChanged>((event, emit) async {
      final query = event.query;

      if (query.isEmpty) {
        emit(MoviesSearchInitial());
        return;
      }

      emit(MoviesSearchLoading());

      final result = await searchMovies.execute(query);

      result.fold((failure) {
        final resultState = MoviesSearchError('');

        emit(resultState);
      }, (data) async {
        final resultState = MoviesSearchSuccess(data);

        emit(resultState);
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
