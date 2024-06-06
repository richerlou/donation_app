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
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$JoinedEventDtoToJson(JoinedEventDto instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'joinedEventId': instance.joinedEventId,
    'eventCreatedBy': instance.eventCreatedBy,
    'joinedBy': instance.joinedBy,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'createdAt', const TimestampConverter().toJson(instance.createdAt));
  writeNotNull(
      'updatedAt', const TimestampConverter().toJson(instance.updatedAt));
  return val;
}
