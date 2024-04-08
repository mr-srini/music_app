import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/presentation/views/views.dart';
import 'package:nymble_music_app/src/presentation/widgets/like_button.dart';

class PopularSongWidget extends StatefulWidget {
  final ChartItem song;

  const PopularSongWidget({required this.song, super.key});

  @override
  State<PopularSongWidget> createState() => _PopularSongWidgetState();
}

class _PopularSongWidgetState extends State<PopularSongWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.pushNamed(SongDetail.name,
              extra: widget.song,
              pathParameters: {
                "tagName": "P_${widget.song.item?.id}_${widget.song.hashCode}"
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: "P_${widget.song.item?.id}_${widget.song.hashCode}",
                      child: Container(
                        height: 80,
                        width: 120,
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
                                "https://images.genius.com/2f8cae9b56ed9c643520ef2fd62cd378.1000x1000x1.png"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          child: Text(
                            widget.song.item?.title ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
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
                  ],
                ),
                LikeSong(song: widget.song),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
