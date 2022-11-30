import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/airing_today/airing_today_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/airing_today_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_object_tv.dart';

class MockAiringTodayTvSeriesBloc
  extends MockBloc<AiringTodayTvSeriesEvent, AiringTodayTvSeriesState>
  implements AiringTodayTvSeriesBloc {}

void main() {
  late MockAiringTodayTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockAiringTodayTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<AiringTodayTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "page should display center progress bar when loading",
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            AiringTodayTvSeriesLoading()
          ]),
          initialState: AiringTodayTvSeriesEmpty()
        );

        final progressBar = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(AiringTodayTvSeriesPage()));
        await tester.pump(Duration.zero);

        expect(progressBar, findsOneWidget);
        expect(centerFinder, findsOneWidget);
      }
  );

  testWidgets(
    "page should display listview when data is loaded",
      (WidgetTester tester) async {
        whenListen(
            mockBloc,
            Stream.fromIterable([
              AiringTodayTvSeriesLoading(),
              AiringTodayTvSeriesHasData(testTvList)
            ]),
            initialState: AiringTodayTvSeriesEmpty()
        );

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(AiringTodayTvSeriesPage()));
        await tester.pump(Duration.zero);

        expect(listViewFinder, findsOneWidget);
      }
  );

  testWidgets(
    "page should display text with message when error happened",
      (WidgetTester tester) async {
        whenListen(
            mockBloc,
            Stream.fromIterable([
              AiringTodayTvSeriesLoading(),
              AiringTodayTvSeriesError("Failed")
            ]),
            initialState: AiringTodayTvSeriesEmpty()
        );

        final textFinder = find.byKey(Key("error_message"));

        await tester.pumpWidget(_makeTestableWidget(AiringTodayTvSeriesPage()));
        await tester.pump(Duration.zero);

        expect(textFinder, findsOneWidget);
      }
  );
}