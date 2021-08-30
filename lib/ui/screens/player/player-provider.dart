import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';

class PlayerProvider extends ChangeNotifier {
  final player = AssetsAudioPlayer();
  String link;
  Duration playerTimeNow = Duration(seconds: 0);
  Duration playerLength;
  double playerBarValue = 0.0;
  Episode episode;
  Item podcastInfo;

  String episodeName, episodeThumbnail, title;

  bool isPlaying = false;

  bool isAudioLoading = false;

  PlayerProvider() {
    updateState();
  }

  play() async {
    print("Started Playing");
    // Stop previous playing
    player.stop();
    playerTimeNow = Duration(seconds: 0);
    isPlaying = false;
    isAudioLoading = true;

    // link = updateLinkToHttps(link);
    print(link);
    final audio = Audio.network(
      link,
      metas: Metas(
        title: podcastInfo.collectionName,
        artist: podcastInfo.artistName,
        album: podcastInfo.trackName,
        image: MetasImage.network(podcastInfo.artworkUrl600),
        //can be MetasImage.network
      ),
    );

    var duration = await player.open(
      audio,
      showNotification: true,
      notificationSettings: NotificationSettings(
          //seekBarEnabled: false,
          //stopEnabled: true,
          //customStopAction: (player){
          //  player.stop();
          //}
          //prevEnabled: false,
          customNextAction: (player) {
        print("next1");
        forward();
      }, customPrevAction: (player) {
        print("next2");
        backword();
      }
          //customStopIcon: AndroidResDrawable(name: "ic_stop_custom"),
          //customPauseIcon: AndroidResDrawable(name:"ic_pause_custom"),
          //customPlayIcon: AndroidResDrawable(name:"ic_play_custom"),
          ),
    );
    isPlaying = true;
    isAudioLoading = false;

    // player.play(); // Usually you don't want to wait for playback to finish.
    print("started");
    setState();
  }

  pause() async {
    await player.pause();
    isPlaying = false;
    print("paused");
    setState();
  }

  resume() async {
    //TODO: Setup resume
    await player.seek(playerTimeNow);
    player.play();
    isPlaying = true;
  }

  speed(double val) async {
    print("Value is $val");
    await player.setPlaySpeed(val);
    isPlaying = true;
  }

  updateState() {
    player.currentPosition.listen((event) {
      playerTimeNow = event;
      updatePlayerBar();
    });
  }

  updatePlayerBar() {
    int totalLengthInMilliSeconds = playerLength.inMilliseconds;
    int totalPlayedInMilliSeconds = playerTimeNow.inMilliseconds;
    double newPlayerBarValue =
        totalPlayedInMilliSeconds / totalLengthInMilliSeconds;
    playerBarValue = newPlayerBarValue;
    // print(playerBarValue);
    // print(playerTimeNow);
    // print(playerLength);
    // print(playerLength);
    // if (playerLength == playerTimeNow) {
    //   print('Finish');
    //   player.stop();
    // }

    notifyListeners();
  }

  forward() async {
    //TODO: Check if at-least 10 seconds are left;
    if (playerTimeNow + Duration(seconds: 10) < playerLength)
      await player.seek(playerTimeNow + Duration(seconds: 10));
    else
      await player.seek(playerLength);
    print("Forwarded 10 seconds");
  }

  backword() async {
    Duration back = playerTimeNow.inSeconds > 10
        ? playerTimeNow - Duration(seconds: 10)
        : Duration(seconds: 0);
    await player.seek(back);
    print("Backwarded 10 seconds");
  }

  seekFromBar(double val) async {
    double totalMillis = playerLength.inMilliseconds * val;
    int newMillis = totalMillis.toInt();
    Duration newSeekLocations = Duration(milliseconds: newMillis);
    await player.seek(newSeekLocations);
  }

  seekBar(Duration duration) async {
    await player.seek(duration);
  }

  setState() {
    notifyListeners();
  }
}
