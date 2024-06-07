// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joined_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinedEventDto _$JoinedEventDtoFromJson(Map<String, dynamic> json) =>
    JoinedEventDto(
      id: json['id'] as String?,
      joinedEventId: json['joinedEventId'] as String?,
      eventCreatedBy: json['eventCreatedBy'] as String?,
      joinedBy: json['joinedBy'] as String?,
      joinedEventStatus: json['joinedEventStatus'] as num?,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$JoinedEventDtoToJson(JoinedEventDto instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('joinedEventId', instance.joinedEventId);
  writeNotNull('eventCreatedBy', instance.eventCreatedBy);
  writeNotNull('joinedBy', instance.joinedBy);
  writeNotNull('joinedEventStatus', instance.joinedEventStatus);
  writeNotNull(
      'createdAt', const TimestampConverter().toJson(instance.createdAt));
  writeNotNull(
      'updatedAt', const TimestampConverter().toJson(instance.updatedAt));
  return val;
}
