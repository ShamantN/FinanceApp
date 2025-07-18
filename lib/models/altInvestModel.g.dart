// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'altInvestModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AltInvestModelAdapter extends TypeAdapter<AltInvestModel> {
  @override
  final int typeId = 6;

  @override
  AltInvestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AltInvestModel(
      nameOfAMC: fields[0] as String,
      registeredEmail: fields[1] as String,
      folio: fields[2] as String,
      nominee: fields[3] as String,
      investmentAmt: fields[4] as int,
      currentValue: fields[5] as int,
      purchaseDate: fields[6] as DateTime,
      maturityDate: fields[7] as DateTime,
      expectedReturn: fields[8] as int,
      remarks: fields[9] as String,
      fundType: fields[10] as String,
      category: fields[11] as String,
      riskLevel: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AltInvestModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.nameOfAMC)
      ..writeByte(1)
      ..write(obj.registeredEmail)
      ..writeByte(2)
      ..write(obj.folio)
      ..writeByte(3)
      ..write(obj.nominee)
      ..writeByte(4)
      ..write(obj.investmentAmt)
      ..writeByte(5)
      ..write(obj.currentValue)
      ..writeByte(6)
      ..write(obj.purchaseDate)
      ..writeByte(7)
      ..write(obj.maturityDate)
      ..writeByte(8)
      ..write(obj.expectedReturn)
      ..writeByte(9)
      ..write(obj.remarks)
      ..writeByte(10)
      ..write(obj.fundType)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.riskLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AltInvestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
