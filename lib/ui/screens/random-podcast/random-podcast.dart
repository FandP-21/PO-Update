import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:podcast_overhaul/core/models/player-info.dart';
import 'package:podcast_overhaul/core/services/random-podcast-service.dart';
import 'package:podcast_overhaul/ui/custom-widgets/podcast-item.dart';

class RandomPodcast extends StatefulWidget {
  @override
  _RandomPodcastState createState() => _RandomPodcastState();
}

class _RandomPodcastState extends State<RandomPodcast> {
  PlayerInfo _playerInfo;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getRandomPodcast();
  }

  getRandomPodcast() async {
    PlayerInfo info = await RandomPodcastService().getPodCasts();
    setState(() {
      _playerInfo = info;
    });
    if (_playerInfo != null) {
      Navigator.pushNamed(context, 'player', arguments: _playerInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              visible: _playerInfo == null,
              child: SpinKitWave(
                  color: Color(0xffe7ad29), type: SpinKitWaveType.center)),
          SizedBox(height: 10),
          Visibility(
              visible: _playerInfo == null,
              child: Text(
                "Finding Random Podcast",
                style: TextStyle(color: Colors.white),
              )),
          _playerInfo == null
              ? Container()
              : Stack(alignment: Alignment.center, children: [
                  InkWell(
                    onTap: () => {
                      if (_playerInfo != null)
                        {
                          Navigator.pushNamed(context, 'player',
                              arguments: _playerInfo)
                        }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 30, left: 15, right: 15),
                        height: 300,
                        child: PodcastItem(podcastInfo: _playerInfo.item)),
                  )
                ])
        ],
      ),
    );
  }
}
