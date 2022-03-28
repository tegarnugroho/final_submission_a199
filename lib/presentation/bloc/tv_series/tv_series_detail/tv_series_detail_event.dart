part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class OnFecthTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  const OnFecthTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}