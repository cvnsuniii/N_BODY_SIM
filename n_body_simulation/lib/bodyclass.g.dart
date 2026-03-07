// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodyclass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BodyDetailsAdapter extends TypeAdapter<BodyDetails> {
  @override
  final int typeId = 0;

  @override
  BodyDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyDetails(
      fields[0] as String,
      (fields[1] as List).cast<double>(),
      (fields[2] as List).cast<double>(),
      (fields[3] as List).cast<double>(),
      fields[4] as double,
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BodyDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lastValue)
      ..writeByte(2)
      ..write(obj.lastVelocities)
      ..writeByte(3)
      ..write(obj.lastAcceleration)
      ..writeByte(4)
      ..write(obj.radius)
      ..writeByte(5)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
