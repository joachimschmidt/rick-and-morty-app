import 'package:hive/hive.dart';

part 'status.g.dart';

@HiveType(typeId: 4)
enum Status {
  @HiveField(0)
  Alive,
  @HiveField(1)
  Dead,
  @HiveField(2)
  Unknown
}
