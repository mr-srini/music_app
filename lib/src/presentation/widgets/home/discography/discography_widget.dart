import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';

import 'package:nymble_music_app/src/presentation/views/song_detail/song_detail.dart';
import 'package:nymble_music_app/src/presentation/widgets/like_button.dart';
import 'package:nymble_music_app/src/utils/resources/auth.dart';
import 'package:nymble_music_app/src/utils/resources/firestore.dart';

class DiscographyWidget extends StatefulWidget {
  final ChartItem song;
  const DiscographyWidget({required this.song, super.key});

  @override
  State<DiscographyWidget> createState() => _DiscographyWidgetState();
}

class _DiscographyWidgetState extends State<DiscographyWidget> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.pushNamed(SongDetail.name,
              extra: widget.song,
              pathParameters: {
                "tagName": "D_${widget.song.item?.id}_${widget.song.hashCode}"
              });
        },
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: "D_${widget.song.item?.id}_${widget.song.hashCode}",
                child: Container(
                  width: 200,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        12,
                      ),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(widget
                              .song.item?.headerImageUrl ??
                          "https://images.genius.com/7aa3bebecdfc0a7f9140c479bcb52182.1000x1000x1.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.song.item?.title ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          widget.song.item?.releaseDateForDisplay ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                  LikeSong(song: widget.song)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
