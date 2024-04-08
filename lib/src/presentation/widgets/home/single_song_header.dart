import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:nymble_music_app/src/data/datasources/remote/source.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';

import 'package:nymble_music_app/src/presentation/views/views.dart';
import 'package:nymble_music_app/src/utils/resources/scaffold_messenger.dart';

class HomeSingleSongHeader extends StatefulWidget {
  const HomeSingleSongHeader({super.key});

  @override
  State<HomeSingleSongHeader> createState() => _HomeSingleSongHeaderState();
}

class _HomeSingleSongHeaderState extends State<HomeSingleSongHeader> {
  SongResponse? songResponse;

  ChartItem? song;

  bool isBusy = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    try {
      toggleIsBusy();
      Map<int?, SongResponse?> response =
          await RemoteSource.getSongs(pageSize: 1, timePeriod: "day");

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

      if (response.values.first != null) {
        songResponse = response.values.first;
        song = songResponse?.chartItems?[0];
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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Hero(
            tag: "SS_${song?.item?.id}_${song?.item?.hashCode}",
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: CachedNetworkImageProvider(
                    song?.item?.headerImageUrl ??
                        "https://images.genius.com/824e10bdd629eea7462980972f342700.1000x1000x1.png",
                  ),
                ),
              ),
              height: MediaQuery.sizeOf(context).height * 0.4,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: isBusy
                  ? LinearProgressIndicator(
                      color: Theme.of(context).hoverColor,
                    )
                  : null,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 10,
                children: [
                  Text(
                    song?.item?.title ?? "",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      color: Theme.of(context).hoverColor,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow_rounded),
                      iconSize: 40,
                      color: const Color(0xff0059DD),
                      onPressed: () {
                        if (song == null) {
                          Messenger(context)
                              .showSnackBar("Song is not ready yet!");

                          return;
                        }

                        context.pushNamed(
                          SongDetail.name,
                          extra: song,
                          pathParameters: {
                            "tagName":
                                "SS_${song?.item?.id}_${song?.item?.hashCode}"
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Positioned.fill(
        //   child: Align(
        //     alignment: Alignment.topCenter,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: SafeArea(
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: [
        //             InkWell(
        //               onTap: () {},
        //               child: const Icon(
        //                 Icons.settings,
        //                 size: 30,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
