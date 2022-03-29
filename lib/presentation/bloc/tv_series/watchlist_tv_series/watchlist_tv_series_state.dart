part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesInitial extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

class WatchlistTvSeriesSuccess extends WatchlistTvSeriesState {
  final List<TvSeries> watchlistTvSeries;

  WatchlistTvSeriesSuccess(this.watchlistTvSeries);

  @override
  List<Object> get props => [...watchlistTvSeries];
}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvSeriesMessage extends WatchlistTvSeriesState {
  final String message;

  const WatchlistTvSeriesMessage(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistError extends WatchlistTvSeriesState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class IsAddedToWatchlistTvSeries extends WatchlistTvSeriesState {
  final bool isAdded;

  IsAddedToWatchlistTvSeries(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

