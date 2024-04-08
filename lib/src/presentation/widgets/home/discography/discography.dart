import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nymble_music_app/src/data/datasources/remote/source.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/presentation/providers/song_provider.dart';
import 'package:nymble_music_app/src/presentation/widgets/home/discography/discography_widget.dart';
import 'package:nymble_music_app/src/utils/resources/scaffold_messenger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Discography extends StatefulWidget {
  const Discography({super.key});

  @override
  State<Discography> createState() => _DiscographyState();
}

class _DiscographyState extends State<Discography> {
  SongResponse? songResponse;

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
          await RemoteSource.getSongs(pageSize: 20, timePeriod: "week");

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
    return isBusy
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                10,
                (index) => SizedBox(
                  width: 180.0,
                  height: 200.0,
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
                          Icons.music_note_outlined,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Discography",
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            (Provider.of<SongProvider>(context, listen: false)
                                    .discograpghySongsMap
                                    .keys
                                    .toList())
                                .map(
                                  (song) => DiscographyWidget(
                                    song: song,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              );
  }
}
