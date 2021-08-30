import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

// import 'package:podcast_overhaul/core/constants.dart';
import 'package:podcast_overhaul/core/models/gardient-category.dart';
import 'package:podcast_overhaul/ui/custom-widgets/base-screen.dart';
import 'package:podcast_overhaul/ui/custom-widgets/gradient-app-bar.dart';
import 'package:podcast_overhaul/ui/custom-widgets/search-bar.dart';
import 'package:podcast_overhaul/ui/screens/category/category-provider.dart';
import 'package:provider/provider.dart';

class CategoryScreenDialog extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => HexColor("#870000").withOpacity(0.9);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      color: Colors.blue,
      shadowColor: Colors.blue,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return CategoryScreen();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final List<GradientCategory> listOfGradientCategories = [
    GradientCategory(
      name: "Arts",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Business",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Comedy",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Sports",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "True Crime",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "News",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Health & Fitness",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Music",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "TV & Film",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "History",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Education",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Religion",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Technology",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Kids & Family",
      gradientColors: [Colors.green, Colors.pink],
    ),
    GradientCategory(
      name: "Fiction",
      gradientColors: [Colors.green, Colors.pink],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(19),
      child: ChangeNotifierProvider(
        create: (context) => CategoryProvider(),
        child: Consumer<CategoryProvider>(
          builder: (context, model, child) => model.loading
              ? Center(
                  child: SpinKitWave(
                      color: Color(0xffe7ad29), type: SpinKitWaveType.center),
                )
              : ListView(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      model.sponsoredPodcast != null
                          ? GestureDetector(
                              onTap: () {
                                model.updateSponsoredPodcastsClicks(
                                  model.sponsoredPodcast,
                                );
                                Navigator.pushNamed(
                                  context,
                                  "episode",
                                  arguments: model.sponsoredPodcast,
                                );
                              },
                              child: Container(
                                  height: 250,
                                  child:CachedNetworkImage(
                                imageUrl: model.sponsoredPodcast.artworkUrl600,
                                imageBuilder: (context, imageProvider) =>
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Card(
                                            elevation: 5.0,
                                            margin: EdgeInsets.only(top:16,bottom: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Container(
                                                height: 250,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ))))),
                                placeholder: (context, url) => new Container(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Center(
                                        child: SpinKitWave(
                                            color: Color(0xffe7ad29),
                                            type: SpinKitWaveType.center),
                                      ),
                                    )),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              )),
                            )
                          : Container(),
                      if (listOfGradientCategories.length > 0)
                        ...listOfGradientCategories
                            .map<Widget>(
                              (e) => CategoryListItem(
                                text: e.name,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    'category-podcasts',
                                    arguments: e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                    ],
                  ),
        ),
      ),
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final String text;
  final Function onTap;

  CategoryListItem({this.text = "", this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 13, bottom: 8),
        width: MediaQuery.of(context).size.height,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF707070).withOpacity(0.35)),
          ),
        ),
      ),
    );
  }
}
