import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchListTvSeriesStatus {
  final TvSeriesRepository _repository;

  GetWatchListTvSeriesStatus(this._repository);

  Future<bool> execute(int id) async {
    return _repository.isAddedToWatchlist(id);
  }

}