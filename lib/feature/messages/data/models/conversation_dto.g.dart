// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    ConversationDto(
      conversationId: json['conversationId'] as String?,
      conversationKeys: (json['conversationKeys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isOrganization: json['isOrganization'] as bool?,
      isIndividual: json['isIndividual'] as bool?,
      userIds:
          (json['userIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$ConversationDtoToJson(ConversationDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('conversationId', instance.conversationId);
  writeNotNull('isOrganization', instance.isOrganization);
  writeNotNull('isIndividual', instance.isIndividual);
  writeNotNull('userIds', instance.userIds);
  writeNotNull('conversationKeys', instance.conversationKeys);
  writeNotNull(
      'createdAt', const TimestampConverter().toJson(instance.createdAt));
  writeNotNull(
      'updatedAt', const TimestampConverter().toJson(instance.updatedAt));
  return val;
}
