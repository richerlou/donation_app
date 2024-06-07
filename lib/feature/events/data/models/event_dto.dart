import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'event_dto.g.dart';

@JsonSerializable()
class EventDto {
  @JsonKey(name: 'eventId', includeIfNull: false)
  final String? eventId;

  @JsonKey(name: 'postedBy', includeIfNull: false)
  final String? postedBy;

  @JsonKey(name: 'eventType', includeIfNull: false)
  final num? eventType;

  @JsonKey(name: 'eventTitle', includeIfNull: false)
  final String? eventTitle;

  @JsonKey(name: 'eventDescription', includeIfNull: false)
  final String? eventDescription;

  @JsonKey(name: 'eventPhotoUrl', includeIfNull: false)
  final String? eventPhotoUrl;

  @JsonKey(name: 'eventStatus', includeIfNull: false)
  final num? eventStatus;

  @JsonKey(name: 'eventStartDateTime', includeIfNull: false)
  @TimestampConverter()
  final DateTime? eventStartDateTime;

  @JsonKey(name: 'eventEndDateTime', includeIfNull: false)
  @TimestampConverter()
  final DateTime? eventEndDateTime;

  @JsonKey(name: 'isDonationClosed', includeIfNull: false)
  final bool? isDonationClosed;

  @JsonKey(name: 'createdAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? updatedAt;

  EventDto({
    this.eventId,
    this.postedBy,
    this.eventType,
    this.eventTitle,
    this.eventDescription,
    this.eventPhotoUrl,
    this.eventStatus,
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.isDonationClosed,
    this.createdAt,
    this.updatedAt,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventDtoToJson(this);
}
