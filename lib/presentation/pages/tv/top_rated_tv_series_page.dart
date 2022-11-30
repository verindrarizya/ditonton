import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "/top-rated-tv-series";

  const TopRatedTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Rated Tv Series"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (context, state) {
            if (state is TopRatedTvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedTvSeriesError) {
              return Center(
                key: Key("error_message"),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<TopRatedTvSeriesBloc>(context, listen: false)
            .add(GetTopRatedTvSeriesEvent())
    );
  }
}
