part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnFetchWatchlistTvSeries extends WatchlistTvSeriesEvent {}
class AddToWatchlistTvSeries extends WatchlistTvSeriesEvent {
  final TvSeriesDetail detail;

  const AddToWatchlistTvSeries(this.detail);

  @override
  List<Object> get props => [detail];
}

class FetchWatchlistStatus extends WatchlistTvSeriesEvent {
  final int id;

  FetchWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class RemoveFromWatchlistTvSeries extends WatchlistTvSeriesEvent {
  final TvSeriesDetail detail;

  const RemoveFromWatchlistTvSeries(this.detail);

  @override
  List<Object> get props => [detail];
}
