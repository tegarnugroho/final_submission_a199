import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesModel extends Equatable {
  TvSeriesModel({
    required this.posterPath,
    required this.popularity,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.genreIds,
    required this.originalLanguage,
    required this.voteCount,
    required this.name,
    required this.originalName,
  });

  final String? posterPath;
  final double popularity;
  final int id;
  final String? backdropPath;
  final double voteAverage;
  final String overview;
  final List<int> genreIds;
  final String originalLanguage;
  final int voteCount;
  final String name;
  final String originalName;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        popularity: json["popularity"].toDouble(),
        id: json["id"],
        backdropPath:
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        originalLanguage: json["original_language"],
        voteCount: json["vote_count"],
        name: json["name"],
        originalName: json["original_name"],
      );

  Map<String, dynamic> toJson() => {
        "poster_path": posterPath,
        "popularity": popularity,
        "id": id,
        "backdrop_path": backdropPath,
        "vote_average": voteAverage,
        "overview": overview,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "original_language": originalLanguage,
        "vote_count": voteCount,
        "name": name,
        "original_name": originalName,
      };

  TvSeries toEntity() {
    return TvSeries(
        posterPath: this.posterPath,
        popularity: this.popularity,
        id: this.id,
        backdropPath: this.backdropPath,
        voteAverage: this.voteAverage,
        overview: this.overview,
        genreIds: this.genreIds,
        originalLanguage: this.originalLanguage,
        voteCount: this.voteCount,
        name: this.name,
        originalTitle: this.originalName);
  }

  @override
  List<Object?> get props => [
        posterPath,
        popularity,
        id,
        backdropPath,
        voteAverage,
        overview,
        genreIds,
        originalLanguage,
        voteCount,
        name,
        originalName,
      ];
}
