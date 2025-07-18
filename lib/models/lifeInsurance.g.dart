// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifeInsurance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LifeInsuranceAdapter extends TypeAdapter<LifeInsurance> {
  @override
  final int typeId = 2;

  @override
  LifeInsurance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LifeInsurance(
      policyHolderName: fields[0] as String,
      nomineeName: fields[1] as String,
      policyNumber: fields[2] as String,
      insuredCompanyName: fields[3] as String,
      policyType: fields[4] as String,
      issueDate: fields[5] as DateTime,
      maturityDate: fields[6] as DateTime,
      amtInsured: fields[7] as double,
      premiumAmt: fields[8] as double,
      premiumFreq: fields[9] as String,
      remarks: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LifeInsurance obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.policyHolderName)
      ..writeByte(1)
      ..write(obj.nomineeName)
      ..writeByte(2)
      ..write(obj.policyNumber)
      ..writeByte(3)
      ..write(obj.insuredCompanyName)
      ..writeByte(4)
      ..write(obj.policyType)
      ..writeByte(5)
      ..write(obj.issueDate)
      ..writeByte(6)
      ..write(obj.maturityDate)
      ..writeByte(7)
      ..write(obj.amtInsured)
      ..writeByte(8)
      ..write(obj.premiumAmt)
      ..writeByte(9)
      ..write(obj.premiumFreq)
      ..writeByte(10)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifeInsuranceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
