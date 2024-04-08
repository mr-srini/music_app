import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nymble_music_app/src/config/themes/app_themes.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/presentation/widgets/like_button.dart';

class SongDetail extends StatefulWidget {
  static const String name = "songDetail";
  final ChartItem song;
  final String heroTagName;
  const SongDetail({required this.song, required this.heroTagName, super.key});

  @override
  State<SongDetail> createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  bool isSongPLaying = false;
  late AudioPlayer player;

  @override
  void initState() {
    player = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _play() {
    if (isSongPLaying) {
      player.pause();
    } else {
      player.play(AssetSource('music.mp3'));
    }

    if (context.mounted) {
      setState(() {
        isSongPLaying = !isSongPLaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LikeSong(song: widget.song),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(),
            Hero(
              tag: widget.heroTagName,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      12,
                    ),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget
                            .song.item?.headerImageUrl ??
                        "https://images.genius.com/2f8cae9b56ed9c643520ef2fd62cd378.1000x1000x1.png"),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.song.item?.title ?? "--",
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.song.item?.artistNames ?? "--",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                    color: Theme.of(context).hoverColor,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isSongPLaying ? Icons.pause : Icons.play_arrow_rounded,
                      color: AppTheme.appPrimaryColor,
                    ),
                    iconSize: 60,
                    onPressed: _play,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
