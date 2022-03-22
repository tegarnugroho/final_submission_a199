import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalName: "Original Name",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    name: "name",
    originalLanguage: 'en',
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);
  group('fromJson', () {
    test('should return a valid Tv Series model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing_tv_series.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            'poster_path': '/path.jpg',
            'popularity': 1.0,
            'id': 1,
            'backdrop_path': '/path.jpg',
            'vote_average': 1.0,
            'overview': 'Overview',
            'genre_ids': [1, 2, 3, 4],
            'original_language': 'en',
            'vote_count': 1,
            'name': 'name',
            'original_name': 'Original Name'
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
