import 'package:flutter/material.dart';
import 'package:podcast_overhaul/core/services/firebase.dart';
import 'package:podcast_overhaul/core/services/podcast-helper.dart';
import 'package:podcast_search/podcast_search.dart';

class DiscoverProvider extends ChangeNotifier {
  //Podcast Search element
  Search search = Search();
  //Podcast Search Result
  SearchResult charts;
  //List of Podcasts
  List<Item> listOfPodcasts = [];
  List<Item> listOfAllPodcasts;
  List<Item> listOfSponsoredPodcasts = [];
  bool sponsoredLoaded = false;

  //Setup
  bool loading = true, noData = false;

  //Constructor
  DiscoverProvider() {
    getPodCasts();
    getSponsoredPodcast();
  }

  getPodCasts() async {
    //Get top podcasts
    try {
      charts = await search.charts(limit: 16, country: Country.UNITED_KINGDOM);
    } catch (e) {
      print("Error while getting podcasts: " + e.toString());
    }

    listOfAllPodcasts = charts.items;
    print(listOfAllPodcasts.length);
    for (int i = 0; i < 10; i++) {
      listOfPodcasts.add(listOfAllPodcasts[i]);
    }
    print(listOfPodcasts.length);

    //Update state
    loading = false;
    if (listOfPodcasts.length < 1) noData = true;
    notifyListeners();
  }

  getSponsoredPodcast() {
    FirebaseService().getSponsoredPodcasts().listen((event) {
      if (event.docs.isNotEmpty) {
        event.docs.forEach((element) {
          if (element.id != 'top-shows' && element.id != 'categories') {
            Item podcasts = PodcastHelper().itemFromJson(element.data());
            Item newPodcast = Item(
              collectionName: podcasts.collectionName,
              trackName: podcasts.trackName,
              artistName: podcasts.artistName,
              artworkUrl600: podcasts.artworkUrl600,
              feedUrl: podcasts.feedUrl,
              guid: element.id,
              artworkUrl100: podcasts.artworkUrl100,
            );
            listOfSponsoredPodcasts.add(newPodcast);
          }
        });
      }
      sponsoredLoaded = true;
      notifyListeners();
    });
  }

  printSponsored() {
    print(listOfSponsoredPodcasts.length.toString());
    listOfSponsoredPodcasts.forEach((element) {
      print(element);
    });
  }

  updateSponsoredPodcastsClicks(Item e) {
    FirebaseService().updateSinglePodcastClicks(e.guid);
  }
}
