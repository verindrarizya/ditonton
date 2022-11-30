import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvTable extends Equatable {

  final int id;
  final String name;
  final String posterPath;
  final String overview;

  TvTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview
  });

  factory TvTable.fromEntity(TvDetail tvSeries) =>
      TvTable(
        id: tvSeries.id,
        name: tvSeries.name,
        posterPath: tvSeries.posterPath,
        overview: tvSeries.overview
      );

  factory TvTable.fromMap(Map<String, dynamic> map) =>
      TvTable(
        id: map["id"],
        name: map["name"],
        posterPath: map["posterPath"],
        overview: map["overview"]
      );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'name': this.name,
    'posterPath': this.posterPath,
    'overview': this.overview
  };

  Tv toEntity() => Tv.watchList(
    id: this.id,
    name: this.name,
    posterPath: this.posterPath,
    overview: this.overview
  );

  @override
  List<Object?> get props => [
    id,
    name,
    posterPath,
    overview
  ];

}