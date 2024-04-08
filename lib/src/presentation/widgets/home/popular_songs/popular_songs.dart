import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nymble_music_app/src/data/datasources/remote/source.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/presentation/providers/song_provider.dart';
import 'package:nymble_music_app/src/presentation/widgets/home/popular_songs/popular_song_widget.dart';
import 'package:nymble_music_app/src/utils/resources/scaffold_messenger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PopularSongs extends StatefulWidget {
  final ScrollController homeScrollController;
  const PopularSongs({required this.homeScrollController, super.key});

  @override
  State<PopularSongs> createState() => _PopularSongsState();
}

class _PopularSongsState extends State<PopularSongs> {
  SongResponse? songResponse;
  int page = 1;
  bool isBusy = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    try {
      widget.homeScrollController.addListener(() async {
        if (widget.homeScrollController.position.atEdge) {
          if (widget.homeScrollController.position.pixels != 0) {
            page += 1;

            await getSongs();
          }
        }
      });

      await getSongs();
    } catch (e) {
      log(e.toString());
    }
  }

  Future getSongs() async {
    try {
      toggleIsBusy();
      Map<int?, SongResponse?> response = await RemoteSource.getSongs(
          pageSize: 10, timePeriod: "all_time", page: page);

      if (response.keys.first == 429 && mounted) {
        Messenger(context).showSnackBar(
            "You have exceeded the MONTHLY quota for Requests on your current plan");
        toggleIsBusy();
        return;
      }

      if (response.keys.first != 200 && mounted) {
        Messenger(context).showSnackBar("Something went wrong, try again");
        toggleIsBusy();
        return;
      }

      if (response.values.first != null && mounted) {
        songResponse = response.values.first;
        Provider.of<SongProvider>(context, listen: false)
            .addDiscograpghySongs(songResponse?.chartItems ?? []);
      }

      toggleIsBusy();
    } catch (e) {
      log(e.toString());
    }
  }

  toggleIsBusy() {
    if (context.mounted) {
      setState(() {
        isBusy = !isBusy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isBusy &&
            Provider.of<SongProvider>(context, listen: false)
                .popularSongsMap
                .isEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                10,
                (index) => SizedBox(
                  // width: 180.0,
                  height: 100.0,
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).scaffoldBackgroundColor,
                    highlightColor: Theme.of(context).hoverColor,
                    child: Container(
                      width: double.infinity,
                      height: 200.0,
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : songResponse == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star_outline_rounded,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Popular Songs",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ...(Provider.of<SongProvider>(context, listen: false)
                            .popularSongsMap
                            .keys
                            .toList())
                        .map(
                      (song) => PopularSongWidget(
                        song: song,
                      ),
                    ),
                    if (isBusy)
                      ...List.generate(
                        3,
                        (index) => SizedBox(
                          // width: 180.0,
                          height: 100.0,
                          child: Shimmer.fromColors(
                            baseColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            highlightColor: Theme.of(context).hoverColor,
                            child: Container(
                              width: double.infinity,
                              height: 200.0,
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
  }
}
