// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAddressAdapter extends TypeAdapter<UserAddress> {
  @override
  final int typeId = 0;

  @override
  UserAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAddress(
      id: fields[0] as String,
      primary: fields[1] as bool,
      name: fields[2] as String,
      state: fields[3] as String,
      city: fields[4] as String,
      neighborhood: fields[5] as String,
      street: fields[6] as String,
      streetNumber: fields[7] as String,
      complement: fields[8] as String,
      reference: fields[9] as String,
      zipcode: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserAddress obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.primary)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.state)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.neighborhood)
      ..writeByte(6)
      ..write(obj.street)
      ..writeByte(7)
      ..write(obj.streetNumber)
      ..writeByte(8)
      ..write(obj.complement)
      ..writeByte(9)
      ..write(obj.reference)
      ..writeByte(10)
      ..write(obj.zipcode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      address: (fields[5] as List)?.cast<UserAddress>(),
      phone: fields[3] as String,
      cpf: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.cpf)
      ..writeByte(5)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
