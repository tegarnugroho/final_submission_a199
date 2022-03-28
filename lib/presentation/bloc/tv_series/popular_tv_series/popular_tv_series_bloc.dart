import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/usecases/get_popular_tv_series.dart';

part 'popular_tv_series_event.dart';
part 'popular_tv_series_state.dart';

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  PopularTvSeriesBloc(GetPopularTvSeries getPopularTvSeries)
      : super(PopularTvSeriesInitial()) {
    on<PopularTvSeriesEvent>((event, emit) async {
      emit(PopularTvSeriesLoading());

      final result = await getPopularTvSeries.execute();

      result.fold((failure) {
        final state = PopularTvSeriesError(failure.message);

        emit(state);
      }, (data) {
        final tvSeries = data;
        final state = PopularTvSeriesSuccess(tvSeries);

        emit(state);
      });
    });
  }
}
