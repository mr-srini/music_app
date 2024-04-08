import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nymble_music_app/src/config/themes/app_themes.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/presentation/providers/song_provider.dart';
import 'package:nymble_music_app/src/presentation/views/views.dart';
import 'package:nymble_music_app/src/utils/resources/auth.dart';
import 'package:nymble_music_app/src/utils/resources/firestore.dart';

import 'package:nymble_music_app/src/utils/resources/scaffold_messenger.dart';
import 'package:provider/provider.dart';

class LikeSong extends StatefulWidget {
  final ChartItem song;
  const LikeSong({required this.song, super.key});

  @override
  State<LikeSong> createState() => _LikeSongState();
}

class _LikeSongState extends State<LikeSong> {
  bool isBusy = false;

  bool isLiked = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    toggleIsBusy();
    isLiked = await Firestore.getLikeStatusForSong(
            AuthService.currentUser()?.email,
            "${widget.song.item?.id ?? ""}") ??
        false;

    if (mounted) {
      Provider.of<SongProvider>(context, listen: false)
          .updateSongLikeStatus(widget.song, isLiked);
    }

    toggleIsBusy();
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
    return Consumer<SongProvider>(builder: (context, songState, _) {
      return IconButton(
        onPressed: () async {
          if (AuthService.currentUser()?.email == null) {
            Messenger(context)
                .showSnackBar("Session expired, please login in again");
            context.goNamed(Login.name);
            return;
          }

          toggleIsBusy();

          bool? updated = await Firestore.updateSongLikeStatus(
              AuthService.currentUser()?.email ?? "",
              {"${widget.song.item?.id}": !isLiked});

          if (updated ?? false) {
            isLiked = !isLiked;
            songState.updateSongLikeStatus(widget.song, isLiked);
          } else {
            if (context.mounted) {
              Messenger(context)
                  .showSnackBar("Something went wrong, please retry");
            }
          }

          toggleIsBusy();
        },
        icon: isBusy
            ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.appPrimaryColor,
                ),
              )
            : Icon(
                (((songState.discograpghySongsMap[widget.song] ?? false) ||
                        (songState.popularSongsMap[widget.song] ?? false)))
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                size: 18,
                color: AppTheme.appPrimaryColor,
              ),
      );
    });
  }
}
