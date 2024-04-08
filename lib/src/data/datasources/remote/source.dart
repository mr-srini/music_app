import 'dart:developer';
import 'dart:io';
import 'package:nymble_music_app/src/data/datasources/local/source.dart';
import 'package:nymble_music_app/src/data/repositories/search_response.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/utils/resources/http.dart';

class RemoteSource {
  static const String baseUrl = "https://genius-song-lyrics1.p.rapidapi.com";

  static Future<Map<int?, SongResponse?>> getSongs(
      {int pageSize = 10, int page = 1, String timePeriod = "month"}) async {
    try {
      if (await hasNetwork()) {
        var response = await HttpService.get(
            "$baseUrl/chart/songs/?time_period=$timePeriod&per_page=$pageSize&page=$page");
        if (response?.statusCode != 200) return {response?.statusCode: null};
        return {200: SongResponse.fromRawJson(response?.body ?? "{}")};
      }
      return {200: await LocalSource.getSongs()};
    } catch (e) {
      log(e.toString());
      return {400: null};
    }
  }

  static Future<Map<int?, SearchSongResponse?>> searchSongs(
      {int pageSize = 10, int page = 1, required String query}) async {
    try {
      if (await hasNetwork()) {
        var response = await HttpService.get(
            "$baseUrl/search/?q=$query&per_page=$pageSize&page=$page");

        if (response?.statusCode != 200) return {response?.statusCode: null};

        return {200: SearchSongResponse.fromRawJson(response?.body ?? "{}")};
      }
      return {200: await LocalSource.searchSongs(query: query)};
    } catch (e) {
      log(e.toString());
      return {400: null};
    }
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
