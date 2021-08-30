import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityProvider extends ChangeNotifier {
  String facebookLink = "https://www.facebook.com/podcastoverhaul";
  String twitterLink = "https://twitter.com/PodcastOverhaul";
  String instagramLink = "https://www.instagram.com/podcastoverhaul/";
  String websiteLink = "https://www.podcastoverhaul.com/";
  String webLink = "https://www.podcastoverhaul.com/";
  String podcastOverhaulLink =
      "https://www.podcastoverhaul.com/podcast";

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
