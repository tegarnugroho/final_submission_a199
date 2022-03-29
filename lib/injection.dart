import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/movies/movies_detail/movies_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/movies_search/movies_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/now_playing_tv_series/now_playing_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/now_playing_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'domain/usecases/get_watchlist_status_tv_series.dart';
import 'presentation/provider/tv_series_detail_notifier.dart';

final locator = GetIt.instance;

void init() {
  // bloc tv Series
  locator.registerFactory(() => NowPlayingTvSeriesBloc(locator()));
  locator.registerFactory(() => PopularTvSeriesBloc(locator()));
  locator.registerFactory(() => TopRatedTvSeriesBloc(locator()));
  locator.registerFactory(() => TvSeriesDetailBloc(locator(), locator()));
  locator.registerFactory(() => TvSeriesSearchBloc(locator()));
  locator.registerFactory(() => WatchlistTvSeriesBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(() => MoviesSearchBloc(locator()));
  locator.registerFactory(() => WatchlistMoviesBloc(locator()));
  locator.registerFactory(() => MoviesDetailBloc(locator(), locator()));

  // provider movies
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  /// provider tv series
  locator.registerFactory(
    () => TvSeriesListNotifier(
      getNowPlayingTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesNotifier(
      getWatchlistTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvSeriesNotifier(
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvSeriesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingTvSeriesNotifier(
      getNowPlayingTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesSearchNotifier(
      searchTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailNotifier(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchListStatusTvSeries: locator(),
      removeWatchlistTvSeries: locator(),
      saveWatchlistTvSeries: locator(),
    ),
  );

  // use case movies
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  // use case tv series
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatusTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
