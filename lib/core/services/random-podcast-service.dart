import 'dart:math';

import 'package:podcast_overhaul/core/models/player-info.dart';
import 'package:podcast_search/podcast_search.dart';

class RandomPodcastService {
  //Podcast Search element
  Search search = Search();
  //Podcast Search Result
  SearchResult charts;

  Podcast podcast;

  List<Item> listOfPodcasts = [];
  Item randomPodcast;
  Episode randomEpisode;

  Future<PlayerInfo> getPodCasts() async {
    //Get top podcasts
    charts = await search.charts(limit: 37, country: Country.CANADA);
    listOfPodcasts = charts.items;

    Random random = new Random();
    int randomNumber = random.nextInt(listOfPodcasts.length);

    randomPodcast = listOfPodcasts[randomNumber];

      podcast = await Podcast.loadFeed(url: randomPodcast.feedUrl, timeout: 10000);
    randomNumber = random.nextInt(podcast.episodes.length);

    randomEpisode = podcast.episodes[randomNumber];

    return PlayerInfo(item: randomPodcast, episode: randomEpisode);
  }
}
