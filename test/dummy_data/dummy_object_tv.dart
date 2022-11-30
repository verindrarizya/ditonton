import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testTvTable = TvTable(
  id: 1,
  name: "name",
  overview: "overview",
  posterPath: "posterPath"
);

final testTvMap = {
  "id": 1,
  "name": "name",
  "overview": "overview",
  "posterPath": "posterPath"
};

final testTvDetail = TvDetail(
  backdropPath: "backdropPath",
  firstAirDate: "firstAirDate",
  genres: [Genre(id: 1, name: "genre 1")],
  id: 1,
  name: "name",
  originalLanguage: "originalLanguage",
  originalName: "originalName",
  overview: "overview",
  popularity: 1.0,
  posterPath: "posterPath",
  voteAverage: 1.0,
  voteCount: 1,
  type: "type",
  tagline: "tagline",
  status: "status",
  numberOfSeasons: 1,
  numberOfEpisodes: 1,
  lastAirDate: "lastAirDate"
);

final testWatchlistTvSeries = Tv.watchList(
  id: 1,
  name: "name",
  overview: "overview",
  posterPath: "posterPath"
);

final testTv = Tv(
    backdropPath: "backdropPath",
    firstAirDate: "firstAirData",
    id: 1,
    name: "name",
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    voteAverage: 1.0,
    voteCount: 1,
    originCountry: ["originCountry"],
  genreIds: [1]
);

final testTvList = [testTv];