import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:podcast_overhaul/core/services/firebase.dart';
import 'package:podcast_overhaul/ui/custom-widgets/base-screen.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences prefs;
  @override
  void initState() {
    this.initDynamicLinks();
    setupNotifications();
    super.initState();
  }

  setupNotifications() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('notifications') == null) {
      await FirebaseMessaging.instance.subscribeToTopic('android');
      await prefs.setBool('notifications', true);
    }
  }

  void initDynamicLinks() async {
    try {
      print("Checking dynamic links");
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        String myId = deepLink.queryParameters['id'];

        if (deepLink != null) {
          if (myId != null) {
            try {
              Item podcastInfo =
                  await FirebaseService().getPodcastFromInvite(myId);
               Navigator.pushNamed(context, 'episode', arguments: podcastInfo);
         //     Get.offAll(BaseScreen());
       //       Get.to(EpisodeScreen(podcastInfo: podcastInfo));
            } catch (e) {
            }
          }
        } else {
          Future.delayed(Duration(milliseconds: 1500), () {
            return Navigator.of(context).pushReplacement(
              FadeRoute(
                page:BaseScreen(),
              ),
            );
          });
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });

      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        String myId = deepLink.queryParameters['id'];
        if (myId != null) {
          Item podcastInfo = await FirebaseService().getPodcastFromInvite(myId);
          Navigator.pushNamed(context, 'episode', arguments: podcastInfo);
        }
      } else {
        Future.delayed(Duration(milliseconds: 1500), () {
          return Navigator.of(context).pushReplacement(
            FadeRoute(
              page: BaseScreen(),
            ),
          );
        });
      }
    } catch (e) {
      print("Got erro while gettin dynamic link" + e.toString());
    }
  }

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
    ));
    // return BaseScreen(
    //   showNavbar: false,
    //   child: Container(
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    //     // color: Colors.red,
    //     child: Column(
    //       children: [
    //         Container(
    //           margin:
    //               EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
    //           width: 280,
    //           height: 280,
    //           decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: AssetImage("assets/static_assets/logo.png"),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           width: 120,
    //           height: 70,
    //           margin:
    //               EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
    //           decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: AssetImage("assets/static_assets/logo-worded.png"),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

//Animation Route for SplashScreen
class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
