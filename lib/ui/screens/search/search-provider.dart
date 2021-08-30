import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';

class SearchProvider extends ChangeNotifier {
  var search = Search();
  SearchResult results;
  List<Item> listOfPodcasts;

  bool loading = false, noData = false;

  searchPodcasts(String term) async {
    //update state before loading
    loading = true;
    noData = false;
    notifyListeners();

    /// Search for podcasts with term in the title.
    results = await search.search(term, limit: 12);

    /// List the name of each podcast found.
    results.items?.forEach((result) {
      print("Found podcast: ${result.collectionName}");
    });

    listOfPodcasts = results.items;
    //Update state after loading
    loading = false;
    if (listOfPodcasts.length < 1) noData = true;
    notifyListeners();
  }
}
