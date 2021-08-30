import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:podcast_overhaul/core/models/discover-extended.dart';
import 'package:podcast_overhaul/ui/custom-widgets/podcast-item.dart';
import 'package:podcast_overhaul/ui/screens/category/category-screen.dart';
import 'package:podcast_overhaul/ui/screens/discover/discrover-provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _current = 0;

  AnimationController _animationController;
  @override
  void initState() {
    super.initState();

    _animationController= AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150)
    );
    Timer(Duration(milliseconds: 2000), () => _animationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [HexColor("#190A05"), HexColor("#870000")],
    begin: const FractionalOffset(0, 0),
    end: const FractionalOffset(1, 1),
    ),
    ),
      child: ChangeNotifierProvider(
        create: (context) => DiscoverProvider(),
        child: Consumer<DiscoverProvider>(
          builder: (context, model, child) => Container(
            alignment: Alignment.center,
            child:
            Container(
              alignment: Alignment.center,
              child: model.loading ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SpinKitWave(
                      color: Color(0xffe7ad29), type: SpinKitWaveType.center),
                ),
              ) : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                      visible: model.noData,
                      child: Container(
                          child: Text("No Podcasts Available :("))),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1,0),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: FadeTransition(
                      opacity: _animationController,
                      child:  Container(
                          child:TextButton.icon(onPressed: () {
                            Navigator.of(context).pushNamed('dialog-category');
                          }, icon: Icon(Icons.arrow_drop_down, color: Colors.white,), label: Text("Categories", style: TextStyle(color: Colors.white)))
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(left: 1, right: 1, top: 30),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 2.0,
                          enlargeCenterPage: false,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                          autoPlay: true,
                        ),
                        items: model.listOfSponsoredPodcasts.map((e) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  model.updateSponsoredPodcastsClicks(
                                    e,
                                  );
                                  Navigator.pushNamed(context, "episode",
                                      arguments: e);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: e.artworkUrl100,
                                  imageBuilder: (context, imageProvider) =>
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          child: Card(
                                              elevation: 5.0,
                                              margin: EdgeInsets.all(16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15.0),
                                              ),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(10),
                                                      image:
                                                      DecorationImage(
                                                        image:
                                                        imageProvider,
                                                        fit: BoxFit.cover,
                                                      ))))),
                                  placeholder: (context, url) =>
                                  new Container(
                                      alignment: Alignment.center,
                                      child:
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                        child: Center(
                                          child: SpinKitWave(
                                              color: Color(0xffe7ad29), type: SpinKitWaveType.center),
                                        ),
                                      )),
                                  errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                    child: PodcastSection(
                      title: "Top Shows",
                      listOfPodcasts: model.listOfPodcasts,
                      arg: DiscoverExtended(
                        title: "Top Shows",
                        listOfPodcasts: model.listOfAllPodcasts,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class PodcastSection extends StatelessWidget {
  final String title;
  final DiscoverExtended arg;
  final List<Item> listOfPodcasts;

  PodcastSection({@required this.title, this.arg, this.listOfPodcasts});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              margin: EdgeInsets.only(left: 15,right: 15),
              child:RichText(
                  text: TextSpan(
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                            text: title.substring(0, 3),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: title.substring(3, title.length))
                      ]))),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'discover-extended', arguments: arg);
            },
            child: Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                child:Text(
                  "View all",
                  style: TextStyle(
                    fontFamily: "Product Sans",
                    fontSize: 15,
                    color: Color(0xFF969696),
                  ),
                )),
          )
        ],
      ),
      //Podcast Item

      //Podcast Item
      Container(
        margin: EdgeInsets.only(top: 30),
        child: CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            initialPage: 3,
            height: 350,
            aspectRatio: 6 / 7,
            enlargeCenterPage: true,
          ),
          items: listOfPodcasts
              .map((e) => Container(
              child: GestureDetector(
                onTap: () =>
                {Navigator.pushNamed(context, "episode", arguments: e)},
                child: Container(
                    child: PodcastItem(
                      podcastInfo: e,
                    )),
              )))
              .toList(),
        ),
      ),
    ]);
  }
}
