import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:podcast_overhaul/core/models/player-info.dart';
import 'package:podcast_overhaul/ui/custom-widgets/base-screen.dart';
import 'package:podcast_overhaul/ui/screens/episode/episode-provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class EpisodeScreen extends StatelessWidget {
  final Item podcastInfo;

  EpisodeScreen({this.podcastInfo});

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
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: ChangeNotifierProvider(
                  create: (context) => EpisodeProvider(podcastInfo),
                  child: Consumer<EpisodeProvider>(
                    builder: (context, model, child) => Container(
                      height: MediaQuery.of(context).size.height,
                      child: model.loading || model.isSubscribed == null
                          ? Container(
                              child: Center(
                                child: SpinKitWave(
                                    color: Color(0xffe7ad29),
                                    type: SpinKitWaveType.center),
                              ),
                            )
                          : CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  expandedHeight: 380.0,
                                  floating: false,
                                  leading: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                            BaseScreen()), (Route<dynamic> route) => false);                                     },
                                      child:Container(
                                        margin: EdgeInsets.only(left:15,right: 15),
                                        width: 45,
                                        height: 45,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      )),                                  pinned: true,
                                  backgroundColor: Colors.transparent,
                                  flexibleSpace: FlexibleSpaceBar(
                                      centerTitle: true,
                                      background: Column(
                                        children: [
                                          Flexible(child:CachedNetworkImage(
                                            imageUrl: podcastInfo.artworkUrl600,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Card(
                                                        elevation: 5.0,
                                                        margin:
                                                            EdgeInsets.all(16),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                        child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 300,
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ))))),
                                            placeholder: (context, url) =>
                                                new Container(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      child: Center(
                                                        child: SpinKitWave(
                                                            color: Color(
                                                                0xffe7ad29),
                                                            type:
                                                                SpinKitWaveType
                                                                    .center),
                                                      ),
                                                    )),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 16, right: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton.icon(
                                              style: ButtonStyle(
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(18.0),
                                          )
                                  ),
                                              backgroundColor: MaterialStateProperty.all(HexColor("#870000"))),
                                                    onPressed:
                                                        model.isSubscribed
                                                            ? () {
                                                                model
                                                                    .unsubPodcast();
                                                              }
                                                            : () {
                                                                model
                                                                    .subscribePodcast();
                                                              },
                                                    label: Text(
                                                      model.isSubscribed
                                                          ? "Unsubscribe"
                                                          : "Subscribe",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),     icon: Icon(
                                                    Icons.unsubscribe_outlined,
                                                    color: Colors.white,
                                                    size: 24.0,
                                                  ),
                                                  ),
                                                  ElevatedButton.icon(
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(18.0),
                                                            )
                                                        ),
                                                          backgroundColor: MaterialStateProperty.all(HexColor("#870000"))),
                                                    onPressed: () {
                                                      model.sharePodcast();
                                                    },
                                                    label: Text(
                                                      "Share",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    icon: Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      )),
                                ),
                                SliverList(
                                  // Use a delegate to build items as they're scrolled on screen.
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, 'player',
                                              arguments: new PlayerInfo(
                                                  item: podcastInfo,
                                                  episode: model.podcast
                                                      .episodes[index]));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: 15, right: 15, top: 10),
                                            child: Wrap(
                                              children: [
                                                Text(
                                                  model.podcast.episodes[index]
                                                      .title,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(child:Text(
                                                          model
                                                              .podcast
                                                              .episodes[index]
                                                              .duration
                                                              .toString()
                                                              .substring(0, 7),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                        Flexible(child:Text(
                                                            model
                                                                .podcast
                                                                .episodes[index]
                                                                .author ?? "",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                        Flexible(child:Text(
                                                          model
                                                              .podcast
                                                              .episodes[index]
                                                              .publicationDate
                                                              .toString()
                                                              .substring(0, 10),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ],
                                                    )),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Divider(
                                                      color: Colors.grey,
                                                    ))
                                              ],
                                            ))),
                                    childCount: model.podcast != null && model.podcast.episodes != null
                                        ? model.podcast.episodes.length
                                        : 0,
                                    // Builds 1000 ListTiles
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ))));
  }
}

Widget mainHeading(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 17,
      color: Colors.white,
      fontFamily: "Sogoe UI",
    ),
  );
}
