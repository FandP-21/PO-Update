import 'package:podcast_search/podcast_search.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDatabase {
  Database database;
  SqliteDatabase() {
    initDatabase();
  }

  initDatabase() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'demo.db');

// open the database
      database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE subscribed_podcasts (id INTEGER PRIMARY KEY, trackName TEXT, artistName TEXT, artworkUrl600 TEXT, feedUrl TEXT, guid TEXT)');
      });
      print("Database inititated");
    } catch (e) {
      print("Error at initDatabase@SqliteDatabase: " + e.toString());
    }
  }

  Future<bool> addToSubscribedPodcasts(Item podcast) async {
    bool task = false;
    var isSubscribed = await checkIfPodcastIsSubscribed(podcast.trackName);

    if(!isSubscribed) {
      try {
        // Insert some records in a transaction
        await database.transaction((txn) async {
          int id1 = await txn.rawInsert(
              'INSERT INTO subscribed_podcasts(trackName, artistName, artworkUrl600, feedUrl, guid) VALUES("${podcast
                  .trackName}", "${podcast.artistName}", "${podcast
                  .artworkUrl600}", "${podcast.feedUrl}", "${podcast.guid}")');
          print('inserted1: $id1');
        });
        task = true;
      } catch (e) {}
      return task;
    }
  }

  Future<List<Item>> getSubscribedPodcasts() async {
    while (database == null) {
      await new Future.delayed(const Duration(milliseconds: 500));
    }

    List<Item> listOfPodcasts = [];
    List<Map> list =
        await database.rawQuery('SELECT * FROM subscribed_podcasts');
    list.forEach((element) {
      listOfPodcasts.add(Item(
        trackName: element['trackName'],
        artistName: element['artistName'],
        artworkUrl600: element['artworkUrl600'],
        feedUrl: element['feedUrl'],
      ));
    });
    return listOfPodcasts;
  }

  Future<bool> checkIfPodcastIsSubscribed(String trackName) async {
    while (database == null) {
      await new Future.delayed(const Duration(milliseconds: 500));
    }
    List<Map> list = await database.query('subscribed_podcasts',
        where: 'trackName = ?', whereArgs: [trackName]);
    return list.length > 0;
  }


  Future deletePodcast(String trackName) async {
    while (database == null) {
      await new Future.delayed(const Duration(milliseconds: 500));
    }
    int val = await database.delete('subscribed_podcasts',
        where: 'trackName = ?', whereArgs: [trackName]);
    print(val.toString());
  }
}
