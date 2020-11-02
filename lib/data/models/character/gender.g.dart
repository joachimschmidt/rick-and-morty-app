// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gender.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GenderAdapter extends TypeAdapter<Gender> {
  @override
  final int typeId = 5;

  @override
  Gender read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Gender.Female;
      case 1:
        return Gender.Male;
      case 2:
        return Gender.Genderless;
      case 3:
        return Gender.Unknown;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Gender obj) {
    switch (obj) {
      case Gender.Female:
        writer.writeByte(0);
        break;
      case Gender.Male:
        writer.writeByte(1);
        break;
      case Gender.Genderless:
        writer.writeByte(2);
        break;
      case Gender.Unknown:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
