import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv/airing_today/airing_today_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/airing_today_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-tv-series';

  const HomeTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<HomeTvSeriesPage> createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<AiringTodayTvSeriesBloc>(context, listen: false)
          .add(GetAiringTodayTvSeriesEvent());
      BlocProvider.of<PopularTvSeriesBloc>(context, listen: false)
        .add(GetPopularTvSeriesEvent());
      BlocProvider.of<TopRatedTvSeriesBloc>(context, listen: false)
        .add(GetTopRatedTvSeriesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/circle-g.png"),
              ),
              accountName: Text("Ditonton"),
              accountEmail: Text("ditonton@dicoding.com"),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text("Movies"),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_rounded),
              title: Text("Tv Series"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Movie Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmarks_rounded),
              title: Text("Tv Series Watchlist"),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvSeriesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton - Tv Series'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SearchTvSeriesPage.ROUTE_NAME);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                  title: "Airing Today",
                  onTap: () {
                    Navigator.pushNamed(context, AiringTodayTvSeriesPage.ROUTE_NAME);
                  }
              ),
              BlocBuilder<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
                builder: (context, state) {
                  if (state is AiringTodayTvSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is AiringTodayTvSeriesHasData) {
                    return TvSeriesList(state.result);
                  } else if (state is AiringTodayTvSeriesError) {
                    return Text(state.message);
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: "Popular",
                onTap: () {
                  Navigator.pushNamed(context, PopularTvSeriesPage.ROUTE_NAME);
                }
              ),
              BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
                builder: (context, state) {
                  if (state is PopularTvSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularTvSeriesHasData) {
                    return TvSeriesList(state.result);
                  } else if (state is PopularTvSeriesError) {
                    return Text(state.message);
                  } else {
                    return Container();
                  }
                },
              ),
              _buildSubHeading(
                title: "Top Rated",
                onTap: () {
                  Navigator.pushNamed(context, TopRatedTvSeriesPage.ROUTE_NAME);
                }
              ),
              BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
                builder: (context, state) {
                  if (state is TopRatedTvSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedTvSeriesHasData) {
                    return TvSeriesList(state.result);
                  } else if (state is TopRatedTvSeriesError) {
                    return Text(state.message);
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text('See More'),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<Tv> tvSeriesList;

  const TvSeriesList(this.tvSeriesList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSeries = tvSeriesList[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: tvSeries.id
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: "$BASE_IMAGE_URL${tvSeries.posterPath}",
                  placeholder: (context, url) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Icon(Icons.error);
                  },
                ),
              ),
            ),
          );
        },
        itemCount: tvSeriesList.length,
      ),
    );
  }
}
