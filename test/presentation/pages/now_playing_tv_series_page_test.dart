import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_series/now_playing_tv_series/now_playing_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTvSeriesBloc
    extends MockBloc<NowPlayingTvSeriesEvent, NowPlayingTvSeriesState>
    implements NowPlayingTvSeriesBloc {}

class NowPlayingTvSeriesEventFake extends Fake
    implements NowPlayingTvSeriesEvent {}

class NowPlayingTvSeriesStateFake extends Fake
    implements NowPlayingTvSeriesState {}

void main() {
  late MockNowPlayingTvSeriesBloc mockNowPlayingTvSeriesBloc;
  setUpAll(() {
    registerFallbackValue(NowPlayingTvSeriesEventFake());
    registerFallbackValue(NowPlayingTvSeriesStateFake());
  });

  setUp(() {
    mockNowPlayingTvSeriesBloc = MockNowPlayingTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTvSeriesBloc>.value(
      value: mockNowPlayingTvSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Now Playing Tv Series Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockNowPlayingTvSeriesBloc.state)
          .thenReturn(NowPlayingTvSeriesInitial());
      await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvSeriesBloc.state)
          .thenReturn(NowPlayingTvSeriesLoading());

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display when data is loaded',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvSeriesBloc.state)
          .thenReturn(NowPlayingTvSeriesSuccess(testTvSeriesList));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockNowPlayingTvSeriesBloc.state)
          .thenReturn(NowPlayingTvSeriesError('Error'));

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
