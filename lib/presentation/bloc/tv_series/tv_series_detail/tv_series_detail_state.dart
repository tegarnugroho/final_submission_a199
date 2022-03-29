part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();

  @override
  List<Object> get props => [];
}

class TvSeriesDetailInitial extends TvSeriesDetailState {}

class TvSeriesDetailLoading extends TvSeriesDetailState {}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  const TvSeriesDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesDetailSuccess extends TvSeriesDetailState {
  final TvSeriesDetail detail;
  final List<TvSeries> recommendations;

  const TvSeriesDetailSuccess(this.detail, {this.recommendations = const []}
  );

  @override
  List<Object> get props => [detail, recommendations];
}
