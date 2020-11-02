import 'package:dartz/dartz.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/core/error/failures.dart';
import 'package:rick_and_morty_app/data/repository/local_database_connector.dart';

import 'response_model.dart';

class LocalDataRepository {
  static Future<Either<Failure, Response>> getAllCharactersForPage(
      int page) async {
    try {
      Response response = await LocalDatabaseConnector.getCharacters(page);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  static Future<Either<Failure, Response>> getAllEpisodesForPage(
      int page) async {
    try {
      Response response = await LocalDatabaseConnector.getEpisodes(page);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  static Future<Either<Failure, Response>> getAllLocationsForPage(
      int page) async {
    try {
      Response response = await LocalDatabaseConnector.getLocations(page);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  static Future<Either<Failure, Response>> getAllSpecifiedCharacters(
      List<int> characterIDs) async {
    try {
      Response response =
          await LocalDatabaseConnector.getSpecifiedCharacters(characterIDs);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  static Future<Either<Failure, Response>> getAllSpecifiedEpisodes(
      List<int> episodeIDs) async {
    try {
      Response response =
          await LocalDatabaseConnector.getSpecifiedEpisodes(episodeIDs);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
