import 'dart:async';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:nymble_music_app/src/utils/resources/firestore.dart';

class HttpService {
  static http.Client httpClient = http.Client();

  static Future<Map<String, String>> get headers async => {
        'X-RapidAPI-Key': await Firestore.getToken() ??
            'ce9086aab6mshb1d02dedc5c8c81p18a115jsn4db251baaa9a',
        'X-RapidAPI-Host': 'genius-song-lyrics1.p.rapidapi.com'
      };
  // static Map<String, String> get headers => {
  //       'X-RapidAPI-Key': 'ce9086aab6mshb1d02dedc5c8c81p18a115jsn4db251baaa9a',
  //       'X-RapidAPI-Host': 'genius-song-lyrics1.p.rapidapi.com'
  //     };

  //
  static Future<http.Response?> get(String url,
      {bool showErrorMessage = true}) async {
    try {
      var response = await httpClient.get(
        Uri.parse(url),
        headers: await HttpService.headers,
      );
      return response;
    } on SocketException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
