import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

class PopularMovieEventFake extends Fake implements PopularMoviesEvent {}

class PopularMovieStateFake extends Fake implements PopularMoviesState {}

void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUpAll(() {
    registerFallbackValue(PopularMovieEventFake());
    registerFallbackValue(PopularMovieStateFake());
  });

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockPopularMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Popular Movie Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockPopularMoviesBloc.state)
          .thenReturn(PopularMoviesInitial());
      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockPopularMoviesBloc.state)
          .thenReturn(PopularMoviesLoading());
      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockPopularMoviesBloc.state)
          .thenReturn(PopularMoviesSuccess(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockPopularMoviesBloc.state)
          .thenReturn(PopularMoviesError('Error'));

      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
