import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static late Box<Map> likedSongsBox;

  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      likedSongsBox = await Hive.openBox("likedSongs");
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<bool> read(String songId) async {
    Map songData = likedSongsBox.get(songId) ?? {};
    if (songData.values.isNotEmpty) {
      return songData.values.first;
    } else {
      return false;
    }
  }

  static Future<void> write(String songId, bool isLiked) async {
    await likedSongsBox.put(songId, {songId: isLiked});
  }

  static Future<Map<String, bool>> readAll() async {
    Map<String, bool> allSongsLikedStatus = {};

    for (var songId in likedSongsBox.keys) {
      allSongsLikedStatus[songId] = await read(songId);
    }

    return allSongsLikedStatus;
  }
}
