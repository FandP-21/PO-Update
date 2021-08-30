import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:podcast_overhaul/ui/custom-widgets/search-bar.dart';
import 'package:podcast_overhaul/ui/screens/search/search-provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ChangeNotifierProvider(
            create: (context) => SearchProvider(),
            child: Consumer<SearchProvider>(
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
                      child: ListView.builder(
                          primary: true,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: model.listOfPodcasts != null
                              ? model.listOfPodcasts.length
                              : 0,
                          itemBuilder: (BuildContext context, int index) =>
                              InkWell(
                                  onTap: () => {
                                        Navigator.pushNamed(context, "episode",
                                            arguments:
                                                model.listOfPodcasts[index])
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
                                          imageUrl: model.listOfPodcasts[index]
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
                                          model.listOfPodcasts[index]
                                              .collectionName,
                                          style: TextStyle(color: Colors.white),
                                        ))),
                                        Flexible(
                                            child: Icon(
                                          Icons.play_circle_filled_rounded,
                                          size: 50,
                                          color: Colors.white,
                                        ))
                                      ])))))
                      )
                ]),
              ),
            )));
  }
}
