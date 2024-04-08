import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nymble_music_app/src/presentation/providers/theme_provider.dart';
import 'package:nymble_music_app/src/presentation/views/search_song.dart';
import 'package:nymble_music_app/src/presentation/views/views.dart';
import 'package:nymble_music_app/src/presentation/widgets/home/discography/discography.dart';
import 'package:nymble_music_app/src/presentation/widgets/home/popular_songs/popular_songs.dart';
import 'package:nymble_music_app/src/presentation/widgets/home/single_song_header.dart';
import 'package:nymble_music_app/src/utils/resources/firestore.dart';
import 'package:nymble_music_app/src/utils/resources/scaffold_messenger.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String name = "home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController scrollController;

  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    scrollController = ScrollController();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      if (result.contains(ConnectivityResult.none) && mounted) {
        //
        Messenger(context).showSnackBar(
          "No internet connection",
          duration: const Duration(days: 1),
          isFloating: false,
        );
        //
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        await Firestore.syncDataFromHiveToFirebase();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform.scale(
            scale: 0.8,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Settings",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Dark Mode",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(fontSize: 20),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    activeColor: const Color(0xff0059DD),
                                    activeTrackColor:
                                        Colors.white.withOpacity(0.7),
                                    value: Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .isDark,
                                    onChanged: (_) {
                                      Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .changeAppThemeMode();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Logout",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(fontSize: 20),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.goNamed(Login.name);
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              child: const Icon(
                Icons.settings,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              onPressed: () {
                context.pushNamed(SearchSong.name);
              },
              child: const Icon(
                Icons.search,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const HomeSingleSongHeader(),
            const SizedBox(
              height: 10,
            ),
            const Discography(),
            const SizedBox(
              height: 10,
            ),
            PopularSongs(
              homeScrollController: scrollController,
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
