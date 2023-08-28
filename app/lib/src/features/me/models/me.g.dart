// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Me _$MeFromJson(Map<String, dynamic> json) => Me(
      name: json['name'] as String,
      pwd: json['pwd'] as String,
      backupDirPath: json['backupDirPath'] as String,
    );

Map<String, dynamic> _$MeToJson(Me instance) => <String, dynamic>{
      'name': instance.name,
      'pwd': instance.pwd,
      'backupDirPath': instance.backupDirPath,
    };
