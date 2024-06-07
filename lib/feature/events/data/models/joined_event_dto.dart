import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'joined_event_dto.g.dart';

@JsonSerializable()
class JoinedEventDto {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'joinedEventId', includeIfNull: false)
  final String? joinedEventId;

  @JsonKey(name: 'eventCreatedBy', includeIfNull: false)
  final String? eventCreatedBy;

  @JsonKey(name: 'joinedBy', includeIfNull: false)
  final String? joinedBy;

  @JsonKey(name: 'joinedEventStatus', includeIfNull: false)
  final num? joinedEventStatus;

  @JsonKey(name: 'createdAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? updatedAt;

  JoinedEventDto({
    this.id,
    this.joinedEventId,
    this.eventCreatedBy,
    this.joinedBy,
    this.joinedEventStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory JoinedEventDto.fromJson(Map<String, dynamic> json) =>
      _$JoinedEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JoinedEventDtoToJson(this);
}
