import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nymble_music_app/src/data/datasources/remote/source.dart';
import 'package:nymble_music_app/src/utils/resources/auth.dart';
import 'package:nymble_music_app/src/utils/resources/hive.dart';

class Firestore {
  static CollectionReference users =
      FirebaseFirestore.instance.collection('user');

  static CollectionReference token =
      FirebaseFirestore.instance.collection('token');

  static Future<bool?> updateSongLikeStatus(
      String userId, Map<String, bool> songLikeStatus) async {
    try {
      await HiveService.write(
          songLikeStatus.keys.toList()[0], songLikeStatus.values.toList()[0]);

      if (await RemoteSource.hasNetwork()) {
        await users.doc(userId).set(songLikeStatus, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<bool?> getLikeStatusForSong(String? userId, String? id) async {
    try {
      if (await RemoteSource.hasNetwork()) {
        var docSnapshot = await users.doc(userId).get();
        if (docSnapshot.exists) {
          Map<String, dynamic>? data =
              docSnapshot.data() as Map<String, dynamic>;

          return (data[id] ?? false) as bool;
        }
      }

      return await HiveService.read("$id");
    } catch (e) {
      log(e.toString(), error: "getLikeStatusForSong");
      return null;
    }
  }

  static Future<String?> getToken() async {
    try {
      if (await RemoteSource.hasNetwork()) {
        var docSnapshot = await token.doc("token").get();
        if (docSnapshot.exists) {
          Map<String, dynamic>? data =
              docSnapshot.data() as Map<String, dynamic>;

          log(data.toString(), name: "getToken");

          if (data["token"] != null) {
            return (data["token"]) as String;
          }
        }
      }
      return null;
    } catch (e) {
      log(e.toString(), error: "getToken");
      return null;
    }
  }

  static Future<void> syncDataFromHiveToFirebase() async {
    try {
      if (AuthService.currentUser() != null) {
        // Read all data from Hive
        Map<String, bool> allData = await HiveService.readAll();

        // Push data to Firebase
        await users
            .doc(AuthService.currentUser()?.email)
            .set(allData, SetOptions(merge: true));
      }
    } catch (e) {
      log(e.toString(), name: "syncDataFromHiveToFirebase");
    }
  }
}
