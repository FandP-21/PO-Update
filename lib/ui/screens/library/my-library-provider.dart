import 'package:flutter/material.dart';
import 'package:podcast_overhaul/core/services/sqlite-database.dart';
import 'package:podcast_search/podcast_search.dart';

class MyLibraryProvider extends ChangeNotifier {
  List<Item> listOfPodcats;
  List<Item> subscribedPodcasts = [];
  SqliteDatabase dbService = SqliteDatabase();

  bool loading = true, noData = false;

  MyLibraryProvider() {
    fetchPodcasts();
  }

  fetchPodcasts() async {
    loading = true;
    notifyListeners();

    listOfPodcats = await dbService.getSubscribedPodcasts();
    subscribedPodcasts.addAll(listOfPodcats);
  //  print(listOfPodcats.length.toString());

    loading = false;
    if (listOfPodcats.length < 1) noData = true;
    notifyListeners();
  }

  searchPodcasts(String value) async {
    listOfPodcats = subscribedPodcasts.where((element) => element.trackName.toLowerCase().contains(value.toLowerCase())).toList();
    notifyListeners();
  }


}
