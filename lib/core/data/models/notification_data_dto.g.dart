// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDto _$NotificationDtoFromJson(Map<String, dynamic> json) =>
    NotificationDto(
      fcmToken: json['to'] as String,
      body: json['notification'] as Map<String, dynamic>,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationDtoToJson(NotificationDto instance) =>
    <String, dynamic>{
      'to': instance.fcmToken,
      'notification': instance.body,
      'data': instance.data,
    };

NotificationBodyDto _$NotificationBodyDtoFromJson(Map<String, dynamic> json) =>
    NotificationBodyDto(
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$NotificationBodyDtoToJson(
        NotificationBodyDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };

NotificationDataDto _$NotificationDataDtoFromJson(Map<String, dynamic> json) =>
    NotificationDataDto(
      action: json['action'] as String,
    );

Map<String, dynamic> _$NotificationDataDtoToJson(
        NotificationDataDto instance) =>
    <String, dynamic>{
      'action': instance.action,
    };
