import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:podcast_overhaul/ui/custom-widgets/base-screen.dart';
import 'package:podcast_overhaul/ui/custom-widgets/gradient-app-bar.dart';
import 'package:podcast_overhaul/ui/screens/community/community-provider.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(18),
      child: ChangeNotifierProvider(
        create: (context) => CommunityProvider(),
        child: Consumer<CommunityProvider>(
          builder: (context, model, child) => Column(
            children: [
              GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, 'episode');
                    model.launchURL(model.podcastOverhaulLink);
                  },
                  child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Image.asset(
                        "assets/static_assets/community-banner.png",
                        fit: BoxFit.fill,
                        height: 100,
                      ))),

              //Learn Podcast section
              LearnPodcastSection(
                onTwitterTap: () {
                  model.launchURL(model.twitterLink);
                },
                onInstagramTap: () {
                  model.launchURL(model.instagramLink);
                },
                onFacebookTap: () {
                  model.launchURL(model.facebookLink);
                },
              ),

              SizedBox(height: 25),
              //Visit Website
              Row(
                children: [
                  CustomIconImage(
                    height: 30,
                    width: 30,
                    marginRight: 6,
                    imageAsset: "assets/static_assets/visit-website-icon.png",
                  ),
                  Text(
                    "VISIT OUR WEBSITE",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              Container(
                  child: GestureDetector(
                onTap: () {
                  model.launchURL(model.websiteLink);
                },
                child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          "assets/static_assets/visit-website-banner.png",
                          fit: BoxFit.fill,
                        ))),
              )),

              MenuItem(
                  title: "SETTINGS",
                  onTap: () {
                    Navigator.pushNamed(context, 'settings');
                  }),
              MenuItem(
                title: "RATE US",
                onTap: () {
                  LaunchReview.launch();
                },
              ),
              GestureDetector(
                onTap: () {
                  model.launchURL(model.webLink);
                },
                child: MenuItem(
                  title: "ABOUT US",
                  subTitle:
                      "Podcast Overhaul is independently owned and is always 100% FREE. To learn more about the app and ways you can support the app, please visit our website. Thank You!",
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class MenuItem extends StatelessWidget {
  final String title, subTitle;
  final Function onTap;

  MenuItem({this.title, this.subTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF707070)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            subTitle != null
                ? Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB0ABAB),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class LearnPodcastSection extends StatelessWidget {
  final Function onTwitterTap, onInstagramTap, onFacebookTap;

  LearnPodcastSection({
    this.onFacebookTap,
    this.onInstagramTap,
    this.onTwitterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //First Row
          Container(
            alignment: Alignment.center,
            child: Text(
              "LEARN HOW TO PODCAST",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 25),
          Row(
            children: [
              //Image
              Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Image.asset(
                    "assets/static_assets/podcast-episodes.png",
                    height: 150,
                    width: 150,
                  )),
              //Second Column
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 11),
                  child: Column(
                    children: [
                      Container(
                        // flex: 2,
                        child: Text(
                          "Podcasting should be simple & easy for everyone. That's why we created Podcast Overhaul. Listen to our podcast to get helpful hints, tips & strategies to help you with your own podcast...All in 10 minutes or less.",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFB0ABAB),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          // CustomIconImage(),
                          CustomIconImage(
                            height: 40,
                            width: 40,
                            marginTop: 10,
                            imageAsset: "assets/static_assets/twitter-icon.png",
                            onTap: onTwitterTap,
                          ),
                          CustomIconImage(
                            height: 40,
                            width: 40,
                            marginTop: 10,
                            marginLeft: 10,
                            imageAsset:
                                "assets/static_assets/instagram-icon.png",
                            onTap: onInstagramTap,
                          ),

                          CustomIconImage(
                            height: 40,
                            width: 40,
                            marginTop: 10,
                            marginLeft: 10,
                            imageAsset: "assets/static_assets/facbook-icon.png",
                            onTap: onFacebookTap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomIconImage extends StatelessWidget {
  final double width, height, marginTop, marginLeft, marginRight;
  final String imageAsset;
  final Function onTap;

  CustomIconImage({
    this.width,
    this.height,
    this.marginLeft = 0.0,
    this.marginTop = 0.0,
    this.marginRight = 0.0,
    this.imageAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          top: marginTop,
          left: marginLeft,
          right: marginRight,
        ),
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageAsset),
          ),
        ),
      ),
    );
  }
}
