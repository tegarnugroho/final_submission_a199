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
  final TvSeriesDetail result;
  final List<TvSeries> recommendations;

  const TvSeriesDetailSuccess(this.result, {this.recommendations = const []}
  );

  @override
  List<Object> get props => [result, recommendations];
}
