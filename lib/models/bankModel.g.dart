// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bankModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankAccountModelAdapter extends TypeAdapter<BankAccountModel> {
  @override
  final int typeId = 7;

  @override
  BankAccountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankAccountModel(
      bankName: fields[0] as String,
      branch: fields[1] as String,
      phone: fields[2] as String,
      holder: fields[3] as String,
      number: fields[4] as String,
      nominee: fields[5] as String,
      accountType: fields[6] as String,
      dob: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BankAccountModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bankName)
      ..writeByte(1)
      ..write(obj.branch)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.holder)
      ..writeByte(4)
      ..write(obj.number)
      ..writeByte(5)
      ..write(obj.nominee)
      ..writeByte(6)
      ..write(obj.accountType)
      ..writeByte(7)
      ..write(obj.dob);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankAccountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
