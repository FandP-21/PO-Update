import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastItem extends StatelessWidget {
  PodcastItem({this.podcastInfo});
  final Item podcastInfo;
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
         Expanded(child:CachedNetworkImage(
              imageUrl: podcastInfo.artworkUrl600,
              imageBuilder: (context, imageProvider) =>ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child:
                      Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),child:Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,))))),
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
    Text(
        podcastInfo.trackName.length > 60
            ? podcastInfo.trackName.substring(0, 45) + "..."
            : podcastInfo.trackName,
        style: TextStyle(
          fontFamily: "Product Sans",
          fontSize: 18,
          color: Color(0xFFEDE6E7),
        ),
      ),
    Text(
        podcastInfo.artistName.length > 30
            ? podcastInfo.artistName.substring(0, 27) + "..."
            : podcastInfo.artistName,
        style: TextStyle(
          fontFamily: "Product Sans",
          fontSize: 12,
          color: Color(0xFF969696),
        ),
      ),
        ],
    );
  }
}
