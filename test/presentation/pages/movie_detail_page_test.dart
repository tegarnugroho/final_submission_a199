import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movies/movies_detail/movies_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMoviesDetailBloc
    extends MockBloc<MoviesDetailEvent, MoviesDetailState>
    implements MoviesDetailBloc {}

class MoviesDetailEventFake extends Fake implements MoviesDetailEvent {}

class MoviesDetailStateFake extends Fake implements MoviesDetailState {}

class MockWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

class WatchlistMoviesEventFake extends Fake implements WatchlistMoviesEvent {}

class WatchlistMoviesStateFake extends Fake implements WatchlistMoviesState {}

void main() {
  late MockMoviesDetailBloc mockMoviesDetailBloc;
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUpAll(() {
    registerFallbackValue(MoviesDetailEventFake());
    registerFallbackValue(MoviesDetailStateFake());
  });

  setUp(() {
    mockMoviesDetailBloc = MockMoviesDetailBloc();
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesDetailBloc>.value(value: mockMoviesDetailBloc),
        BlocProvider<WatchlistMoviesBloc>.value(value: mockWatchlistMoviesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movies detail page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockMoviesDetailBloc.state).thenReturn(MoviesDetailInitial());
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(IsAddedToWatchlistMovies(false));

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockMoviesDetailBloc.state).thenReturn(MoviesDetailLoading());
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(IsAddedToWatchlistMovies(false));

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockMoviesDetailBloc.state)
          .thenReturn(MoviesDetailSuccess(testMovieDetail));
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(IsAddedToWatchlistMovies(false));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);
      final listViewFinder = find.byType(ListView);

      expect(buttonFinder, findsOneWidget);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockMoviesDetailBloc.state).thenReturn(MoviesDetailError(''));
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(IsAddedToWatchlistMovies(false));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });

    testWidgets(
        'watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockMoviesDetailBloc.state)
          .thenReturn(MoviesDetailSuccess(testMovieDetail));
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(IsAddedToWatchlistMovies(false));

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockMoviesDetailBloc.state)
          .thenReturn(MoviesDetailSuccess(testMovieDetail));
      when(() => mockWatchlistMoviesBloc.state)
          .thenReturn(IsAddedToWatchlistMovies(true));

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}
