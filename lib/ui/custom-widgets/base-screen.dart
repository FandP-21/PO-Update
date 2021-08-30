import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:podcast_overhaul/ui/screens/community/community-screen.dart';
import 'package:podcast_overhaul/ui/screens/discover/discover-screen.dart';
import 'package:podcast_overhaul/ui/screens/library/my-library-screen.dart';
import 'package:podcast_overhaul/ui/screens/player/player-provider.dart';
import 'package:podcast_overhaul/ui/screens/player/player-screen.dart';
import 'package:podcast_overhaul/ui/screens/random-podcast/random-podcast.dart';
import 'package:podcast_overhaul/ui/screens/search/search-screen.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

var index = 0;
class BaseScreen extends StatefulWidget {
  final bool showNavbar;
  final Widget child;
  final String currentScreen;
  final PreferredSizeWidget appBar;

  BaseScreen({
    this.child,
    this.showNavbar = true,
    this.currentScreen,
    this.appBar,
  });

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen>{
  int duration = 0;

  PageController pageController = PageController(initialPage: index,keepPage: true);


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
            appBar: widget.appBar,
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Consumer<PlayerProvider>(
                builder: (context, model, child) => Container(
                    margin: EdgeInsets.only(
                        bottom: model.playerTimeNow.inSeconds != 0 ? 30 : 0),
                    alignment: Alignment.center,
                    child: PageView(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        KeepAlivePage(child:SingleChildScrollView(child: DiscoverScreen())),
                        KeepAlivePage(child: SearchScreen()),
                        RandomPodcast(),
                        MyLibraryScreen(),
                        KeepAlivePage(child:SingleChildScrollView(child: CommunityScreen())),
                      ],
                    ))),
            bottomNavigationBar: Consumer<PlayerProvider>(
              builder: (context, model, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (model.playerTimeNow != Duration(seconds: 0))
                    GestureDetector(
                      onTap: () {
                        Episode ep = context.read<PlayerProvider>().episode;
                        Item podcast =
                            context.read<PlayerProvider>().podcastInfo;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              podcastInfo: podcast,
                              episode: ep,
                              startAgain: false,
                            ),
                          ),
                        );
                      },
                      child: Column(children: [
                        Card(
                            margin: EdgeInsets.all(0),
                            shape: const ContinuousRectangleBorder(
                              borderRadius: BorderRadius.only(),
                            ),
                            color: HexColor("#190A05"),
                            child: Container(
                                height: 100,
                                child: Column(children: [
                                  SizedBox(
                                    width: double.infinity,
                                      child:ProgressBar(
                                    timeLabelLocation: TimeLabelLocation.none,
                                    progressBarColor: Colors.white,
                                    baseBarColor: Colors.grey,
                                    thumbColor: Colors.transparent,
                                    progress: model.playerTimeNow,
                                    total: model.playerLength,
                                    onSeek: (duration) {
                                      model.seekBar(duration);
                                    },
                                  )),
                                  Flexible(
                                      child: Container(
                                          margin: EdgeInsets.only(left:10,right: 10),
                                          child:Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(child:AspectRatio(aspectRatio: 1/1,
                                          child:Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    model.podcastInfo.artworkUrl600),
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ))),
                                          Flexible(child:Row(
                                            children: [
                                              Flexible(child:Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            model.title ?? "",
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            textAlign:
                                                            TextAlign.start,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                          constraints: BoxConstraints(maxWidth: 150),
                                                          margin: EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            model.episodeName,
                                                            maxLines: 1,  softWrap: false,
                                                            textAlign:
                                                            TextAlign.start,
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ))),
                                            ],
                                          )),
                                          Container(
                                            child: //Pause and Play Button
                                            IconButton(
                                              iconSize: 40,
                                              icon: Icon(
                                                model.isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                if (model.isPlaying) {
                                                  model.pause();
                                                  print("Paused");
                                                } else {
                                                  model.resume();
                                                  print("Played");
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: //Pause and Play Button
                                            IconButton(
                                              iconSize: 40,
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () async {
                                                await model.pause();
                                                model.playerTimeNow =
                                                    Duration(seconds: 0);
                                                model.setState();
                                              },
                                            ),
                                          )
                                        ],
                                      )))
                                ])))
                      ],),
                    ),
                  Container(
                      child: CustomNavBar(
                    currentScreen: widget.currentScreen,
                    pageController: pageController,
                  )),
                ],
              ),
            )));
  }
}

class CustomNavBar extends StatefulWidget {
  final String currentScreen;
  final PageController pageController;

  CustomNavBar({this.currentScreen, this.pageController});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      elevation: 10,
      backgroundColor: HexColor("#190A05"),
      style: TabStyle.reactCircle,
      items: [
        TabItem(
            icon: BottomNavItem(
          imageAsset: widget.currentScreen == "discover"
              ? "assets/static_assets/discover-icon-selected.png"
              : "assets/static_assets/discover-icon.png",
        )),
        TabItem(icon: Icons.search),
        TabItem(
          icon: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/static_assets/logo.png"),
              ),
            ),
          ),
        ),
        TabItem(
            icon: BottomNavItem(
          imageAsset: widget.currentScreen == "category"
              ? "assets/static_assets/category-icon-selected.png"
              : "assets/static_assets/category-icon.png",
        )),
        TabItem(
          icon: BottomNavItem(
            imageAsset: widget.currentScreen == "community"
                ? "assets/static_assets/community-icon-selected.png"
                : "assets/static_assets/community-icon.png",
          ),
        )
      ],
      initialActiveIndex:index,
      onTap: (int i) => {
        setState(()=> {
          index = i
        }),
        widget.pageController.animateToPage(i,
            duration: Duration(milliseconds: 200), curve: Curves.bounceIn)
      },
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final imageAsset;

  BottomNavItem({this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAsset),
        ),
      ),
    );
  }
}

class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
