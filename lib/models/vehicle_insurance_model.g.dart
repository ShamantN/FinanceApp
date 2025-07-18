// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_insurance_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleInsuranceModelAdapter extends TypeAdapter<VehicleInsuranceModel> {
  @override
  final int typeId = 5;

  @override
  VehicleInsuranceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleInsuranceModel(
      registration: fields[0] as String,
      model: fields[1] as String,
      engineNumber: fields[2] as String,
      chassisNumber: fields[3] as String,
      manufacturingYear: fields[4] as String,
      engineCC: fields[5] as String,
      nominee: fields[6] as String,
      mobile: fields[7] as String,
      vehicleType: fields[8] as String,
      insuranceType: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleInsuranceModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.registration)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.engineNumber)
      ..writeByte(3)
      ..write(obj.chassisNumber)
      ..writeByte(4)
      ..write(obj.manufacturingYear)
      ..writeByte(5)
      ..write(obj.engineCC)
      ..writeByte(6)
      ..write(obj.nominee)
      ..writeByte(7)
      ..write(obj.mobile)
      ..writeByte(8)
      ..write(obj.vehicleType)
      ..writeByte(9)
      ..write(obj.insuranceType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleInsuranceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
