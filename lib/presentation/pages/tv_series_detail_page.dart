import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-series';

  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesDetailBloc>().add(OnFecthTvSeriesDetail(widget.id));
      context
          .read<WatchlistTvSeriesBloc>()
          .add(FetchWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAddedToWatchlist = context.select<WatchlistTvSeriesBloc, bool>(
        (bloc) => (bloc.state is IsAddedToWatchlistTvSeries)
            ? (bloc.state as IsAddedToWatchlistTvSeries).isAdded
            : false);
    return Scaffold(
      body: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
        builder: (context, state) {
          if (state is TvSeriesDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvSeriesDetailSuccess) {
            return SafeArea(
              child: DetailContent(
                isAddedToWatchlist,
                tvSeries: state.detail,
                recommendations: state.recommendations,
              ),
            );
          } else if (state is TvSeriesDetailError) {
            return Text(state.message);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class DetailContent extends StatefulWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  bool isAddedWatchlist;

  DetailContent(
    this.isAddedWatchlist, {
    Key? key,
    required this.tvSeries,
    required this.recommendations,
  }) : super(key: key);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  final messageWatchlistAddSuccess = 'Added to Watchlist';
  final messageWatchlistRemoveSuccess = 'Removed from Watchlist';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${widget.tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tvSeries.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (!widget.isAddedWatchlist) {
                                  context.read<WatchlistTvSeriesBloc>().add(
                                      AddToWatchlistTvSeries(widget.tvSeries));
                                } else {
                                  context.read<WatchlistTvSeriesBloc>().add(
                                      RemoveFromWatchlistTvSeries(
                                          widget.tvSeries));
                                }

                                final message = context.select<
                                    WatchlistTvSeriesBloc,
                                    String>((value) => (value.state
                                        is IsAddedToWatchlistTvSeries)
                                    ? (value.state as IsAddedToWatchlistTvSeries)
                                                .isAdded ==
                                            false
                                        ? messageWatchlistAddSuccess
                                        : messageWatchlistRemoveSuccess
                                    : !widget.isAddedWatchlist
                                        ? messageWatchlistAddSuccess
                                        : messageWatchlistRemoveSuccess);

                                if (message == messageWatchlistAddSuccess ||
                                    message == messageWatchlistRemoveSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }

                                setState(() {
                                  widget.isAddedWatchlist =
                                      !widget.isAddedWatchlist;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tvSeries.genres),
                            ),
                            Row(
                              children: [
                                Text(
                                    '${widget.tvSeries.numberOfSeasons} Seasons'),
                                SizedBox(width: 10),
                                Text(
                                    '${widget.tvSeries.numberOfEpisodes} Episodes'),
                              ],
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tvSeries.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tvSeries.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvSeriesDetailBloc,
                                TvSeriesDetailState>(
                              builder: (context, data) {
                                if (data is TvSeriesDetailLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data is TvSeriesDetailError) {
                                  return Text(data.message);
                                } else if (data is TvSeriesDetailSuccess) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie =
                                            widget.recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: widget.recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
