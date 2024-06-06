// ignore_for_file: depend_on_referenced_packages

import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'joined_event_dto.g.dart';

@JsonSerializable()
class JoinedEventDto {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'joinedEventId')
  final String? joinedEventId;

  @JsonKey(name: 'eventCreatedBy')
  final String? eventCreatedBy;

  @JsonKey(name: 'joinedBy')
  final String? joinedBy;

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
    this.createdAt,
    this.updatedAt,
  });

  factory JoinedEventDto.fromJson(Map<String, dynamic> json) =>
      _$JoinedEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JoinedEventDtoToJson(this);
}
