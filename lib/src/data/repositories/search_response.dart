import 'dart:convert';

import 'package:nymble_music_app/src/data/repositories/song_response.dart';

class SearchSongResponse {
  final List<Hit>? hits;

  SearchSongResponse({
    this.hits,
  });

  factory SearchSongResponse.fromRawJson(String str) =>
      SearchSongResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchSongResponse.fromJson(Map<String, dynamic> json) =>
      SearchSongResponse(
        hits: json["hits"] == null
            ? []
            : List<Hit>.from(json["hits"]!.map((x) => Hit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hits": hits == null
            ? []
            : List<dynamic>.from(hits!.map((x) => x.toJson())),
      };
}

class Hit {
  final Item? result;

  Hit({
    this.result,
  });

  factory Hit.fromRawJson(String str) => Hit.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hit.fromJson(Map<String, dynamic> json) => Hit(
        result: json["result"] == null ? null : Item.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
      };
}
