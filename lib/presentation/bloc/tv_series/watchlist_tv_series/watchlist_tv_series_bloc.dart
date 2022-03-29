import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  WatchlistTvSeriesBloc({
    required GetWatchlistTvSeries getWatchlist,
    required SaveWatchlistTvSeries saveWatchlist,
    required RemoveWatchlistTvSeries removeFromWatchlist,
    required GetWatchlistStatusTvSeries getWatchListStatus,
  }) : super(WatchlistTvSeriesInitial()) {
    on<OnFetchWatchlistTvSeries>((event, emit) async {
      emit(WatchlistTvSeriesLoading());
      final result = await getWatchlist.execute();

      result.fold((failure) {
        final state = WatchlistTvSeriesError(failure.message);
        emit(state);
      }, (data) {
        emit(WatchlistTvSeriesSuccess(data));
      });
    });

    on<AddToWatchlistTvSeries>((event, emit) async {
      final result = await saveWatchlist.execute(event.detail);

      result.fold(
        (failure) => emit(WatchlistError(failure.message)),
        (successMessage) => emit(WatchlistTvSeriesMessage(successMessage)),
      );
    });

    on<RemoveFromWatchlistTvSeries>((event, emit) async {
      final result = await removeFromWatchlist.execute(event.detail);

      result.fold(
        (failure) => emit(WatchlistError(failure.message)),
        (successMessage) => emit(WatchlistTvSeriesMessage(successMessage)),
      );
    });

    on<FetchWatchlistStatus>((event, emit) async {
      final id = event.id;

      final result = await getWatchListStatus.execute(id);

      emit(IsAddedToWatchlistTvSeries(result));
    });
  }
}
