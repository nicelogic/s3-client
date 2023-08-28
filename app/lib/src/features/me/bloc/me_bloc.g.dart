// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeState _$MeStateFromJson(Map<String, dynamic> json) => MeState(
      me: Me.fromJson(json['me'] as Map<String, dynamic>),
      isAutoStart: json['isAutoStart'] as bool,
      isFirstTime: json['isFirstTime'] as bool,
    );

Map<String, dynamic> _$MeStateToJson(MeState instance) => <String, dynamic>{
      'me': instance.me.toJson(),
      'isAutoStart': instance.isAutoStart,
      'isFirstTime': instance.isFirstTime,
    };
