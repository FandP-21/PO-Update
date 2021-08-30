import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast_overhaul/core/services/podcast-helper.dart';
import 'package:podcast_search/podcast_search.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getSponsoredPodcasts() {
    return firestore.collection('sponsored').snapshots();
  }

  Future<Item> getSingleSponsoredPodcast(String field) async {
    return await firestore
        .collection('sponsored')
        .doc(field)
        .get()
        .then((value) {
      if (value.exists) {
        Item podcast = PodcastHelper().itemFromJson(value.data());
        Item newPodcast = Item(
          collectionName: podcast.collectionName,
          trackName: podcast.trackName,
          artistName: podcast.artistName,
          artworkUrl600: podcast.artworkUrl600,
          feedUrl: podcast.feedUrl,
          guid: value.id,
          artworkUrl100: podcast.artworkUrl100,
        );
        return newPodcast;
      } else
        return null;
    });
  }

  updateSinglePodcastClicks(String id) async {
    print(id);
    await firestore
        .collection('sponsored')
        .doc(id)
        .update({'clicks': FieldValue.increment(1)});
  }

  Future<String> addPodcastForInvite(Item podcast) async {
    return await firestore.collection('podcast-invites').add({
      'trackName': podcast.trackName,
      'artistName': podcast.artistName,
      'artworkUrl600': podcast.artworkUrl600,
      'feedUrl': podcast.feedUrl,
    }).then((value) {
      return value.id;
    }).catchError((err) {
      print("Error while adding podcast Ivite: " + err.toString());
    });
  }

  Future<Item> getPodcastFromInvite(String id) async {
    return await firestore
        .collection('podcast-invites')
        .doc(id)
        .get()
        .then((value) {
      if (value.exists) {
        Item podcasts = PodcastHelper().itemFromCustomJson(value.data());
        Item newPodcast = new Item(
          trackName: podcasts.trackName,
          artistName: podcasts.artistName,
          artworkUrl600: podcasts.artworkUrl600,
          feedUrl: podcasts.feedUrl,
        );
        return newPodcast;
      }
    }).catchError((err) {
      print("Error getPodcastFromInvite@Firebase: " + err.toString());
    });
  }
}
