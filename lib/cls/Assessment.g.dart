// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Assessment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssessmentAdapter extends TypeAdapter<Assessment> {
  @override
  final int typeId = 1;

  @override
  Assessment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assessment(
      fields[0] as String,
      fields[1] as int,
      fields[2] as double,
      fields[4] as String,
      fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Assessment obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.assessmentName)
      ..writeByte(1)
      ..write(obj.assessmentPercentageOfModule)
      ..writeByte(2)
      ..write(obj.markPercentageOfAssessment)
      ..writeByte(3)
      ..write(obj.taken)
      ..writeByte(4)
      ..write(obj.assessmentType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
