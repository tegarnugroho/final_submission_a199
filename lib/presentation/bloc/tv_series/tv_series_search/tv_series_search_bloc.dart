import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  TvSeriesSearchBloc(SearchTvSeries searchTvSeries)
      : super(TvSeriesSearchInitial()) {
    on<OnTvSeriesQueryChanged>((event, emit) async {
      final query = event.query;

      if (query.isEmpty) {
        emit(TvSeriesSearchInitial());
        return;
      }

      emit(TvSeriesSearchLoading());

      final result = await searchTvSeries.execute(query);

      result.fold((failure) {
        final resultState = TvSeriesSearchError('');

        emit(resultState);
      }, (data) async {
        final resultState = TvSeriesSearchSuccess(data);

        emit(resultState);
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
