// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postOffice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostOfficeAdapter extends TypeAdapter<PostOffice> {
  @override
  final int typeId = 1;

  @override
  PostOffice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostOffice(
      postOfficeName: fields[0] as String,
      postOfficeAddress: fields[1] as String,
      accountNumber: fields[2] as String,
      schemeType: fields[3] as String?,
      investmentCategory: fields[4] as String?,
      riskLevel: fields[5] as String?,
      tenure: fields[6] as String?,
      nomineeName: fields[7] as String,
      investmentAmount: fields[8] as double,
      currentValue: fields[9] as double,
      openingDate: fields[10] as DateTime,
      maturityDate: fields[11] as DateTime?,
      interestRate: fields[12] as double,
      remarks: fields[13] as String?,
      createdAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PostOffice obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.postOfficeName)
      ..writeByte(1)
      ..write(obj.postOfficeAddress)
      ..writeByte(2)
      ..write(obj.accountNumber)
      ..writeByte(3)
      ..write(obj.schemeType)
      ..writeByte(4)
      ..write(obj.investmentCategory)
      ..writeByte(5)
      ..write(obj.riskLevel)
      ..writeByte(6)
      ..write(obj.tenure)
      ..writeByte(7)
      ..write(obj.nomineeName)
      ..writeByte(8)
      ..write(obj.investmentAmount)
      ..writeByte(9)
      ..write(obj.currentValue)
      ..writeByte(10)
      ..write(obj.openingDate)
      ..writeByte(11)
      ..write(obj.maturityDate)
      ..writeByte(12)
      ..write(obj.interestRate)
      ..writeByte(13)
      ..write(obj.remarks)
      ..writeByte(14)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostOfficeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
