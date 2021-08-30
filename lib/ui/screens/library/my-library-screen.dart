import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:podcast_overhaul/ui/custom-widgets/search-bar.dart';
import 'package:podcast_overhaul/ui/screens/library/my-library-provider.dart';
import 'package:provider/provider.dart';

class MyLibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyLibraryScreen();
  }
}

class _MyLibraryScreen extends State<MyLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ChangeNotifierProvider(
                create: (context) => MyLibraryProvider(),
                child: Consumer<MyLibraryProvider>(
                    builder: (context, model, child) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: ListView(children: [
                          Container(
                              child: SearchBar(
                            autoFocus: true,
                            onChanged: (val) {
                                   model.searchPodcasts(val);
                            },
                          )),
                    Container(
                        child: model.noData
                            ? Container(
                          margin:EdgeInsets.all(60),
                          child: Center(
                            child: Text(
                              "You haven't added any podcasts! :(",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                            :Container(
                            margin:EdgeInsets.only(bottom: 100,top: 20),
                            child: ListView.builder(
                                primary: true,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: model.listOfPodcats != null
                                    ? model.listOfPodcats.length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) =>
                                    InkWell(
                                        onTap: () => {
                                          Navigator.pushNamed(context, "episode",
                                              arguments:
                                              model.listOfPodcats[index]).then((value) => model.fetchPodcasts())
                                        },
                                        child: Container(
                                            child: GestureDetector(
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                          child: CachedNetworkImage(
                                                            imageUrl: model.listOfPodcats[index]
                                                                .artworkUrl600,
                                                            imageBuilder: (context,
                                                                imageProvider) =>
                                                                ClipRRect(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        10.0),
                                                                    child: Card(
                                                                        elevation: 5.0,
                                                                        shape:
                                                                        RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(10.0),
                                                                        ),
                                                                        child: Container(
                                                                            height: 90,
                                                                            width: 150,
                                                                            decoration:
                                                                            BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    10),
                                                                                image:
                                                                                DecorationImage(
                                                                                  image:
                                                                                  imageProvider,
                                                                                  fit: BoxFit
                                                                                      .cover,
                                                                                ))))),
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
                                                      Flexible(
                                                          child: Container(
                                                              child: Text(
                                                                model.listOfPodcats[index]
                                                                    .trackName,
                                                                style: TextStyle(color: Colors.white),
                                                              ))),
                                                      Flexible(
                                                          child: Icon(
                                                            Icons.play_circle_filled_rounded,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ))
                                                    ]))))),
                          )
                    )]))))));
  }
}
