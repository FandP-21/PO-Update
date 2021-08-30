import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:podcast_overhaul/ui/custom-widgets/base-screen.dart';
import 'package:podcast_overhaul/ui/custom-widgets/gradient-app-bar.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var notificationsSwitch = false;
  var mobileDataUsageSwitch = false;
  SharedPreferences prefs;

  @override
  void initState() {
    notificationsSwitch = false;
    mobileDataUsageSwitch = false;
    checkforNotifications();
    super.initState();
  }

  shareApp() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // This should match firebase but without the username query param
      uriPrefix: 'https://podcastoverhaul.page.link',
      // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
      link: Uri.parse('https://podcastoverhaul.page.link/'),
      androidParameters: AndroidParameters(
        packageName: 'com.podcastoverhaul.app',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.podcastoverhaul.app',
        minimumVersion: '1',
        appStoreId: '',
      ),
    );
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    Share.share(shortenedLink.shortUrl.toString());
  }

  checkforNotifications() async {
    prefs = await SharedPreferences.getInstance();
    print("Prefs is ${prefs.getBool('notifications')}");
    setState(() {
      notificationsSwitch = prefs.getBool('notifications');
    });
  }

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
                body: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () => {
                                  Navigator.pop(context),
                                },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            )),
                        SizedBox(height: 30,),
                        Card(
                            color: HexColor("#190A05"),
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/static_assets/logo-worded.png",
                                  fit: BoxFit.cover,
                                  height: 200,
                                ))),
                        SizedBox(height: 30,),
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.only(bottom: 8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF707070).withOpacity(0.35),
                              ),
                            ),
                          ),
                          child: Text(
                            "GENERAL",
                            style: TextStyle(
                              color: Color(0xFFBF7575),
                            ),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: CustomSettingSwitch(
                              notificationsSwitch: notificationsSwitch,
                              title: "Notifications",
                              onSwitchChange: (val) async {
                                notificationsSwitch = val;
                                await prefs.setBool('notifications', val);
                                setState(() {});

                                if (val) {
                                  await FirebaseMessaging.instance.subscribeToTopic('android');
                                  print("Subscribed");
                                } else {
                                  await FirebaseMessaging.instance.unsubscribeFromTopic('android');
                                  print("Unsubscribed");
                                }
                              },
                            )),
                        SizedBox(height: 30,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.only(bottom: 8),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Color(0xFF707070).withOpacity(0.35),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "FEEDBACK",
                                  style: TextStyle(
                                    color: Color(0xFFBF7575),
                                  ),
                                ),
                              ),
                              FeedbackSubItem(
                                title: "Contact Us",
                                onTap: () => launch(
                                    'https://www.podcastoverhaul.com/contact-us'),
                              ),
                              FeedbackSubItem(
                                title: "Share this app",
                                onTap: () {
                                  shareApp();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                    // CustomAppBar(title: "SETTINGS"),
                    //Settings Section
                    //     Container(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //
                    //           Expanded(
                    //               child:SwitcherButton(
                    //             value: false,
                    //             onChange: (value) {
                    //
                    //             },
                    //           )),
                    //     //       // Expanded(
                    //     //       //     flex:1,
                    //     //       //     child:CustomSettingSwitch(
                    //     //       //   notificationsSwitch: notificationsSwitch,
                    //     //       //   title: "Notifications",
                    //     //       //   onSwitchChange: (val) async {
                    //     //       //     notificationsSwitch = val;
                    //     //       //     if (val) {
                    //     //       //       await FirebaseMessaging.instance.subscribeToTopic('android');
                    //     //       //       print("Subscribed");
                    //     //       //     } else {
                    //     //       //       await FirebaseMessaging.instance.unsubscribeFromTopic('android');
                    //     //       //       print("Unsubscribed");
                    //     //       //     }
                    //     //       //     await prefs.setBool('notifications', val);
                    //     //       //     setState(() {});
                    //     //       //   },
                    //     //       // )),
                    //     //       Container(
                    //     //         margin: EdgeInsets.only(bottom: 8),
                    //     //         padding: EdgeInsets.only(bottom: 8),
                    //     //         width: MediaQuery.of(context).size.width,
                    //     //         decoration: BoxDecoration(
                    //     //           border: Border(
                    //     //             bottom: BorderSide(
                    //     //               color: Color(0xFF707070).withOpacity(0.35),
                    //     //             ),
                    //     //           ),
                    //     //         ),
                    //     //         child: Text(
                    //     //           "GENERAL",
                    //     //           style: TextStyle(
                    //     //             color: Color(0xFFBF7575),
                    //     //           ),
                    //     //         ),
                    //     //       ),
                    //     //     ],
                    //     //   ),
                    //     // ),
                    //     // SizedBox(
                    //     //   height: 50,
                    //     // ),
                    //     // //Feedback Section
                    //     // Container(
                    //     //   child: Column(
                    //     //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     //     children: [
                    //     //       Container(
                    //     //         margin: EdgeInsets.only(bottom: 8),
                    //     //         padding: EdgeInsets.only(bottom: 8),
                    //     //         width: MediaQuery.of(context).size.width,
                    //     //         decoration: BoxDecoration(
                    //     //           border: Border(
                    //     //             bottom: BorderSide(
                    //     //               color: Color(0xFF707070).withOpacity(0.35),
                    //     //             ),
                    //     //           ),
                    //     //         ),
                    //     //         child: Text(
                    //     //           "FEEDBACK",
                    //     //           style: TextStyle(
                    //     //             color: Color(0xFFBF7575),
                    //     //           ),
                    //     //         ),
                    //     //       ),
                    //     //       FeedbackSubItem(
                    //     //         title: "Contact Us",
                    //     //         onTap: () => launch('https://www.podcastoverhaul.com/contact-us'),
                    //     //       ),
                    //     //       FeedbackSubItem(
                    //     //         title: "Share this app",
                    //     //         onTap: () {
                    //     //           shareApp();
                    //     //         },
                    //     //       )
                    //         ],
                    //       ),
                    //     ),
                    //
                    //     Container(
                    //       margin: EdgeInsets.symmetric(vertical: 50),
                    //       decoration: BoxDecoration(
                    //         image: DecorationImage(
                    //           image: AssetImage("assets/static_assets/logo.png"),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    ))));
  }
}

class FeedbackSubItem extends StatelessWidget {
  final String title;
  final Function onTap;

  FeedbackSubItem({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.only(bottom: 8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF707070).withOpacity(0.35),
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSettingSwitch extends StatelessWidget {
  const CustomSettingSwitch({
    Key key,
    @required this.notificationsSwitch,
    this.onSwitchChange,
    this.title,
  }) : super(key: key);

  final bool notificationsSwitch;
  final Function onSwitchChange;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
      Container(child:Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      )),
      Container(
          margin: EdgeInsets.only(left:5),
          child:  CupertinoSwitch(
            activeColor: Colors.black ,
    trackColor: Colors.white,
    value: notificationsSwitch,
    onChanged: onSwitchChange,
    ),),
    ]);
  }
}
