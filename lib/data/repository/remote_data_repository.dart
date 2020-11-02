import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/core/error/failures.dart';
import 'package:rick_and_morty_app/data/models/character/character.dart';
import 'package:rick_and_morty_app/data/models/episode/episode.dart';
import 'package:rick_and_morty_app/data/models/location/location.dart';
import 'package:rick_and_morty_app/data/repository/local_database_connector.dart';
import 'package:rick_and_morty_app/data/repository/server_connector.dart';

import 'response_model.dart';

class RemoteDataRepository {
  static Future<Either<Failure, Response>> getAllCharactersForPage(
      int page, Map<String, String> filters) async {
    String url = "character/?page=$page";
    for (var key in filters.keys) {
      url = url + "&$key=${filters[key]}";
    }
    print(url);
    try {
      var result = await ServerConnector.getFromServer(url);
      var data = json.decode(result);
      var charactersData = data['results'];
      List<Character> characters = List<Character>();
      for (var e in charactersData) {
        Character character = new Character.fromJsonShort(e);
        characters.add(character);
      }
      LocalDatabaseConnector.saveCharacters(characters);
      Response response =
          Response(data['info']['next'] != null, page + 1, characters);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  static Future<Either<Failure, Response>> getAllEpisodesForPage(
      int page) async {
    String url = "episode/?page=$page";
    print(url);
    try {
      var result = await ServerConnector.getFromServer(url);
      var data = json.decode(result);
      var episodesData = data['results'];
      List<Episode> episodes = List<Episode>();
      for (var e in episodesData) {
        Episode episode = new Episode.fromJsonShort(e);
        episodes.add(episode);
      }
      Response response =
          Response(data['info']['next'] != null, page + 1, episodes);
      LocalDatabaseConnector.saveEpisodes(episodes);

      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  static Future<Either<Failure, Response>> getAllLocationsForPage(
      int page) async {
    String url = "location/?page=$page";
    print(url);
    try {
      var result = await ServerConnector.getFromServer(url);
      var data = json.decode(result);
      var locationsData = data['results'];
      List<Location> locations = List<Location>();
      for (var e in locationsData) {
        Location location = new Location.fromJsonShort(e);
        locations.add(location);
      }
      Response response =
          Response(data['info']['next'] != null, page + 1, locations);
      LocalDatabaseConnector.saveLocations(locations);

      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  static Future<Either<Failure, Response>> getAllSpecifiedCharacters(
      List<int> characterIDs) async {
    String url = "character/";
    for (int characterID in characterIDs) {
      url += "$characterID,";
    }
    print(url);
    try {
      var result = await ServerConnector.getFromServer(url);
      var data = json.decode(result);
      var charactersData = data;
      List<Character> characters = List<Character>();
      for (var e in charactersData) {
        Character character = new Character.fromJsonShort(e);
        characters.add(character);
      }
      Response response = Response(false, null, characters);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  static Future<Either<Failure, Response>> getAllSpecifiedEpisodes(
      List<int> episodeIDs) async {
    String url = "episode/";
    for (int episodeID in episodeIDs) {
      url += "$episodeID,";
    }
    print(url);
    try {
      var result = await ServerConnector.getFromServer(url);
      var data = json.decode(result);
      var episodesData = data;
      List<Episode> episodes = List<Episode>();
      for (var e in episodesData) {
        Episode episode = new Episode.fromJsonShort(e);
        episodes.add(episode);
      }
      Response response = Response(false, null, episodes);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
