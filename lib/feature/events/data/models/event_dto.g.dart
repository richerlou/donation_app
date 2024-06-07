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
      eventStatus: json['eventStatus'] as num?,
      eventStartDateTime: const TimestampConverter()
          .fromJson(json['eventStartDateTime'] as Timestamp?),
      eventEndDateTime: const TimestampConverter()
          .fromJson(json['eventEndDateTime'] as Timestamp?),
      isDonationClosed: json['isDonationClosed'] as bool?,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$EventDtoToJson(EventDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('eventId', instance.eventId);
  writeNotNull('postedBy', instance.postedBy);
  writeNotNull('eventType', instance.eventType);
  writeNotNull('eventTitle', instance.eventTitle);
  writeNotNull('eventDescription', instance.eventDescription);
  writeNotNull('eventPhotoUrl', instance.eventPhotoUrl);
  writeNotNull('eventStatus', instance.eventStatus);
  writeNotNull('eventStartDateTime',
      const TimestampConverter().toJson(instance.eventStartDateTime));
  writeNotNull('eventEndDateTime',
      const TimestampConverter().toJson(instance.eventEndDateTime));
  writeNotNull('isDonationClosed', instance.isDonationClosed);
  writeNotNull(
      'createdAt', const TimestampConverter().toJson(instance.createdAt));
  writeNotNull(
      'updatedAt', const TimestampConverter().toJson(instance.updatedAt));
  return val;
}
