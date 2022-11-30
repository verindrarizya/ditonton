
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc movieDetailBloc;
  final tId = 1;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  test('initial state should be empty', () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(GetMovieDetailEvent(tId)),
    expect: () => <MovieDetailState>[
      MovieDetailLoading(),
      MovieDetailHasData(testMovieDetail)
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
    }
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure("Failed")));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailEvent(tId)),
      expect: () => <MovieDetailState>[
        MovieDetailLoading(),
        MovieDetailError("Failed")
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      }
  );
}