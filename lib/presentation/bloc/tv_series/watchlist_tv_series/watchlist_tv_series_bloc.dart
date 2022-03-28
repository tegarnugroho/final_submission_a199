import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  WatchlistTvSeriesBloc(GetWatchlistTvSeries getWatchlist)
      : super(WatchlistTvSeriesInitial()) {
    on<WatchlistTvSeriesEvent>((event, emit) async {
      emit(WatchlistTvSeriesLoading());
      final result = await getWatchlist.execute();

      result.fold((failure) {
        final state = WatchlistTvSeriesError(failure.message);
        emit(state);
      }, (data) {
        emit(WatchlistTvSeriesSuccess(data));
      });
    });
  }
}
