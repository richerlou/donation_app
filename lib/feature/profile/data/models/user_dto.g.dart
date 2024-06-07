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
      barangay: json['barangay'] as String?,
      organizationName: json['organizationName'] as String?,
      organizationLocation: json['organizationLocation'] as String?,
      organizationType: json['organizationType'] as String?,
      organizationWebsite: json['organizationWebsite'] as String?,
      organizationRepName1: json['organizationRepName1'] as String?,
      organizationRepLocation1: json['organizationRepLocation1'] as String?,
      organizationRepMobileNumber1:
          json['organizationRepMobileNumber1'] as String?,
      organizationRepName2: json['organizationRepName2'] as String?,
      organizationRepLocation2: json['organizationRepLocation2'] as String?,
      organizationRepMobileNumber2:
          json['organizationRepMobileNumber2'] as String?,
      emailAddress: json['emailAddress'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      profileImage: json['profileImage'] as String?,
      profileDescription: json['profileDescription'] as String?,
      fcmToken: json['fcmToken'] as String?,
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
  writeNotNull('barangay', instance.barangay);
  writeNotNull('organizationName', instance.organizationName);
  writeNotNull('organizationLocation', instance.organizationLocation);
  writeNotNull('organizationType', instance.organizationType);
  writeNotNull('organizationWebsite', instance.organizationWebsite);
  writeNotNull('organizationRepName1', instance.organizationRepName1);
  writeNotNull('organizationRepLocation1', instance.organizationRepLocation1);
  writeNotNull(
      'organizationRepMobileNumber1', instance.organizationRepMobileNumber1);
  writeNotNull('organizationRepName2', instance.organizationRepName2);
  writeNotNull('organizationRepLocation2', instance.organizationRepLocation2);
  writeNotNull(
      'organizationRepMobileNumber2', instance.organizationRepMobileNumber2);
  val['emailAddress'] = instance.emailAddress;
  val['mobileNumber'] = instance.mobileNumber;
  val['profileImage'] = instance.profileImage;
  val['profileDescription'] = instance.profileDescription;
  val['fcmToken'] = instance.fcmToken;
  val['isApproved'] = instance.isApproved;
  writeNotNull(
      'createdAt', const TimestampConverter().toJson(instance.createdAt));
  writeNotNull(
      'updatedAt', const TimestampConverter().toJson(instance.updatedAt));
  return val;
}
