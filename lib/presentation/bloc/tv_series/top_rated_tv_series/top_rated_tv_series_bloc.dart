import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';


part 'top_rated_tv_series_event.dart';
part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  TopRatedTvSeriesBloc(GetTopRatedTvSeries getTopRatedTvSeries)
      : super(TopRatedTvSeriesInitial()) {
    on<TopRatedTvSeriesEvent>((event, emit) async {
      emit(TopRatedTvSeriesLoading());

      final result = await getTopRatedTvSeries.execute();

      result.fold((failure) {
        final state = TopRatedTvSeriesError(failure.message);

        emit(state);
      }, (data) {
        final tvSeries = data;
        final state = TopRatedTvSeriesSuccess(tvSeries);

        emit(state);
      });
    });
  }
}
