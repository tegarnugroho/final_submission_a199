import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

class TopRatedMoviesEventFake extends Fake implements TopRatedMoviesEvent {}

class TopRatedMoviesStateFake extends Fake implements TopRatedMoviesState {}

void main() {
  late MockTopRatedMovieBloc mockTopRatedMovieBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedMoviesEventFake());
    registerFallbackValue(TopRatedMoviesStateFake());
  });

  setUp(() {
    mockTopRatedMovieBloc = MockTopRatedMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockTopRatedMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Top Rated Movie Page:', () {
       testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockTopRatedMovieBloc.state)
          .thenReturn(TopRatedMoviesInitial());
      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });


    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockTopRatedMovieBloc.state)
          .thenReturn(TopRatedMoviesLoading());
      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockTopRatedMovieBloc.state)
          .thenReturn(TopRatedMoviesSuccess(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockTopRatedMovieBloc.state)
          .thenReturn(TopRatedMoviesError('Error'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
