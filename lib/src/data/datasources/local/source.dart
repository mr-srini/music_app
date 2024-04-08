import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:nymble_music_app/src/data/repositories/search_response.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';

class LocalSource {
  static const String baseUrl = "https://genius-song-lyrics1.p.rapidapi.com";

  static Future<SongResponse?> getSongs(
      {int pageSize = 10, int page = 1, String timePeriod = "month"}) async {
    try {
      final String response =
          await rootBundle.loadString('assets/dataJsons/song.json');

      return SongResponse.fromRawJson(response);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<SearchSongResponse?> searchSongs(
      {int pageSize = 10, int page = 1, required String query}) async {
    try {
      final String response =
          await rootBundle.loadString('assets/dataJsons/songSearch.json');

      return SearchSongResponse.fromRawJson(response);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
