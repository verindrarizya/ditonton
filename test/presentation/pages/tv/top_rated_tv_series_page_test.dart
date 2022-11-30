
import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_object_tv.dart';

class MockTopRatedTvSeriesBloc
  extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
  implements TopRatedTvSeriesBloc {}

void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "page should display progress bar when loading",
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            TopRatedTvSeriesLoading()
          ]),
          initialState: TopRatedTvSeriesEmpty()
        );

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));
        await tester.pump(Duration.zero);

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      }
  );

  testWidgets(
    "page should display when data is loaded",
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            TopRatedTvSeriesLoading(),
            TopRatedTvSeriesHasData(testTvList)
          ]),
          initialState: TopRatedTvSeriesEmpty()
        );

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));
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
            TopRatedTvSeriesLoading(),
            TopRatedTvSeriesError("Failed")
          ]),
          initialState: TopRatedTvSeriesEmpty()
        );

        final textFinder = find.byKey(Key("error_message"));

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));
        await tester.pump(Duration.zero);

        expect(textFinder, findsOneWidget);
      }
  );
}