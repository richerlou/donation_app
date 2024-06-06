// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDto _$EventDtoFromJson(Map<String, dynamic> json) => EventDto(
      eventId: json['eventId'] as String?,
      postedBy: json['postedBy'] as String?,
      eventType: json['eventType'] as num?,
      eventTitle: json['eventTitle'] as String?,
      eventDescription: json['eventDescription'] as String?,
      eventPhotoUrl: json['eventPhotoUrl'] as String?,
      eventDate:
          const TimestampConverter().fromJson(json['eventDate'] as Timestamp?),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$EventDtoToJson(EventDto instance) {
  final val = <String, dynamic>{
    'eventId': instance.eventId,
    'postedBy': instance.postedBy,
    'eventType': instance.eventType,
    'eventTitle': instance.eventTitle,
    'eventDescription': instance.eventDescription,
    'eventPhotoUrl': instance.eventPhotoUrl,
    'eventDate': const TimestampConverter().toJson(instance.eventDate),
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
