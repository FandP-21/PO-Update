import 'package:flutter/material.dart';
import 'package:podcast_overhaul/core/services/firebase.dart';
import 'package:podcast_search/podcast_search.dart';

class DiscoverExtendedProvider extends ChangeNotifier {
  Item sponsoredPodcast;
  bool loading = true;

  DiscoverExtendedProvider() {
    fetchSponsoredPodcast();
  }

  fetchSponsoredPodcast() async {
    sponsoredPodcast =
        await FirebaseService().getSingleSponsoredPodcast('top-shows');
    loading = false;
    notifyListeners();
  }

  updateSponsoredPodcastsClicks(Item e) {
    FirebaseService().updateSinglePodcastClicks(e.guid);
  }
}
