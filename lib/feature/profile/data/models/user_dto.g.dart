// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      userId: json['userId'] as String?,
      userRole: json['userRole'] as num?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      organizationName: json['organizationName'] as String?,
      emailAddress: json['emailAddress'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      profileImage: json['profileImage'] as String?,
      profileDescription: json['profileDescription'] as String?,
      isApproved: json['isApproved'] as bool?,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) {
  final val = <String, dynamic>{
    'userId': instance.userId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userRole', instance.userRole);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('middleName', instance.middleName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('organizationName', instance.organizationName);
  val['emailAddress'] = instance.emailAddress;
  val['mobileNumber'] = instance.mobileNumber;
  val['profileImage'] = instance.profileImage;
  val['profileDescription'] = instance.profileDescription;
  val['isApproved'] = instance.isApproved;
  writeNotNull(
      'createdAt', const TimestampConverter().toJson(instance.createdAt));
  writeNotNull(
      'updatedAt', const TimestampConverter().toJson(instance.updatedAt));
  return val;
}
