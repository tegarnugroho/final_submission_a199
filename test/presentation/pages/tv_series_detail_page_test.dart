import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';


class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class TvSeriesDetailEventFake extends Fake implements TvSeriesDetailEvent {}

class TvSeriesDetailStateFake extends Fake implements TvSeriesDetailState {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

class WatchlistTvSeriesEventFake extends Fake implements WatchlistTvSeriesEvent {}

class WatchlistTvSeriesStateFake extends Fake implements WatchlistTvSeriesState {}

void main() {
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockWatchlistTvSeriesBloc mockWatchlistTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(TvSeriesDetailEventFake());
    registerFallbackValue(TvSeriesDetailStateFake());
  });

  setUp(() {
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockWatchlistTvSeriesBloc = MockWatchlistTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>.value(value: mockTvSeriesDetailBloc),
        BlocProvider<WatchlistTvSeriesBloc>.value(value: mockWatchlistTvSeriesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('T vSeries detail page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailInitial());
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(IsAddedToWatchlistTvSeries(false));

      await tester.pumpWidget(
          _makeTestableWidget(TvSeriesDetailPage(id: testTvSeriesDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailLoading());
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(IsAddedToWatchlistTvSeries(false));

      await tester.pumpWidget(
          _makeTestableWidget(TvSeriesDetailPage(id: testTvSeriesDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailSuccess(testTvSeriesDetail));
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(IsAddedToWatchlistTvSeries(false));

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: testTvSeriesDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);
      final listViewFinder = find.byType(ListView);

      expect(buttonFinder, findsOneWidget);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailError(''));
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(IsAddedToWatchlistTvSeries(false));

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: testTvSeriesDetail.id,
      )));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });

    testWidgets(
        'watchlist button should display add icon when TvSeries not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailSuccess(testTvSeriesDetail));
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(IsAddedToWatchlistTvSeries(false));

      await tester.pumpWidget(
          _makeTestableWidget(TvSeriesDetailPage(id: testTvSeriesDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when TvSeries is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailSuccess(testTvSeriesDetail));
      when(() => mockWatchlistTvSeriesBloc.state)
          .thenReturn(IsAddedToWatchlistTvSeries(true));

      await tester.pumpWidget(
          _makeTestableWidget(TvSeriesDetailPage(id: testTvSeriesDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}
