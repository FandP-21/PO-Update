import 'package:flutter/material.dart';
import 'package:podcast_overhaul/core/models/discover-extended.dart';
import 'package:podcast_overhaul/core/models/gardient-category.dart';
import 'package:podcast_overhaul/core/models/player-info.dart';
import 'package:podcast_overhaul/ui/custom-widgets/base-screen.dart';
import 'package:podcast_overhaul/ui/screens/category/category-podcasts.dart';
import 'package:podcast_overhaul/ui/screens/category/category-screen.dart';
import 'package:podcast_overhaul/ui/screens/community/community-screen.dart';
import 'package:podcast_overhaul/ui/screens/discover-extended/discover-extended-screen.dart';
import 'package:podcast_overhaul/ui/screens/discover/discover-screen.dart';
import 'package:podcast_overhaul/ui/screens/episode/episode-screen.dart';
import 'package:podcast_overhaul/ui/screens/library/my-library-screen.dart';
import 'package:podcast_overhaul/ui/screens/player/player-screen.dart';
import 'package:podcast_overhaul/ui/screens/random-podcast/random-podcast.dart';
import 'package:podcast_overhaul/ui/screens/search/search-screen.dart';
import 'package:podcast_overhaul/ui/screens/settings/settings-screen.dart';
import 'package:podcast_overhaul/ui/screens/splash-screen.dart';
import 'package:podcast_search/podcast_search.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/base" :
              return MaterialPageRoute(builder: (_) => BaseScreen());

      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case 'discover':
        return MaterialPageRoute(builder: (_) => DiscoverScreen());
      case 'discover-extended':
        DiscoverExtended arg = settings.arguments as DiscoverExtended;
        return MaterialPageRoute(
            builder: (_) => DiscoverExtendedScreen(arg: arg));
      case 'search':
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case 'category':
        return MaterialPageRoute(builder: (_) => CategoryScreen());
      case 'category-podcasts':
        var gradientCategory = settings.arguments as GradientCategory;
        return MaterialPageRoute(
          builder: (_) =>
              CategoryPodcastsScreen(gradientCategory: gradientCategory),
        );
      case 'episode':
        var episodeInfo = settings.arguments as Item;
        return MaterialPageRoute(
            builder: (_) => EpisodeScreen(podcastInfo: episodeInfo));
      case 'my-library':
        return MaterialPageRoute(builder: (_) => MyLibraryScreen());
      case 'community':
        return MaterialPageRoute(builder: (_) => CommunityScreen());
      case 'settings':
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case 'dialog-category':
        return CategoryScreenDialog();
      case 'player':
        PlayerInfo arg = settings.arguments as PlayerInfo;
        return MaterialPageRoute(
          builder: (_) =>
              PlayerScreen(episode: arg.episode, podcastInfo: arg.item),
        );
      case 'random-podcast':
        return MaterialPageRoute(builder: (_) => RandomPodcast());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
