import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'event_dto.g.dart';

@JsonSerializable()
class EventDto {
  @JsonKey(name: 'eventId')
  final String? eventId;

  @JsonKey(name: 'postedBy')
  final String? postedBy;

  @JsonKey(name: 'eventType')
  final num? eventType;

  @JsonKey(name: 'eventTitle')
  final String? eventTitle;

  @JsonKey(name: 'eventDescription')
  final String? eventDescription;

  @JsonKey(name: 'eventPhotoUrl')
  final String? eventPhotoUrl;

  @JsonKey(name: 'eventDate')
  @TimestampConverter()
  final DateTime? eventDate;

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
    this.eventDate,
    this.createdAt,
    this.updatedAt,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventDtoToJson(this);
}
