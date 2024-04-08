import 'dart:convert';

class SongResponse {
  final List<ChartItem>? chartItems;
  final int? nextPage;

  SongResponse({
    this.chartItems,
    this.nextPage,
  });

  factory SongResponse.fromRawJson(String str) =>
      SongResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongResponse.fromJson(Map<String, dynamic> json) => SongResponse(
        chartItems: json["chart_items"] == null
            ? []
            : List<ChartItem>.from(
                json["chart_items"]!.map((x) => ChartItem.fromJson(x))),
        nextPage: json["next_page"],
      );

  Map<String, dynamic> toJson() => {
        "chart_items": chartItems == null
            ? []
            : List<dynamic>.from(chartItems!.map((x) => x.toJson())),
        "next_page": nextPage,
      };
}

class ChartItem {
  final Item? item;

  ChartItem({
    this.item,
  });

  factory ChartItem.fromRawJson(String str) =>
      ChartItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChartItem.fromJson(Map<String, dynamic> json) => ChartItem(
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "item": item?.toJson(),
      };
}

class Item {
  final String? apiPath;
  final String? artistNames;
  final String? fullTitle;
  final String? headerImageThumbnailUrl;
  final String? headerImageUrl;
  final int? id;
  final String? path;
  final String? releaseDateForDisplay;
  final String? songArtImageUrl;
  final String? title;
  final String? titleWithFeatured;
  final Artist? primaryArtist;

  Item({
    this.apiPath,
    this.artistNames,
    this.fullTitle,
    this.headerImageThumbnailUrl,
    this.headerImageUrl,
    this.id,
    this.path,
    this.releaseDateForDisplay,
    this.songArtImageUrl,
    this.title,
    this.titleWithFeatured,
    this.primaryArtist,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        apiPath: json["api_path"],
        artistNames: json["artist_names"],
        fullTitle: json["full_title"],
        headerImageThumbnailUrl: json["header_image_thumbnail_url"],
        headerImageUrl: json["header_image_url"],
        id: json["id"],
        path: json["path"],
        releaseDateForDisplay: json["release_date_for_display"],
        songArtImageUrl: json["song_art_image_url"],
        title: json["title"],
        titleWithFeatured: json["title_with_featured"],
        primaryArtist: json["primary_artist"] == null
            ? null
            : Artist.fromJson(json["primary_artist"]),
      );

  Map<String, dynamic> toJson() => {
        "api_path": apiPath,
        "artist_names": artistNames,
        "full_title": fullTitle,
        "header_image_thumbnail_url": headerImageThumbnailUrl,
        "header_image_url": headerImageUrl,
        "id": id,
        "path": path,
        "release_date_for_display": releaseDateForDisplay,
        "song_art_image_url": songArtImageUrl,
        "title": title,
        "title_with_featured": titleWithFeatured,
        "primary_artist": primaryArtist?.toJson(),
      };
}

class Artist {
  final String? apiPath;
  final String? headerImageUrl;
  final int? id;
  final String? imageUrl;
  final bool? isMemeVerified;
  final bool? isVerified;
  final String? name;
  final String? slug;
  final String? url;
  final int? iq;

  Artist({
    this.apiPath,
    this.headerImageUrl,
    this.id,
    this.imageUrl,
    this.isMemeVerified,
    this.isVerified,
    this.name,
    this.slug,
    this.url,
    this.iq,
  });

  factory Artist.fromRawJson(String str) => Artist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        apiPath: json["api_path"],
        headerImageUrl: json["header_image_url"],
        id: json["id"],
        imageUrl: json["image_url"],
        isMemeVerified: json["is_meme_verified"],
        isVerified: json["is_verified"],
        name: json["name"],
        slug: json["slug"],
        url: json["url"],
        iq: json["iq"],
      );

  Map<String, dynamic> toJson() => {
        "api_path": apiPath,
        "header_image_url": headerImageUrl,
        "id": id,
        "image_url": imageUrl,
        "is_meme_verified": isMemeVerified,
        "is_verified": isVerified,
        "name": name,
        "slug": slug,
        "url": url,
        "iq": iq,
      };
}
