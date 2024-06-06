import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'message_dto.g.dart';

@JsonSerializable()
class MessageDto {
  @JsonKey(name: 'messageId')
  final String? messageId;

  @JsonKey(name: 'senderId')
  final String? senderId;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'createdAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? updatedAt;

  MessageDto({
    this.messageId,
    this.senderId,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}
