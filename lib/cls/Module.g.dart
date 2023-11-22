// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Module.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleAdapter extends TypeAdapter<Module> {
  @override
  final int typeId = 0;

  @override
  Module read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Module(
      fields[4] as bool,
      fields[5] as bool,
    )
      ..moduleName = fields[0] as String?
      ..moduleCode = fields[1] as String?
      ..credits = fields[2] as int?
      ..level = fields[3] as String?
      ..assessments = (fields[6] as List).cast<Assessment>();
  }

  @override
  void write(BinaryWriter writer, Module obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.moduleName)
      ..writeByte(1)
      ..write(obj.moduleCode)
      ..writeByte(2)
      ..write(obj.credits)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.isQuickEdit)
      ..writeByte(5)
      ..write(obj.isListedToUser)
      ..writeByte(6)
      ..write(obj.assessments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
