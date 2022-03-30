import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularTvSeriesBloc
    extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState>
    implements PopularTvSeriesBloc {}

class PopularTvSeriesEventFake extends Fake implements PopularTvSeriesEvent {}

class PopularTvSeriesStateFake extends Fake implements PopularTvSeriesState {}

void main() {
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(PopularTvSeriesEventFake());
    registerFallbackValue(PopularTvSeriesStateFake());
  });

  setUp(() {
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockPopularTvSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Popular Tv Series Page:', () {
    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesLoading());
      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesSuccess(testTvSeriesList));

      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesError('Error'));

      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
