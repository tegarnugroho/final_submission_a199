part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {}

class OnFecthTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  OnFecthTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}
