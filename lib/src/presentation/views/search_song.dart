import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nymble_music_app/src/data/datasources/remote/source.dart';
import 'package:nymble_music_app/src/data/repositories/search_response.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/presentation/widgets/home/popular_songs/popular_song_widget.dart';
import 'package:nymble_music_app/src/presentation/widgets/text_form_filed.dart';
import 'package:nymble_music_app/src/utils/resources/scaffold_messenger.dart';

class SearchSong extends StatefulWidget {
  static const String name = "searchSong";
  const SearchSong({super.key});

  @override
  State<SearchSong> createState() => _SearchSongState();
}

class _SearchSongState extends State<SearchSong> {
  late TextEditingController searchController;
  bool isBusy = false;
  SearchSongResponse? songResponse;
  List<ChartItem> songs = [];
  Timer? _debounce;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  toggleIsBusy() {
    if (context.mounted) {
      setState(() {
        isBusy = !isBusy;
      });
    }
  }

  Future loadSongs() async {
    try {
      if (searchController.text.isNotEmpty) {
        toggleIsBusy();
        Map<int?, SearchSongResponse?> response =
            await RemoteSource.searchSongs(
          query: searchController.text,
          pageSize: 20,
        );

        if (response.keys.first == 429 && mounted) {
          Messenger(context).showSnackBar(
              "You have exceeded the MONTHLY quota for Requests on your current plan");
          return;
        }

        if (response.keys.first != 200 && mounted) {
          Messenger(context).showSnackBar("Something went wrong, try again");
          return;
        }

        if (response.values.first != null) {
          songResponse = response.values.first;
          // ignore: avoid_function_literals_in_foreach_calls
          (songResponse?.hits ?? []).forEach((song) {
            songs.add(ChartItem(item: song.result));
          });
        }

        toggleIsBusy();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            AppTextFormField(
              key: const Key("search_form_field"),
              autofocus: songs.isEmpty,
              controller: searchController,
              perfixIcon: Icons.search,
              name: "Search",
              perfixIconColor: Theme.of(context).shadowColor,
              hintStyle: Theme.of(context).textTheme.displayMedium,
              onChange: (_) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () async {
                  await loadSongs();
                });
              },
            ),
            if (isBusy) const LinearProgressIndicator(),

            // const ChoiceChip(label: Text("Song"), selected: true),
            if (songs.isEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  LottieBuilder.network(
                      "https://lottie.host/6ee87a13-db93-40af-8cca-6432caf8b38d/6xU3HsIVzJ.json"),
                ],
              ),

            if (songs.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      PopularSongWidget(song: songs[index]),
                  separatorBuilder: (__, _) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: songs.length,
                ),
              )
          ],
        ),
      ),
    );
  }
}
