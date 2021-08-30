import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:podcast_overhaul/core/services/firebase.dart';
import 'package:podcast_overhaul/core/services/sqlite-database.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:share/share.dart';

class EpisodeProvider extends ChangeNotifier {
  Item podcastInfo;
  Podcast podcast;
  bool loading = true;
  bool isSubscribed;

  SqliteDatabase dbService = SqliteDatabase();

  EpisodeProvider(Item podcastInfo) {
    this.podcastInfo = podcastInfo;
    print(podcastInfo.toString());
    fetchPodcast();
    checkIfSubscribed();
  }

  fetchPodcast() async {
    podcast = await Podcast.loadFeed(url: podcastInfo.feedUrl);
    loading = false;
    notifyListeners();
  }

  subscribePodcast() async {
    await dbService.addToSubscribedPodcasts(podcastInfo);
    isSubscribed = true;
    notifyListeners();
  }

  unsubPodcast() async {
    await dbService.deletePodcast(podcastInfo.trackName);
    isSubscribed = false;
    notifyListeners();
  }

  checkIfSubscribed() async {
    try {
      isSubscribed =
      await dbService.checkIfPodcastIsSubscribed(podcastInfo.trackName);
    } catch(e) {
      print("Error is $e");
    }
    notifyListeners();
  }

  sharePodcast() async {
    String podcastId = await FirebaseService().addPodcastForInvite(podcastInfo);
    print(podcastId);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // This should match firebase but without the username query param
      uriPrefix: 'https://podcastoverhaul.page.link',
      // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
      link: Uri.parse('https://podcastoverhaul.page.link/invite?id=$podcastId'),
      androidParameters: AndroidParameters(
        packageName: 'com.podcastoverhaul.app',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.podcastoverhaul.app',
        minimumVersion: '1',
        appStoreId: '',
      ),
    );
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    Share.share(shortenedLink.shortUrl.toString());
  }
}
