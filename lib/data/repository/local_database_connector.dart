import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/data/models/character/character.dart';
import 'package:rick_and_morty_app/data/models/episode/episode.dart';
import 'package:rick_and_morty_app/data/models/location/location.dart';
import 'package:rick_and_morty_app/data/repository/response_model.dart';

class LocalDatabaseConnector {
  static getCharacters(int page) {
    try {
      var box = Hive.box<Character>("characters");
      int length = box.length;
      List<Character> characters = List<Character>();
      for (int i = (page - 1) * 20; i < (page - 1) * 20 + 20; i++) {
        characters.add(box.getAt(i));
      }
      bool hasMore = length > (page) * 20;
      return Response(hasMore, page + 1, characters);
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  static saveCharacters(List<Character> characters) {
    try {
      var box = Hive.box<Character>("characters");
      for (Character character in characters) {
        if (!box.containsKey(character.id)) {
          box.put(character.id, character);
        }
      }
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  static getEpisodes(int page) {
    try {
      var box = Hive.box<Episode>("episodes");
      int length = box.length;
      List<Episode> episodes = List<Episode>();
      for (int i = (page - 1) * 20; i < (page - 1) * 20 + 20; i++) {
        episodes.add(box.getAt(i));
      }
      bool hasMore = length > (page) * 20;
      return Response(hasMore, page + 1, episodes);
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  static getLocations(int page) {
    try {
      var box = Hive.box<Location>("locations");
      int length = box.length;
      List<Location> locations = List<Location>();
      for (int i = (page - 1) * 20; i < (page - 1) * 20 + 20; i++) {
        locations.add(box.getAt(i));
      }
      bool hasMore = length > (page) * 20;
      return Response(hasMore, page + 1, locations);
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  static getSpecifiedCharacters(List<int> characterIDs) {
    try {
      var box = Hive.box<Character>("characters");
      List<Character> characters = List<Character>();
      for (int i in characterIDs) {
        Character character = box.get(i);
        if (character != null) {
          characters.add(character);
        }
      }
      return Response(false, null, characters);
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  static getSpecifiedEpisodes(List<int> episodeIDs) {
    try {
      var box = Hive.box<Episode>("episodes");
      List<Episode> episodes = List<Episode>();
      for (int i in episodeIDs) {
        Episode episode = box.get(i);
        if (episode != null) {
          episodes.add(episode);
        }
      }
      print(episodes);
      return Response(false, null, episodes);
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  static saveEpisodes(List<Episode> episodes) {
    try {
      var box = Hive.box<Episode>("episodes");
      for (Episode episode in episodes) {
        if (!box.containsKey(episode.id)) {
          box.put(episode.id, episode);
        }
      }
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }

  static saveLocations(List<Location> locations) {
    try {
      var box = Hive.box<Location>("locations");
      for (Location location in locations) {
        if (!box.containsKey(location.id)) {
          box.put(location.id, location);
        }
      }
    } catch (e) {
      print(e);
      throw CacheException();
    }
  }
}
