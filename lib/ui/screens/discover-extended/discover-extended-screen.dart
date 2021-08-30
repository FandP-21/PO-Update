import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:podcast_overhaul/core/models/discover-extended.dart';
import 'package:podcast_overhaul/ui/screens/discover-extended/discover-extended-provider.dart';
import 'package:provider/provider.dart';

class DiscoverExtendedScreen extends StatelessWidget {
  final DiscoverExtended arg;

  DiscoverExtendedScreen({this.arg});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [HexColor("#190A05"), HexColor("#870000")],
            begin: const FractionalOffset(0, 0),
            end: const FractionalOffset(1, 1),
          ),
        ),
        child: ChangeNotifierProvider(
          create: (context) => DiscoverExtendedProvider(),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Consumer<DiscoverExtendedProvider>(
                  builder: (context, model, child) => model.loading
                      ? Center(
                          child: SpinKitWave(
                              color: Color(0xffe7ad29),
                              type: SpinKitWaveType.center),
                        )
                      : CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              expandedHeight: 350.0,
                              floating: false,
                              pinned: true,
                              backgroundColor: Colors.transparent,
                              flexibleSpace: FlexibleSpaceBar(
                                  centerTitle: true,
                                  background: Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child:Column(
                                    children: [
                                      Expanded(
                                          child: CachedNetworkImage(
                                        imageUrl: model
                                            .sponsoredPodcast.artworkUrl600,
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Card(
                                                    elevation: 5.0,
                                                    margin: EdgeInsets.all(16),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: InkWell(
                                                        onTap: () => {
                                                        Navigator.pushNamed(context, "episode", arguments: model.sponsoredPodcast)
                                                        },
                                                        child:Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )))))),
                                        placeholder: (context, url) =>
                                            new Container(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  child: Center(
                                                    child: SpinKitWave(
                                                        color:
                                                            Color(0xffe7ad29),
                                                        type: SpinKitWaveType
                                                            .center),
                                                  ),
                                                )),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      )),
                                    ],
                                  ))),
                            ),
                            SliverList(
                              // Use a delegate to build items as they're scrolled on screen.
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) => Container(
                                        child:GestureDetector(
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(child:CachedNetworkImage(
                                                imageUrl: arg.listOfPodcasts[index].artworkUrl600,
                                                imageBuilder: (context, imageProvider) =>ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    child:
                                                    Card(
                                                        elevation: 5.0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),child:Container(
                                                        height: 90,
                                                        width: 150,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            image: DecorationImage(
                                                              image: imageProvider,
                                                              fit: BoxFit.cover,))))),
                                                placeholder: (context, url) => new Container(
                                                    alignment: Alignment.center,
                                                    child:Container(
                                                      child: Center(
                                                        child: SpinKitWave(
                                                            color: Color(0xffe7ad29), type: SpinKitWaveType.center),
                                                      ),
                                                    )),
                                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                              )),
                                              Flexible(child:Container(child:Text(arg.listOfPodcasts[index].collectionName, style: TextStyle(color: Colors.white),))),
                                              Flexible(child:Icon(Icons.play_circle_filled_rounded, size: 50, color: Colors.white,))
                                            ]

                                            ,),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "episode",
                                                arguments: arg.listOfPodcasts[index]);
                                          },
                                        )),
                                childCount: arg.listOfPodcasts != null
                                    ? arg.listOfPodcasts.length
                                    : 0,
                                // Builds 1000 Lis
                                // cotTiles
                              ),
                            ),
                          ],
                        ))
              ),
        )));
  }
}
