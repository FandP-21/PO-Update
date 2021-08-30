import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:podcast_overhaul/core/models/gardient-category.dart';
import 'package:podcast_overhaul/ui/screens/category/category-provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class CategoryPodcastsScreen extends StatelessWidget {
  final GradientCategory gradientCategory;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CategoryPodcastsScreen({this.gradientCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [HexColor("#190A05"), HexColor("#870000")],
            begin: const FractionalOffset(0, 0),
            end: const FractionalOffset(1, 1),
          ),
        ),
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            body: ChangeNotifierProvider(
                create: (context) =>
                    CategoryProvider(categoryName: gradientCategory.name),
                child: Consumer<CategoryProvider>(
                    builder: (context, model, child) => model.loading
                        ? Center(
                            child: SpinKitWave(
                                color: Color(0xffe7ad29),
                                type: SpinKitWaveType.center),
                          )
                        : CustomScrollView(
                            // Add the app bar and list of items as slivers in the next steps.
                            slivers: <Widget>[
                                SliverAppBar(
                                  floating: false,
                                  backgroundColor: Colors.transparent,
                                  pinned: true,
                                ),
                                SliverList(
                                  // Use a delegate to build items as they're scrolled on screen.
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => GestureDetector(
                                      onTap: () => {
                                      Navigator.pushNamed(context, "episode",
                                      arguments:model.listOfPodcasts[index])
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 15, right: 15, top: 30),
                                          height: 300,
                                          child: PodcastCategoryItem(
                                            model.listOfPodcasts[index],
                                          )),
                                    ),
                                    childCount: model.listOfPodcasts.length,
                                    // Builds 1000 ListTiles
                                  ),
                                ),
                              ])))));
  }
}

class PodcastCategoryItem extends StatelessWidget {
  final Item podcastInfo;

  PodcastCategoryItem(this.podcastInfo);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: podcastInfo.artworkUrl600,
      imageBuilder: (context, imageProvider) => ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
              child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(child:Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ))),
                      SizedBox(
                          width: double.infinity,
                          child: Container(
                              decoration: new BoxDecoration(
                                  border:
                                      new Border.all(color: Colors.transparent),
                                  //color is transparent so that it does not blend with the actual color specified
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(15)),
                                  color: HexColor("#870000").withOpacity(
                                      0.9) // Specifies the background color and the opacity
                                  ),
                              child: Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Container(
                                    width: 250,
                                      margin: EdgeInsets.only(
                                          left: 15,
                                          bottom: 10,
                                          top: 10,
                                          right: 15),
                                      child: Text(
                                        podcastInfo.trackName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 15,
                                          bottom: 10,
                                          top: 10,
                                          right: 15),
                                      child: Text(podcastInfo.artistName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                                  Visibility(
                                      visible:
                                          podcastInfo.contentAdvisoryRating !=
                                              null,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 15,
                                              bottom: 10,
                                              top: 10,
                                              right: 15),
                                          child: Row(children: <Widget>[
                                            Text(
                                              podcastInfo
                                                      .contentAdvisoryRating ??
                                                  "",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.star_border_sharp,
                                              color: Colors.yellowAccent,
                                            )
                                          ])))
                                ],
                              )))
                    ],
                  ))))),
      placeholder: (context, url) => new Container(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitWave(
                  color: Color(0xffe7ad29), type: SpinKitWaveType.center),
            ),
          )),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
  }
}
