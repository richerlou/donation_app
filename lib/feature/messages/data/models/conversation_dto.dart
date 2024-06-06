import 'package:donation_management/core/data/converters/field_value_converter.dart';
import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'conversation_dto.g.dart';

@JsonSerializable()
class ConversationDto {
  @JsonKey(name: 'conversationId')
  final String? conversationId;

  @JsonKey(name: 'userIds')
  @FieldValueConverter()
  final List<String>? userIds;

  @JsonKey(name: 'createdAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? updatedAt;

  ConversationDto({
    this.conversationId,
    this.userIds,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationDtoToJson(this);
}
