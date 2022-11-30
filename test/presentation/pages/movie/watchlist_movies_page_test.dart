import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

void main() {
  late MockWatchlistMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockWatchlistMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>.value(
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
              WatchlistMovieLoading()
            ]),
            initialState: WatchlistMovieEmpty()
        );

        final progressBar = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));
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
              WatchlistMovieLoading(),
              WatchlistMovieHasData(testMovieList)
            ]),
            initialState: WatchlistMovieEmpty()
        );

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));
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
              WatchlistMovieLoading(),
              WatchlistMovieError("Failed")
            ]),
            initialState: WatchlistMovieEmpty()
        );

        final textFinder = find.byKey(Key("error_message"));

        await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));
        await tester.pump(Duration.zero);

        expect(textFinder, findsOneWidget);
      }
  );
}