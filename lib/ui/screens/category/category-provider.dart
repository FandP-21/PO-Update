import 'package:flutter/material.dart';
import 'package:podcast_overhaul/core/services/firebase.dart';
import 'package:podcast_search/podcast_search.dart';

class CategoryProvider extends ChangeNotifier {
  String categoryName;
  Item sponsoredPodcast;
  bool loading = true;
  List<Item> listOfPodcasts;
  var search = Search();
  SearchResult results;

  List<String> listOfCategories = [
    "Design",
    "Arts",
    "Fashion & Beauty",
    "Food",
    "Entrepreneurship",
    "Management",
    "Investing",
    "Marketing",
    "Self-Improvement",
    "Health",
    "Fitness",
    "Medicine",
    "Mental Health",
    "Nutrition",
    "Sexuality",
    "Music",
    "Technology",
    "News"
  ];

  CategoryProvider({this.categoryName}) {
    if (categoryName != null)
      fetchCategoryPodcasts();
    else
      fetchSponsoredPodcast();
  }

  fetchSponsoredPodcast() async {
    sponsoredPodcast =
        await FirebaseService().getSingleSponsoredPodcast('categories');

    loading = false;
    notifyListeners();
  }

  fetchCategoryPodcasts() async {
    /// Search for podcasts with term in the title.
    results = await search.search(categoryName, limit: 18);

    /// List the name of each podcast found.
    results.items?.forEach((result) {
      print("Found podcast: ${result.collectionName}");
    });

    listOfPodcasts = results.items;
    //Update state after loading
    loading = false;
    notifyListeners();
  }

  updateSponsoredPodcastsClicks(Item e) {
    FirebaseService().updateSinglePodcastClicks(e.guid);
  }
}
