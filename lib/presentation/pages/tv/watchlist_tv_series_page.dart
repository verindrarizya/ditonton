import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "/watchlist-tv-series";

  const WatchlistTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<WatchlistTvSeriesPage> createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage> with RouteAware {

  @override
  void initState() {
    super.initState();
    Future.microtask(
            () => BlocProvider.of<WatchlistTvSeriesBloc>(context, listen: false)
                .add(GetWatchlistTvSeriesEvent())
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    BlocProvider.of<WatchlistTvSeriesBloc>(context, listen: false)
        .add(GetWatchlistTvSeriesEvent());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watchlist - Tv Series"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
          builder: (context, state) {
            if (state is WatchlistTvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvSeriesHasData) {
              var tvSeriesList = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = tvSeriesList[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: tvSeriesList.length,
              );
            } else if (state is WatchlistTvSeriesError){
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
