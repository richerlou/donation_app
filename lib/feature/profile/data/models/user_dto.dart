import 'package:donation_management/core/data/converters/timestamp_converter.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'userRole', includeIfNull: false)
  final num? userRole;

  @JsonKey(name: 'firstName', includeIfNull: false)
  final String? firstName;

  @JsonKey(name: 'middleName', includeIfNull: false)
  final String? middleName;

  @JsonKey(name: 'lastName', includeIfNull: false)
  final String? lastName;

  @JsonKey(name: 'organizationName', includeIfNull: false)
  final String? organizationName;

  @JsonKey(name: 'emailAddress')
  final String? emailAddress;

  @JsonKey(name: 'mobileNumber')
  final String? mobileNumber;

  @JsonKey(name: 'profileImage')
  final String? profileImage;

  @JsonKey(name: 'profileDescription')
  final String? profileDescription;

  @JsonKey(name: 'isApproved')
  final bool? isApproved;

  @JsonKey(name: 'createdAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt', includeIfNull: false)
  @TimestampConverter()
  final DateTime? updatedAt;

  UserDto({
    this.userId,
    this.userRole,
    this.firstName,
    this.middleName,
    this.lastName,
    this.organizationName,
    this.emailAddress,
    this.mobileNumber,
    this.profileImage,
    this.profileDescription,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  Map<String, dynamic> toJsonWithoutDates() {
    return {
      'userId': userId,
      'userRole': userRole,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'organizationName': organizationName,
      'emailAddress': emailAddress,
      'mobileNumber': mobileNumber,
      'profileImage': profileImage,
      'profileDescription': profileDescription,
      'isApproved': isApproved,
    };
  }

   UserDto copyWith({bool? isApproved}) {
    return UserDto(
      userId: userId,
      userRole: userRole,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      organizationName: organizationName,
      emailAddress: emailAddress,
      mobileNumber: mobileNumber,
      profileImage: profileImage,
      profileDescription: profileDescription,
      isApproved: isApproved ?? this.isApproved, // Use the updated value or keep the current value
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  UserRole get getUserRole {
    if (userRole == 1) {
      return UserRole.individual;
    } else if (userRole == 2) {
      return UserRole.organization;
    } else {
      return UserRole.admin;
    }
  }
}
