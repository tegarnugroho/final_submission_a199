import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  TvSeriesDetailBloc(GetTvSeriesDetail getTvSeriesDetail,
      GetTvSeriesRecommendations getTvSeriesRecommendations)
      : super(TvSeriesDetailInitial()) {
    on<TvSeriesDetailEvent>((event, emit) async {
      if (event is OnFecthTvSeriesDetail) {
        emit(TvSeriesDetailLoading());
        final detailResult = await getTvSeriesDetail.execute(event.id);
        final recommendationResult =
            await getTvSeriesRecommendations.execute(event.id);

        detailResult.fold((failure) {
          emit(TvSeriesDetailError(failure.message));
        }, (data) {
          recommendationResult.fold((failure) {
            final state = TvSeriesDetailError(failure.message);

            emit(state);
            emit(TvSeriesDetailSuccess(data));
          }, (dataRecommendations) {
            final state = TvSeriesDetailSuccess(data,
                recommendations: dataRecommendations);

            emit(state);
          });
        });
      }
    });
  }
}
