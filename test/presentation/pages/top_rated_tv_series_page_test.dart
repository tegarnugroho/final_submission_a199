import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

class TopRatedTvSeriesEventFake extends Fake implements TopRatedTvSeriesEvent {}

class TopRatedTvSeriesStateFake extends Fake implements TopRatedTvSeriesState {}
void main() {
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTvSeriesEventFake());
    registerFallbackValue(TopRatedTvSeriesStateFake());
  });

  setUp(() {
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
  });
  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockTopRatedTvSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Top Rated Tv Series Page:', () {
       testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesInitial());
      await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });


    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesLoading());
      await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesSuccess(testTvSeriesList));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesError('Error'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
