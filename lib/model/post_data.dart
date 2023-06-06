import 'dart:convert';
import 'package:intl/intl.dart';

List<PostData> postDataFromJson(String str) =>
    List<PostData>.from(json.decode(str).map((x) => PostData.fromJson(x)));

String postDataToJson(List<PostData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostData {
  PostData({
    required this.id,
    required this.link,
    required this.date,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.categories,
    required this.tags,
    // required this.embedded,
    required this.author,
    required this.banner,
  });

  int id;
  String link;
  DateTime date;
  TitleContent title;
  Content content;
  String author;
  Content excerpt;
  List<int> categories;
  List<int> tags;
  // Embedded embedded;
  String banner;

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
        id: json["id"],
        link: json["link"],
        date: DateTime.parse(json["date"]),
        title: TitleContent.fromJson(json["title"]),
        content: Content.fromJson(json["content"]),
        excerpt: Content.fromJson(json["excerpt"]),
        categories: List<int>.from(json["categories"].map((x) => x)),
        tags: List<int>.from(json["tags"].map((x) => x)),
        banner: json['_embedded']['wp:featuredmedia']?[0]['source_url'] ?? ''
        //  json['_embedded'].containsKey('wp:featuredmedia')
        //     ? json['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']
        //         ['full']['source_url']
        //     : (json['_embedded']['wp:featuredmedia'][0]
        //             .containsKey('media_details')
        //         ? json['_embedded']['wp:featuredmedia'][0]['media_details']
        //             ['sizes']['full']['source_url']
        //         : '')
                ,
        // embedded: Embedded.fromJson(json["_embedded"]),
        author: json['yoast_head_json']['author'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "date": date.toIso8601String(),
        "title": title.toJson(),
        "content": content.toJson(),
        "excerpt": excerpt.toJson(),
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        // "_embedded": embedded.toJson(),
        "author": author,
        "banner": banner,
      };
}

String convertJsonDate(jsonDate) {
  String date = DateFormat.yMMMd().format(jsonDate);

  return date;
}

class Content {
  Content({
    required this.rendered,
    required this.protected,
  });

  String rendered;
  bool protected;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
        "protected": protected,
      };
}

// class Embedded {
//   Embedded({
//     // required this.author,
//     required this.wpFeaturedmedia,
//   });

//   // EmbeddedAuthor author;
//   List<WpFeaturedmedia> wpFeaturedmedia;

//   factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
//         // author:json['yoast_head_json']['author'],
//         wpFeaturedmedia: List<WpFeaturedmedia>.from(
//             json["wp:featuredmedia"].map((x) => WpFeaturedmedia.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         // "author": author,
//         "wp:featuredmedia":
//             List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
//       };
// }

class EmbeddedAuthor {
  EmbeddedAuthor({
    required this.name,
    // required this.avatarUrls,
  });

  String name;
  // Map<String, String> avatarUrls;

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) => EmbeddedAuthor(
        name: json['yoast_head_json']['author'],
        // avatarUrls: Map.from(json['yoast_head_json']['author'])
        //     .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        // "avatar_urls":
        // Map.from(avatarUrls).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class TitleContent {
  TitleContent({
    required this.rendered,
  });

  String rendered;

  factory TitleContent.fromJson(Map<String, dynamic> json) => TitleContent(
        rendered: json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
      };
}

class WpFeaturedmedia {
  WpFeaturedmedia({
    this.mediaDetails,
  });

  MediaDetails? mediaDetails;

  factory WpFeaturedmedia.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmedia(
        mediaDetails: json["media_details"] != null
            ? MediaDetails.fromJson(json["media_details"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "media_details": mediaDetails?.toJson(),
      };
}

class MediaDetails {
  MediaDetails({
    required this.sizes,
  });

  Map<String, PostSize> sizes;

  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
        sizes: Map.from(json["sizes"])
            .map((k, v) => MapEntry<String, PostSize>(k, PostSize.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "sizes": Map.from(sizes)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class PostSize {
  PostSize({
    required this.sourceUrl,
  });

  String sourceUrl;

  factory PostSize.fromJson(Map<String, dynamic> json) => PostSize(
        sourceUrl: json["source_url"],
      );

  Map<String, dynamic> toJson() => {
        "source_url": sourceUrl,
      };
}
