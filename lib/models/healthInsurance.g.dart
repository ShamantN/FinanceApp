// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'healthInsurance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthInsuranceAdapter extends TypeAdapter<HealthInsurance> {
  @override
  final int typeId = 3;

  @override
  HealthInsurance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthInsurance(
      policyNumber: fields[0] as String,
      fullName: fields[1] as String,
      dob: fields[2] as DateTime,
      age: fields[3] as int,
      height: fields[4] as int,
      weight: fields[5] as int,
      nominee: fields[6] as String,
      mobile: fields[7] as String,
      email: fields[8] as String,
      address: fields[9] as String,
      gender: fields[10] as String,
      insuranceType: fields[11] as String,
      coverageAmount: fields[12] as String,
      medicalCondition: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthInsurance obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.policyNumber)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.dob)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.nominee)
      ..writeByte(7)
      ..write(obj.mobile)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.address)
      ..writeByte(10)
      ..write(obj.gender)
      ..writeByte(11)
      ..write(obj.insuranceType)
      ..writeByte(12)
      ..write(obj.coverageAmount)
      ..writeByte(13)
      ..write(obj.medicalCondition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthInsuranceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
