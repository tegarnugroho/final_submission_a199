part of 'now_playing_tv_series_bloc.dart';

abstract class NowPlayingTvSeriesState extends Equatable {
  const NowPlayingTvSeriesState();
  
  @override
  List<Object> get props => [];
}

class NowPlayingTvSeriesInitial extends NowPlayingTvSeriesState {}


class NowPlayingTvSeriesLoading extends NowPlayingTvSeriesState {}


class NowPlayingTvSeriesSuccess extends NowPlayingTvSeriesState {
  final List<TvSeries> tvSeries;

  NowPlayingTvSeriesSuccess(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class NowPlayingTvSeriesError extends NowPlayingTvSeriesState {
  final String message;

  NowPlayingTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
