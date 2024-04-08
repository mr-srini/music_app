import 'dart:developer';

import 'package:flutter/material.dart';

import '../../data/repositories/song_response.dart';

class SongProvider extends ChangeNotifier {
  Map<ChartItem, bool> discograpghySongsMap = {};
  Map<ChartItem, bool> popularSongsMap = {};

  void addDiscograpghySongs(List<ChartItem> songs) {
    log("ADDING ${songs.length}", name: "addDiscograpghySongs");
    for (var song in songs) {
      discograpghySongsMap.addAll({song: false});
    }
    log("ADDED ${popularSongsMap.length}", name: "addDiscograpghySongs");
    notifyListeners();
  }

  void addPopularSongs(List<ChartItem> songs) {
    log("ADDING ${songs.length}", name: "addPopularSongs");
    for (var song in songs) {
      popularSongsMap.addAll({song: false});
    }
    log("ADDED ${popularSongsMap.length}", name: "addPopularSongs");
    notifyListeners();
  }

  void updateSongLikeStatus(ChartItem song, bool isLiked) {
    discograpghySongsMap[song] = isLiked;
    popularSongsMap[song] = isLiked;

    notifyListeners();
  }
}
