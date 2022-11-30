import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_object_tv.dart';

class MockPopularTvSeriesBloc
  extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState>
  implements PopularTvSeriesBloc {}

void main() {
  late MockPopularTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
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
            PopularTvSeriesLoading()
          ]),
          initialState: PopularTvSeriesEmpty()
        );

        final progressBar = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
        await tester.pump(Duration.zero);

        expect(centerFinder, findsOneWidget);
        expect(progressBar, findsOneWidget);
      }
  );

  testWidgets(
    "page should display listview when data is loaded",
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            PopularTvSeriesLoading(),
            PopularTvSeriesHasData(testTvList)
          ]),
          initialState: PopularTvSeriesEmpty()
        );

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
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
            PopularTvSeriesLoading(),
            PopularTvSeriesError("Failed")
          ]),
          initialState: PopularTvSeriesEmpty()
        );

        final textFinder = find.byKey(Key("error_message"));

        await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
        await tester.pump(Duration.zero);

        expect(textFinder, findsOneWidget);
      }
  );
}