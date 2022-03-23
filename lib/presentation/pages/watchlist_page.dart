import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';

class WatchList extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';
  const WatchList({Key? key}) : super(key: key);

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(text: 'Movie'),
            Tab(text: 'Tv Series'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          WatchlistMoviesPage(),
          WatchlistTvSeriesPage(),
        ],
      ),
    );
  }
}
