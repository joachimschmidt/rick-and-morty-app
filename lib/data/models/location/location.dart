import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'location.g.dart';

@HiveType(typeId: 3)
class Location extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String dimension;
  @HiveField(4)
  final List residents;
  @HiveField(5)
  final String url;

  Location(
      {this.id,
      @required this.name,
      this.type,
      this.dimension,
      @required this.url,
      this.residents});

  @override
  List<Object> get props => [];

  Location.fromJsonShort(
    Map<String, dynamic> json,
  )   : name = json['name'],
        id = json['id'],
        type = json['type'],
        dimension = json['dimension'],
        residents = json['residents'],
        url = json['url'];
}
