import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_tv_series_event.dart';
part 'now_playing_tv_series_state.dart';

class NowPlayingTvSeriesBloc
    extends Bloc<NowPlayingTvSeriesEvent, NowPlayingTvSeriesState> {
  NowPlayingTvSeriesBloc(GetNowPlayingTvSeries getNowPlayingTvSeries)
      : super(NowPlayingTvSeriesInitial()) {
    on<NowPlayingTvSeriesEvent>((event, emit) async {
      emit(NowPlayingTvSeriesLoading());

      final result = await getNowPlayingTvSeries.execute();

      result.fold((failure) {
        final state = NowPlayingTvSeriesError(failure.message);

        emit(state);
      }, (data) {
        final result = data;
        final state = NowPlayingTvSeriesSuccess(result);

        emit(state);
      });
    });
  }
}
