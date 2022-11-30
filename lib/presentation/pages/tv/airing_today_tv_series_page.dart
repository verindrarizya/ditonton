import 'package:ditonton/presentation/bloc/tv/airing_today/airing_today_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "/airing-today-page";
  const AiringTodayTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<AiringTodayTvSeriesPage> createState() => _AiringTodayTvSeriesPageState();
}

class _AiringTodayTvSeriesPageState extends State<AiringTodayTvSeriesPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      BlocProvider.of<AiringTodayTvSeriesBloc>(context, listen: false)
        .add(GetAiringTodayTvSeriesEvent())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Airing Today"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
          builder: (context, state) {
            if (state is AiringTodayTvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AiringTodayTvSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.result.length,
              );
            } else if (state is AiringTodayTvSeriesError) {
              return Center(
                key: Key("error_message"),
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
