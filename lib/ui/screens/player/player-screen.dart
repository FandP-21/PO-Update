import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:podcast_overhaul/core/models/player-info.dart';
import 'package:podcast_overhaul/ui/screens/episode/episode-provider.dart';
import 'package:podcast_overhaul/ui/screens/player/player-provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  final Episode episode;
  final Item podcastInfo;
  final bool startAgain;

  PlayerScreen({
    this.episode,
    this.podcastInfo,
    this.startAgain = true,
  });

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlayerProvider>().link = widget.episode.contentUrl;
    context.read<PlayerProvider>().playerLength = widget.episode.duration;
    context.read<PlayerProvider>().episodeName = widget.episode.title;
    context.read<PlayerProvider>().title = widget.podcastInfo.collectionName;

    context.read<PlayerProvider>().episodeThumbnail =
        widget.podcastInfo.artworkUrl100;
    context.read<PlayerProvider>().episode = widget.episode;
    context.read<PlayerProvider>().podcastInfo = widget.podcastInfo;
    if (widget.startAgain) context.read<PlayerProvider>().play();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, providerModel, child) {
        return  Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [HexColor("#190A05"), HexColor("#870000")],
                    begin: const FractionalOffset(0, 0),
                    end: const FractionalOffset(1, 1),
                  ),
                ),
                child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      leading: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
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
                          )),
                    ),
                    backgroundColor: Colors.transparent,
                    body: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(child:CachedNetworkImage(
                            imageUrl: widget.podcastInfo.artworkUrl600,
                            imageBuilder: (context, imageProvider) =>ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child:
                                Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),child:Container(
                                  height:350,
                                    width:350,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fitHeight,))))),
                            placeholder: (context, url) => new Container(
                                alignment: Alignment.center,
                                child:Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                    child: SpinKitWave(
                                        color: Color(0xffe7ad29), type: SpinKitWaveType.center),
                                  ),
                                )),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                          )),
                          //Player Controls
                          Container(
                              margin:
                                  EdgeInsets.only(top: 30, left: 15, right: 15),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.podcastInfo.trackName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                              )),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 15, right: 15),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.episode.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                            ),
                            height: 180,
                            child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Visibility(
                                          visible: providerModel.isAudioLoading,
                                          child: SpinKitWave(
                                              color: Color(0xffe7ad29),
                                              type: SpinKitWaveType.center),),
                                      Flexible(
                                        child: Slider(
                                          min: 0,
                                          activeColor: Color(0xffe7ad29),
                                          inactiveColor: Color(0xFF707070),
                                          value: providerModel.playerBarValue <
                                                      0 ||
                                                  providerModel.playerBarValue >
                                                      1
                                              ? (providerModel.playerBarValue <
                                                      0
                                                  ? 0.0
                                                  : 1.0)
                                              : providerModel.playerBarValue,
                                          onChanged: (val) {
                                            providerModel.seekFromBar(val);
                                            print(val);
                                          },
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //current time
                                              Row(
                                                children: [
                                                  Text(
                                                    //  "${model.playerTimeNow.inM}"
                                                    providerModel.playerTimeNow
                                                                .inMinutes <
                                                            1
                                                        ? "0${providerModel.playerTimeNow.inMinutes}"
                                                        : "${providerModel.playerTimeNow.inMinutes}",
                                                    //    ":" +
                                                    //      (model.playerTimeNow.inSeconds < 10 ? "0${model.playerTimeNow.inSeconds}" : "${model.playerTimeNow.inSeconds}"),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    ":",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    (providerModel.playerTimeNow
                                                                .inSeconds <
                                                            10
                                                        ? "0${providerModel.playerTimeNow.inSeconds % 60}"
                                                        : "${providerModel.playerTimeNow.inSeconds % 60}"),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              //Remaining time
                                              Text(
                                                providerModel
                                                        .playerLength.inMinutes
                                                        .toString() +
                                                    ":" +
                                                    (providerModel.playerLength
                                                                .inSeconds %
                                                            60)
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                        child: Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //Previous Button
                                              IconButton(
                                                icon: Container(
                                                  width: 23,
                                                  height: 23,
                                                  child: Icon(
                                                    Icons.list_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  OpenList();
                                                },
                                              ),
                                              IconButton(
                                                icon: Container(
                                                  width: 23,
                                                  height: 17,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/static_assets/play-previous-icon.png"),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  providerModel.backword();
                                                },
                                              ),
                                              //Pause and Play Button
                                              IconButton(
                                                iconSize: 70,
                                                icon: Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(70),
                                                    ),
                                                    border: Border.all(
                                                      color: Color(0xffe7ad29),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    providerModel.isPlaying
                                                        ? Icons.pause
                                                        : Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 40,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (providerModel.isPlaying) {
                                                    providerModel.pause();
                                                    print("Paused");
                                                  } else {
                                                    providerModel.resume();
                                                    print("Played");
                                                  }
                                                },
                                              ),
                                              //Next Button
                                              IconButton(
                                                icon: Container(
                                                  width: 23,
                                                  height: 17,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/static_assets/play-next-icon.png"),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  providerModel.forward();
                                                },
                                              ),
                                              IconButton(
                                                icon: Container(
                                                  width: 23,
                                                  height: 23,
                                                  child: Icon(
                                                    Icons.speed_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return StatefulBuilder(
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        state) {
                                                          return Container(
                                                              color:
                                                                  Colors.black,
                                                              height: 100,
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            providerModel.speed(0.5);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              InkWell(
                                                                            child:
                                                                                Ink(
                                                                              color: Color(0xffe7ad29),
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Colors.black.withOpacity(0.5), border: Border.all(color: Color(0xFFD4AB3A))),
                                                                                  height: 60,
                                                                                  width: 60,
                                                                                  child: Center(
                                                                                    child: Text('0.5x', style: TextStyle(color: Color(0xFFD4AB3A))),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            providerModel.speed(1.0);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Colors.black.withOpacity(0.5), border: Border.all(color: Color(0xFFD4AB3A))),
                                                                              height: 60,
                                                                              width: 60,
                                                                              child: Center(
                                                                                child: Text('1x', style: TextStyle(color: Color(0xFFD4AB3A))),
                                                                              )),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            providerModel.speed(1.25);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Colors.black.withOpacity(0.5), border: Border.all(color: Color(0xFFD4AB3A))),
                                                                              height: 60,
                                                                              width: 60,
                                                                              child: Center(
                                                                                child: Text('1.25x', style: TextStyle(color: Color(0xFFD4AB3A))),
                                                                              )),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            providerModel.speed(1.5);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Colors.black.withOpacity(0.5), border: Border.all(color: Color(0xFFD4AB3A))),
                                                                              height: 60,
                                                                              width: 60,
                                                                              child: Center(
                                                                                child: Text('1.5x', style: TextStyle(color: Color(0xFFD4AB3A))),
                                                                              )),
                                                                        )
                                                                      ]),
                                                                ),
                                                              ));
                                                        });
                                                      });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ]),
                          ),
                        ],
                      ),
                    )));
      },
    );
  }

  OpenList() {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return ChangeNotifierProvider(
            create: (context) => EpisodeProvider(widget.podcastInfo),
            child: Consumer<EpisodeProvider>(
              builder: (context, model, child) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Header Image

                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                model.loading
                                    ? Container(
                                        child: Center(
                                          child: SpinKitWave(
                                              color: Color(0xffe7ad29)),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Subscribe button
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  EdgeInsets.only(bottom: 6),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color(0xFF707070),
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: RichText(
                                                  text: new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text: 'Next up ',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              Color(0xffe7ad29),
                                                          fontFamily:
                                                              "Sogoe UI",
                                                        ),
                                                      ),
                                                      new TextSpan(
                                                          text:
                                                              '(${model.podcast.episodes.length} episodes)',
                                                          style: new TextStyle(
                                                              color: Color(
                                                                  0xFF707070))),
                                                    ],
                                                  ),
                                                ),
                                              )),

                                          Column(
                                            children: model.podcast.episodes
                                                .map<Widget>(
                                                  (e) => Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                widget
                                                                    .podcastInfo
                                                                    .artworkUrl600),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10,
                                                                top: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: Color(
                                                                  0xFF707070),
                                                            ),
                                                          ),
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            print('test');
                                                            print(widget
                                                                .podcastInfo);
                                                            print('debug');
                                                            print(e);
                                                            Navigator.pushNamed(
                                                              context,
                                                              'player',
                                                              arguments:
                                                                  new PlayerInfo(
                                                                item: widget
                                                                    .podcastInfo,
                                                                episode: e,
                                                              ),
                                                            );
                                                          },
                                                          child: mainHeading(
                                                              e.title, context),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: 150,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          );
        });
  }
}

Widget mainHeading(String text, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.yellow,
        fontFamily: "Sogoe UI",
      ),
    ),
  );
}
