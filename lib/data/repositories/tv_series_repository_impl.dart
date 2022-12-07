import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl implements TvSeriesRepository {

  final TvSeriesLocalDataSource localDataSource;
  final TvSeriesRemoteDataSource remoteDataSource;

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource
  });

  @override
  Future<Either<Failure, List<Tv>>> getTvSeriesAiringToday() async {
    try {
      final result = await remoteDataSource.getTvSeriesAiringToday();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on HandshakeException {
      return Left(HandshakeFailure("Failed to connect due to technical issue, please contact developer"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTvSeries() async {
    try {
      final result = await remoteDataSource.getPopularTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on HandshakeException {
      return Left(HandshakeFailure("Failed to connect due to technical issue, please contact developer"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries() async {
    try {
      final result = await remoteDataSource.getTopRatedTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on HandshakeException {
      return Left(HandshakeFailure("Failed to connect due to technical issue, please contact developer"));
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on HandshakeException {
      return Left(HandshakeFailure("Failed to connect due to technical issue, please contact developer"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvSeriesRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesRecommendations(id);
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on HandshakeException {
      return Left(HandshakeFailure("Failed to connect due to technical issue, please contact developer"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTvSeriesList(String query) async {
    try {
      final result = await remoteDataSource.searchTvSeriesList(query);
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(""));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connect to the network"));
    } on HandshakeException {
      return Left(HandshakeFailure("Failed to connect due to technical issue, please contact developer"));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTvSeries() async {
    final result = await localDataSource.getWatchlistTvSeries();
    return Right(result.map((e) => e.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTvSeriesById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tvSeries) async {
    try {
      final result = await localDataSource.removeWatchlist(TvTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tvSeries) async {
    try {
      final result = await localDataSource.insertWatchlist(TvTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

}