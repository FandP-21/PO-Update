import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_overhaul/core/routes.dart';
import 'package:podcast_overhaul/ui/screens/player/player-provider.dart';
import 'package:podcast_overhaul/ui/screens/splash-screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _setupFirebaseCrashlytics();

  runApp(
    ChangeNotifierProvider(
      create: (context) => PlayerProvider(),
      child: MyApp(),
    ),
  );
}

_setupFirebaseCrashlytics() async {
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  Function originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    originalOnError(errorDetails);
  };
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podcast Overhaul',
      home: SplashScreen(),
      theme: ThemeData(
        fontFamily: "SEGOE UI",
        sliderTheme: SliderThemeData(
          trackHeight: 1.0,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
        ),
      ),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
