import 'package:podcast_search/podcast_search.dart';

class PodcastHelper {
  itemFromJson(Map<String, dynamic> json) {
    return Item(
      artistId: json['artistId'] as int,
      collectionId: json['collectionId'] as int,
      trackId: json['trackId'] as int,
      guid: json['guid'] ?? "",
      artistName: json['artistName'] ?? "",
      collectionName: json['collectionName'] ?? "",
      collectionExplicitness: json['collectionExplicitness'] ?? "",
      trackExplicitness: json['trackExplicitness'] ?? "",
      trackName: json['trackName'] ?? "",
      trackCount: json['trackCount'] as int,
      collectionCensoredName: json['collectionCensoredName'] ?? "",
      trackCensoredName: json['trackCensoredName'] ?? "",
      artistViewUrl: json['artistViewUrl'] ?? "",
      collectionViewUrl: json['collectionViewUrl'] ?? "",
      feedUrl: json['feedUrl'] ?? "",
      trackViewUrl: json['trackViewUrl'] ?? "",
      artworkUrl30: json['artworkUrl30'] ?? "",
      artworkUrl60: json['artworkUrl60'] ?? "",
      artworkUrl100: json['artworkUrl100'] ?? "",
      artworkUrl600: json['artworkUrl600'] ?? "",
      //Ignore these for now
      // genre: Item._loadGenres(
      //     json['genreIds'].cast<String>(), json['genres'].cast<String>()),
      releaseDate: DateTime.parse(json['releaseDate']),
      country: json['country'] ?? "",
      primaryGenreName: json['primaryGenreName'] ?? "",
      contentAdvisoryRating: json['contentAdvisoryRating'] ?? "",
    );
  }

  itemFromCustomJson(Map<String, dynamic> json) {
    return Item(
      artistName: json['artistName'] ?? "",
      trackName: json['trackName'] ?? "",
      feedUrl: json['feedUrl'] ?? "",
      artworkUrl600: json['artworkUrl600'] ?? "",
    );
  }
}
