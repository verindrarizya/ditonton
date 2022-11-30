import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie/recommendations/movie_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_recommendations_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieRecommendations
])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationsBloc movieRecommendationsBloc;
  final tId = 1;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc = MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  test("initial state should be empty", () {
    expect(movieRecommendationsBloc.state, MovieRecommendationsEmpty());
  });

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testMovieList));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(GetMovieRecommendationsEvent(tId)),
    expect: () => <MovieRecommendationsState>[
      MovieRecommendationsLoading(),
      MovieRecommendationsHasData(testMovieList)
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    }
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure("Failed")));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(GetMovieRecommendationsEvent(tId)),
      expect: () => <MovieRecommendationsState>[
        MovieRecommendationsLoading(),
        MovieRecommendationsError("Failed")
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      }
  );
}